#!/usr/bin/env bash
# kai-intel / graph.sh — CRUD sobre .kai/intel/graph.json
# Subcomandos: add, query, export

set -eo pipefail

GRAPH_DIR=".kai/intel"
GRAPH_FILE="$GRAPH_DIR/graph.json"

ensure_graph() {
  mkdir -p "$GRAPH_DIR"
  [[ -f "$GRAPH_FILE" ]] || echo '{"nodes":[],"next_id":1}' > "$GRAPH_FILE"
}

cmd_add() {
  local type="${1:-}"; shift || true
  local title="${1:-}"; shift || true
  if [[ -z "$type" || -z "$title" ]]; then
    echo "uso: kai-graph-add <type> \"<title>\" [--tags t1,t2] [--squad s] [--links id1,id2] [--body \"...\"]" >&2
    exit 2
  fi

  local valid_types="decision learning spec incident runbook dependency"
  if ! echo "$valid_types" | grep -qw "$type"; then
    echo "tipo inválido: $type (use: $valid_types)" >&2
    exit 2
  fi

  local tags="" squad="" links="" body=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --tags) tags="$2"; shift 2 ;;
      --squad) squad="$2"; shift 2 ;;
      --links) links="$2"; shift 2 ;;
      --body) body="$2"; shift 2 ;;
      *) echo "flag desconhecida: $1" >&2; exit 2 ;;
    esac
  done

  ensure_graph

  local now
  now=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  local actor
  actor=$(git config user.email 2>/dev/null || echo "unknown")

  local tags_arr links_arr
  tags_arr=$(echo "$tags"  | tr ',' '\n' | awk 'NF' | jq -R . | jq -s . 2>/dev/null || echo '[]')
  links_arr=$(echo "$links" | tr ',' '\n' | awk 'NF' | jq -R . | jq -s . 2>/dev/null || echo '[]')
  [[ -z "$tags_arr" ]] && tags_arr='[]'
  [[ -z "$links_arr" ]] && links_arr='[]'

  local id
  id=$(jq -r '.next_id' "$GRAPH_FILE")
  local node_id="N-$id"

  local tmp
  tmp=$(mktemp)
  jq \
    --arg id "$node_id" \
    --arg type "$type" \
    --arg title "$title" \
    --arg body "$body" \
    --arg squad "$squad" \
    --arg ts "$now" \
    --arg actor "$actor" \
    --argjson tags "$tags_arr" \
    --argjson links "$links_arr" \
    '
    .nodes += [{
      id: $id,
      type: $type,
      title: $title,
      body: $body,
      tags: $tags,
      squad: $squad,
      links: $links,
      ts: $ts,
      actor: $actor
    }]
    | .next_id += 1
    ' "$GRAPH_FILE" > "$tmp" && mv "$tmp" "$GRAPH_FILE"

  echo "$node_id"
}

cmd_query() {
  ensure_graph
  local type="" tag="" squad="" text="" json=0
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --type) type="$2"; shift 2 ;;
      --tag) tag="$2"; shift 2 ;;
      --squad) squad="$2"; shift 2 ;;
      --text) text="$2"; shift 2 ;;
      --json) json=1; shift ;;
      *) echo "flag desconhecida: $1" >&2; exit 2 ;;
    esac
  done

  local filtered
  filtered=$(jq \
    --arg type "$type" \
    --arg tag "$tag" \
    --arg squad "$squad" \
    --arg text "$(echo "$text" | tr '[:upper:]' '[:lower:]')" \
    '
    .nodes
    | map(select(($type == "") or (.type == $type)))
    | map(select(($tag == "") or (.tags | index($tag))))
    | map(select(($squad == "") or (.squad == $squad)))
    | map(select(
        ($text == "") or
        ((.title + " " + (.body // "") + " " + ((.tags // []) | join(" "))) | ascii_downcase | contains($text))
      ))
    ' "$GRAPH_FILE")

  if [[ "$json" -eq 1 ]]; then
    echo "$filtered"
    return
  fi

  local count
  count=$(echo "$filtered" | jq 'length')
  printf "%s nó(s):\n\n" "$count"
  echo "$filtered" | jq -r '.[] | "\(.id) [\(.type)] \(.title)" + (if .squad != "" then "  · squad=\(.squad)" else "" end) + (if (.tags|length)>0 then "  · tags=\(.tags|join(","))" else "" end)'
}

cmd_export() {
  ensure_graph
  local format="dot"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --format) format="$2"; shift 2 ;;
      *) echo "flag desconhecida: $1" >&2; exit 2 ;;
    esac
  done

  case "$format" in
    json)
      cat "$GRAPH_FILE"
      ;;
    dot)
      echo "digraph kai_intel {"
      echo "  rankdir=LR;"
      echo "  node [shape=box,style=rounded,fontname=\"Helvetica\"];"
      jq -r '.nodes[] | "  \"\(.id)\" [label=\"\(.id)\\n\(.title | gsub("\""; "\\\""))\\n[\(.type)]\"];"' "$GRAPH_FILE"
      jq -r '.nodes[] | . as $n | .links[]? | "  \"\($n.id)\" -> \"\(.)\";"' "$GRAPH_FILE"
      echo "}"
      ;;
    mermaid)
      echo "graph LR"
      jq -r '.nodes[] | "  \(.id)[\"\(.id): \(.title | gsub("\""; "&quot;"))\"]"' "$GRAPH_FILE"
      jq -r '.nodes[] | . as $n | .links[]? | "  \($n.id) --> \(.)"' "$GRAPH_FILE"
      ;;
    *)
      echo "formato inválido: $format (use dot|mermaid|json)" >&2
      exit 2
      ;;
  esac
}

main() {
  local sub="${1:-}"; shift || true
  case "$sub" in
    add) cmd_add "$@" ;;
    query) cmd_query "$@" ;;
    export) cmd_export "$@" ;;
    "") echo "uso: graph.sh <add|query|export> ..." >&2; exit 2 ;;
    *) echo "subcomando inválido: $sub" >&2; exit 2 ;;
  esac
}

main "$@"
