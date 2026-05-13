---
description: Gera spec inicial a partir de um ticket Jira/Linear
argument-hint: <TICKET-KEY>
---

# /kai-spec-from-ticket

Bootstrap de spec SDD a partir de um ticket existente. Consulta o adapter em `integrations/jira/adapter.sh`, normaliza o ticket e popula `docs/specs/_active/<YYYY-MM-DD>-<ticket>/requirements.md`.

## Uso

```bash
# Mock (offline / CI)
KAI_MOCK_JIRA=1 bash plugins/kai-sdd/scripts/spec-from-ticket.sh JIRA-DEMO

# Real
export JIRA_BASE_URL=https://example.atlassian.net
export JIRA_USER=...
export JIRA_TOKEN=...
bash plugins/kai-sdd/scripts/spec-from-ticket.sh JIRA-1234
```

## Output

`docs/specs/_active/2026-05-11-jira-1234/requirements.md` com seções:

- Contexto do ticket (description importada)
- User stories (esqueleto a preencher)
- Critérios EARS (esqueleto a preencher)
- Fora de escopo
- Clarifications

## Próximos passos sugeridos

1. `/kai-sdd-clarify` — refinar ambiguidades
2. `/kai-sdd-design` — design técnico
3. `/kai-sdd-tasks` — quebra executável

## Linear

Para tickets Linear, defina `KAI_TICKET_PROVIDER=linear` e use `integrations/linear/adapter.sh` (compat — gera mesmo JSON canônico). Implementação Linear stub em v1.0; planejada para v1.1.
