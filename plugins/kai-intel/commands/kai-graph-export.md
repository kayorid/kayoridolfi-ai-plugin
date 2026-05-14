---
description: Exporta o knowledge graph em DOT (Graphviz), Mermaid ou JSON cru
argument-hint: [--format dot|mermaid|json]
---

# /kai-graph-export

Exporta o grafo para visualização externa.

## Uso

```bash
/kai-graph-export --format dot > graph.dot && dot -Tpng graph.dot -o graph.png
/kai-graph-export --format mermaid           # cola em GitHub/Notion
/kai-graph-export --format json              # raw
```

## Execução

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/graph.sh" export "$@"
```
