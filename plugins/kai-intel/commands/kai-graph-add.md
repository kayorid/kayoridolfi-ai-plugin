---
description: Adiciona um nó (decisão, learning, spec, incidente, runbook, dependency) ao knowledge graph
argument-hint: <type> "<title>" [--tags t1,t2] [--squad name] [--links id1,id2] [--body "..."]
---

# /kai-graph-add

Adiciona um nó ao knowledge graph local em `.kai/intel/graph.json`.

## Uso

```bash
/kai-graph-add decision "Adotar gRPC entre payments e ledger" --tags arch,api --squad payments
/kai-graph-add learning "Timeouts curtos em downstream amplificam thundering herd" --tags retro,sre
/kai-graph-add incident "INC-204 fila kafka travou" --tags ops --links N-13
```

## Execução

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/graph.sh" add "$@"
```

## Tipos válidos

- `decision` — escolha arquitetural não-trivial
- `learning` — lição capturada em retro
- `spec` — pointer para spec relevante em `docs/specs/_completed/`
- `incident` — pointer para incidente/runbook
- `runbook` — pointer para runbook operacional
- `dependency` — dependência cross-squad

## Output

ID curto do nó (`N-<seq>`), echoed para fácil referência em `--links`.
