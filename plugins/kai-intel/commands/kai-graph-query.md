---
description: Consulta o knowledge graph por tipo, tag, squad ou texto
argument-hint: [--type T] [--tag T] [--squad S] [--text "..."] [--json]
---

# /kai-graph-query

Lista nós do grafo filtrados.

## Uso

```bash
/kai-graph-query                            # todos os nós
/kai-graph-query --type decision            # só decisões
/kai-graph-query --tag arch                 # nós com tag arch
/kai-graph-query --squad payments
/kai-graph-query --text "retry"             # match em title/body/tags
/kai-graph-query --type decision --json     # output JSON
```

## Execução

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/graph.sh" query "$@"
```
