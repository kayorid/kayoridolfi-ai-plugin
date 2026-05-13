# Release Notes

Para o histórico completo de mudanças do Kayoridolfi AI, consulte [`CHANGELOG.md`](./CHANGELOG.md).

Para o roadmap evolutivo, consulte [`docs/plans/2026-05-10-evolution-roadmap.md`](./docs/plans/2026-05-10-evolution-roadmap.md).

## Última versão: 1.0.0 (2026-05-11)

**Marco: maturidade pedagógica.** SDK pronto para uso pelos times.

Highlights:
- **Slack bot real** (Bolt JS / Node 20) substitui o stub — comandos `@kai-ai retro <squad>` e `help`
- **Jira adapter + `/kai-spec-from-ticket`** — bootstrap de spec SDD a partir de ticket
- **PagerDuty webhook → runbook automático** em `.kai/runbooks/INC-<id>.md`
- **`/kai-adoption-report`** — relatório corporativo por squad (terminal + JSON)
- **Certificação AI Champion** — 4 níveis com critérios mensuráveis auto-auditáveis
- **Testes:** smoke 120 · completeness 166 · E2E 11 · node:test 5/5

Sem breaking changes — todos os comandos v0.5 continuam funcionando.

## Versões anteriores

### 0.5.0 (2026-05-11) — Comunidade & Workshops
- `/kai-leaderboard` saudável agregado por squad, `/kai-newsletter` trimestral (.md + .html)
- Charter formal AI Champions, AI Lab playbook (6 trilhas), opt-in guide
- Smoke 105 · completeness 161

### 0.3.2 (2026-05-11) — Cleanup técnico + E2E
- Consolidação M-1 (`pre-write-guard.sh` único em kai-security)
- Fix `achievements/checker.sh` unbound variable
- Suite E2E nova (`tests/e2e/run.sh`) — 11 verificações em sandbox temporário

### 0.3.1 (2026-05-10) — Patch de polimento
- Doctor + help atualizados para 9 plugins
- 4 achievements novos · constitution v0.3.1 · completeness loop iterativo

### 0.3.0 (2026-05-10)
- 9 plugins (adicionado `kai-evals`), 6 comandos novos, auto-snapshot
- CI próprio, governance open-source, MIGRATION + PLUGIN-DEVELOPMENT guides

### 0.2.0, 0.1.0 (2026-05-10)
- Veja `CHANGELOG.md`
