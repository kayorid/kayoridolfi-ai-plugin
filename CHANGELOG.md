# Changelog

Todas as mudanças notáveis no Kayoridolfi AI Plugin serão documentadas aqui.

Formato baseado em [Keep a Changelog](https://keepachangelog.com/), versionamento semântico.

## [2.0.0] — 2026-05-13

### Lançamento inicial open-source

Primeira release pública. Harness completo para desenvolvimento assistido por IA no Claude Code.

#### 9 plugins
- **`kai-ai-core`** — constitution, hooks bloqueantes (secret scan, MCP allowlist, destructive confirm, audit log), MCP allowlist, comandos base, achievements, doctor, dashboard, snapshot, search, themes.
- **`kai-bootstrap`** — onboarding híbrido de squad: análise automática do repo + entrevista guiada + plano de enriquecimento (glossário, runbooks, skills).
- **`kai-sdd`** — Spec-Driven Development rígido com checkpoints obrigatórios e audit-trail. Ciclo de 8 fases (`/kai-spec` → `discuss` → `requirements` → `design` → `plan` → `execute` → `verify` → ship). Modos `hotfix`, `spike`, `fast`.
- **`kai-review`** — code review, security review e spec coverage como agentes formais (`/kai-review-pr`, `/kai-review-security`, `/kai-review-spec`, `/kai-review-fix`).
- **`kai-observability`** — design e revisão de observabilidade stack-agnostic (logs, métricas, traces, alertas, SLOs); runbook automático a partir de incidente.
- **`kai-security`** — threat modeling (STRIDE + cripto), compliance regulatório, hooks específicos (PII scan, private-key scan, pre-write guard).
- **`kai-retro`** — retrospectivas estruturadas, learning extraction, newsletter, leaderboard, adoption report, promote-to-core.
- **`kai-cost`** — captura de tokens, agregação por fase/feature/dia, alertas de budget.
- **`kai-evals`** — eval framework para features que usam IA em runtime (datasets golden, rubricas, runners, A/B compare, integração CI).

#### 3 integrações
- **Slack** — bot Bolt JS / Node 20, comandos `@kai-ai retro <squad>` e `help`, modo mock para CI/dev offline, Dockerfile produção-ready.
- **Jira** — adapter shell normaliza ticket → JSON canônico (Jira Cloud + on-prem + mock); `/kai-spec-from-ticket <KEY>` bridge para o ciclo SDD.
- **PagerDuty** — webhook Node nativo zero-deps com validação HMAC, gera runbook automático a partir de incidente.

#### Instalação one-shot
`bash scripts/install.sh` configura `~/.claude/settings.json` com marketplace + 9 plugins em um comando. Idempotente, faz backup do settings anterior, suporta modo `local` (clone) e `github`.

#### Validação
- 62 comandos `/kai-*`
- 14 skills auto-discoverable
- Suite de testes: `tests/completeness-check.sh` (167 entregáveis), `tests/smoke/run.sh` (123+ checks), `tests/e2e/run.sh` (ciclo completo num repo dummy), `scripts/pilot-check.sh` (11 validações de saúde).

#### Licença
MIT.
