---
description: Detecta drift entre spec/plan ativos e o estado real do código
argument-hint: [<feature-slug>] [--ci] [--json]
---

# /kai-drift-check

Compara a spec ativa com o estado atual do código. Relata divergências sem bloquear.

## Uso

```bash
/kai-drift-check                       # spec ativa (mais recente em _active)
/kai-drift-check payments-gateway      # feature específica
/kai-drift-check --ci                  # exit code 1 se HIGH drift (para CI)
/kai-drift-check --json                # output estruturado
```

## Execução

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/drift-check.sh" "$@"
```

## O que verifica

1. **Arquivos prometidos no `plan.md`** ausentes do repo
2. **Símbolos** (funções, endpoints) listados em `design.md` que não aparecem em `git grep`
3. **Decisões em `decisions.md`** contraditas por código (ex.: decisão "usar gRPC" mas código tem `axios.post`)
4. **Tasks não-marcadas** em `tasks.md` cujo código já existe (sub-marcação)

## Severidades

- **HIGH** — arquivo/endpoint principal ausente
- **MEDIUM** — símbolo secundário ausente
- **LOW** — decisão potencialmente contraditada (heurística)

## Output

Markdown em stdout. Relatório persistido em `.kai/intel/drift/<feature>-<timestamp>.md`.
