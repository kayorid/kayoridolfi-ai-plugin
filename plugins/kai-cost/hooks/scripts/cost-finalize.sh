#!/usr/bin/env bash
# kai-cost / cost-finalize
# Hook Stop/SessionEnd: lê transcript JSONL e agrega usage real da sessão.
# Resolve limitação conhecida da v1.x (cost-capture PostToolUse pega só payloads parciais).
# Não-bloqueante; append em .kai/audit/cost.log com fonte="transcript".

set -eo pipefail

INPUT="$(cat 2>/dev/null || echo '{}')"

# transcript_path vem do hook payload (Claude Code Stop/SessionEnd)
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // empty' 2>/dev/null)
[[ -z "$TRANSCRIPT" || ! -f "$TRANSCRIPT" ]] && exit 0

# Snapshot de preço
PRICE_IN="${KAI_PRICE_IN:-3.00}"
PRICE_OUT="${KAI_PRICE_OUT:-15.00}"
RATE="${KAI_USD_BRL:-5.30}"
ACTOR=$(git config user.email 2>/dev/null || echo "unknown")

# Detecta feature + fase
FEATURE="unknown"
PHASE="unknown"
LATEST=$(find docs/specs/_active -maxdepth 1 -mindepth 1 -type d 2>/dev/null | sort | tail -1 || true)
if [[ -n "$LATEST" ]]; then
  FEATURE=$(basename "$LATEST" | sed 's/^[0-9-]*//')
  if [[ -f "$LATEST/retro.md" ]]; then PHASE="RETRO"
  elif [[ -f "$LATEST/REVIEW.md" ]]; then PHASE="REVIEW"
  elif [[ -f "$LATEST/verification.md" ]]; then PHASE="VERIFY"
  elif [[ -f "$LATEST/execution.log" ]]; then PHASE="EXECUTE"
  elif [[ -f "$LATEST/tasks.md" ]]; then PHASE="PLAN"
  elif [[ -f "$LATEST/design.md" ]]; then PHASE="DESIGN"
  elif [[ -f "$LATEST/requirements.md" ]]; then PHASE="SPEC"
  elif [[ -f "$LATEST/discuss.md" ]]; then PHASE="DISCUSS"
  fi
fi

# Agrega usage por modelo a partir de TODAS as mensagens com usage no transcript
# Transcript Claude Code é JSONL — cada linha é um evento
USAGE_AGG=$(jq -s '
  [.[]
   | select(.message.usage? // .usage?)
   | (.message.usage // .usage) as $u
   | {
       model: (.message.model // .model // "unknown"),
       in:  ($u.input_tokens // $u.prompt_tokens // 0),
       out: ($u.output_tokens // $u.completion_tokens // 0),
       cache_in: ($u.cache_creation_input_tokens // 0),
       cache_read: ($u.cache_read_input_tokens // 0)
     }
  ]
  | group_by(.model)
  | map({
      model: .[0].model,
      in: (map(.in) | add // 0),
      out: (map(.out) | add // 0),
      cache_in: (map(.cache_in) | add // 0),
      cache_read: (map(.cache_read) | add // 0)
    })
  | map(select(.in > 0 or .out > 0))
' "$TRANSCRIPT" 2>/dev/null || echo '[]')

COUNT=$(echo "$USAGE_AGG" | jq 'length')
[[ "$COUNT" -eq 0 ]] && exit 0

mkdir -p .kai/audit
NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# Escreve uma linha por modelo
echo "$USAGE_AGG" | jq -c '.[]' | while IFS= read -r row; do
  MODEL=$(echo "$row" | jq -r '.model')
  IN_TOK=$(echo "$row" | jq -r '.in')
  OUT_TOK=$(echo "$row" | jq -r '.out')
  CACHE_IN=$(echo "$row" | jq -r '.cache_in')
  CACHE_READ=$(echo "$row" | jq -r '.cache_read')

  SAFE_MODEL=$(printf '%s' "$MODEL" | tr -d '\n|' | head -c 64)
  SAFE_FEATURE=$(printf '%s' "$FEATURE" | tr -d '\n|' | head -c 64)

  printf '%s | feature=%s | phase=%s | tool=session | in_tokens=%s | out_tokens=%s | cache_in=%s | cache_read=%s | model=%s | actor=%s | price_in=%s | price_out=%s | rate=%s | source=transcript\n' \
    "$NOW" "$SAFE_FEATURE" "$PHASE" "$IN_TOK" "$OUT_TOK" "$CACHE_IN" "$CACHE_READ" "$SAFE_MODEL" "$ACTOR" "$PRICE_IN" "$PRICE_OUT" "$RATE" \
    >> .kai/audit/cost.log
done

exit 0
