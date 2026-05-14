#!/usr/bin/env bash
# kai-intel / search.sh — BM25 lexical search sobre .kai/, specs, retros, decisões
# Estrutura preparada para upgrade futuro a embeddings (v2.5+) sem mudar interface.

set -eo pipefail

INDEX_DIR=".kai/intel"
INDEX_FILE="$INDEX_DIR/search-index.json"
GRAPH_FILE="$INDEX_DIR/graph.json"

# BM25 params
K1=1.5
B=0.75

# Stop-words PT-BR mínimo + EN comum
STOPWORDS_RE='^(a|o|as|os|um|uma|de|da|do|das|dos|em|na|no|nas|nos|e|ou|para|por|com|sem|que|se|é|the|of|to|and|or|in|on|at|is|are|was|were)$'

usage() {
  cat <<EOF >&2
uso: kai-search "<query>" [--limit N] [--reindex] [--json] [--audit]
EOF
  exit 2
}

tokenize() {
  # lowercase, split on non-alnum, drop stopwords + tokens <2 chars
  tr '[:upper:]' '[:lower:]' \
    | tr -c '[:alnum:]\n' '\n' \
    | grep -E '.{2,}' \
    | grep -Ev "$STOPWORDS_RE" || true
}

build_index() {
  mkdir -p "$INDEX_DIR"
  local docs_json='[]'
  local df_acc_file
  df_acc_file=$(mktemp)
  : > "$df_acc_file"

  local files_list
  files_list=$(mktemp)
  {
    [[ -f "$GRAPH_FILE" ]] && echo "$GRAPH_FILE"
    for d in docs/specs/_active docs/specs/_completed docs/playbooks docs/runbooks; do
      [[ -d "$d" ]] && find "$d" -type f -name "*.md" 2>/dev/null
    done
    if [[ "${INCLUDE_AUDIT:-0}" -eq 1 && -d .kai/audit ]]; then
      find .kai/audit -type f -name "*.log" 2>/dev/null
    fi
  } | sort -u > "$files_list" || true

  local total_len=0
  local doc_count=0

  while IFS= read -r f; do
    [[ -z "$f" || ! -e "$f" ]] && continue
    local content
    if [[ "$f" == "$GRAPH_FILE" ]]; then
      content=$(jq -r '.nodes[]? | "\(.title) \(.body // "") \((.tags // []) | join(" "))"' "$f" 2>/dev/null || true)
    else
      content=$(cat "$f" 2>/dev/null || true)
    fi
    [[ -z "$content" ]] && continue

    local tokens
    tokens=$(printf '%s' "$content" | tokenize)
    [[ -z "$tokens" ]] && continue

    local tf_json dl
    tf_json=$(printf '%s\n' "$tokens" | sort | uniq -c | awk '{print "{\"" $2 "\":" $1 "}"}' | jq -s 'add // {}')
    dl=$(printf '%s\n' "$tokens" | wc -l | tr -d ' ')

    doc_count=$((doc_count + 1))
    total_len=$((total_len + dl))

    # accumulate unique tokens of this doc into df file
    printf '%s\n' "$tokens" | sort -u >> "$df_acc_file"

    docs_json=$(echo "$docs_json" | jq \
      --arg path "$f" \
      --argjson tf "$tf_json" \
      --argjson dl "$dl" \
      '. + [{path: $path, tf: $tf, dl: $dl}]')
  done < "$files_list"

  # Compute df from accumulator: sort | uniq -c → token count = df
  local df_json
  df_json=$(sort "$df_acc_file" | uniq -c | awk '{print "{\""$2"\":"$1"}"}' | jq -s 'add // {}')

  local avgdl=0
  [[ $doc_count -gt 0 ]] && avgdl=$((total_len / doc_count))

  jq -n \
    --argjson docs "$docs_json" \
    --argjson df "$df_json" \
    --argjson n "$doc_count" \
    --argjson avgdl "$avgdl" \
    '{docs: $docs, df: $df, N: $n, avgdl: $avgdl}' > "$INDEX_FILE"

  rm -f "$files_list" "$df_acc_file"
}

index_stale() {
  [[ ! -f "$INDEX_FILE" ]] && return 0
  # rebuild se índice >24h
  local now mtime
  now=$(date +%s)
  mtime=$(stat -f %m "$INDEX_FILE" 2>/dev/null || stat -c %Y "$INDEX_FILE" 2>/dev/null || echo 0)
  (( now - mtime > 86400 ))
}

cmd_search() {
  local query="" limit=10 json=0 reindex=0
  export INCLUDE_AUDIT=0
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --limit) limit="$2"; shift 2 ;;
      --json) json=1; shift ;;
      --reindex) reindex=1; shift ;;
      --audit) INCLUDE_AUDIT=1; shift ;;
      -*) echo "flag desconhecida: $1" >&2; exit 2 ;;
      *) query="$query $1"; shift ;;
    esac
  done
  query="${query# }"

  if [[ -z "$query" && "$reindex" -eq 0 ]]; then usage; fi

  if [[ "$reindex" -eq 1 ]] || index_stale; then
    echo "indexando..." >&2
    build_index
  fi

  [[ -z "$query" ]] && { echo "índice reconstruído." >&2; return; }

  [[ ! -s "$INDEX_FILE" ]] && { echo "índice vazio. Nada a buscar." >&2; return; }

  local query_tokens
  query_tokens=$(printf '%s' "$query" | tokenize)
  [[ -z "$query_tokens" ]] && { echo "query vazia após tokenização." >&2; exit 2; }

  local q_json
  q_json=$(printf '%s\n' "$query_tokens" | jq -R . | jq -s .)

  local results
  results=$(jq \
    --argjson q "$q_json" \
    --argjson k1 "$K1" \
    --argjson b "$B" \
    --argjson limit "$limit" \
    '
    . as $idx
    | .docs
    | map(
        . as $d
        | {
            path: .path,
            score: (
              ($q | map(
                . as $tok
                | (($idx.df[$tok] // 0) | . as $df
                  | if $df == 0 then 0
                    else
                      (((($idx.N - $df + 0.5) / ($df + 0.5)) + 1) | log) as $idf
                      | ($d.tf[$tok] // 0) as $tf
                      | ($tf * ($k1 + 1)) / ($tf + $k1 * (1 - $b + $b * ($d.dl / ($idx.avgdl + 0.0001))))
                      | . * $idf
                    end
                  )
              ) | add)
            )
          }
      )
    | map(select(.score > 0))
    | sort_by(-.score)
    | .[0:$limit]
    ' "$INDEX_FILE")

  if [[ "$json" -eq 1 ]]; then
    echo "$results"
    return
  fi

  local count
  count=$(echo "$results" | jq 'length')
  printf "%s resultado(s) para \"%s\":\n\n" "$count" "$query"
  echo "$results" | jq -r '.[] | "  [\(.score | (. * 100 | floor) / 100)] \(.path)"'
}

cmd_search "$@"
