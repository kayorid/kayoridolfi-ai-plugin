# Release Notes

Para o histórico completo de mudanças do Kayoridolfi AI, consulte [`CHANGELOG.md`](./CHANGELOG.md).

Para o roadmap evolutivo, consulte [`docs/plans/2026-05-10-evolution-roadmap.md`](./docs/plans/2026-05-10-evolution-roadmap.md).

## Última versão: 2.1.0 (2026-05-13)

**Marco: inteligência operacional.** Knowledge graph cross-squad, busca BM25, drift detection, telemetria opt-in.

Highlights:
- **Novo plugin `kai-intel`** — `/kai-graph-add|query|export`, `/kai-search` (BM25), `/kai-drift-check`
- **Telemetria opt-in** — `/kai-telemetry` 100% local, sem rede, padrão desligado
- **`kai-cost` transcript-based** — novo hook `Stop`/`SessionEnd` (`cost-finalize.sh`) lê transcript JSONL e agrega usage real por modelo. Resolve limitação conhecida da v1.x.
- **Testes:** completeness 183 · smoke 127 · e2e 9

Sem breaking changes. Comandos v2.0 continuam funcionando.

## Versão anterior: 2.0.0 (2026-05-13)

**Marco: lançamento inicial open-source (MIT).**

Highlights:
- 9 plugins · 14 skills · 62 comandos · 3 integrações reais (Slack/Jira/PagerDuty)
- Instalador one-shot `bash scripts/install.sh`
- Suite: completeness 169 · smoke 124 · e2e 9

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
