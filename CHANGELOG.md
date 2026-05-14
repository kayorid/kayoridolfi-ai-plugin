# Changelog

Todas as mudanças notáveis no Kayoridolfi AI Plugin serão documentadas aqui.

Formato baseado em [Keep a Changelog](https://keepachangelog.com/), versionamento semântico.

## [2.1.0] — 2026-05-13

### Inteligência operacional

Adicionado **`kai-intel`** (10º plugin) com três capacidades complementares:

- **Knowledge graph** — `/kai-graph-add`, `/kai-graph-query`, `/kai-graph-export` (DOT/Mermaid/JSON). Nós tipados (`decision`, `learning`, `spec`, `incident`, `runbook`, `dependency`) persistidos em `.kai/intel/graph.json`. Plain JSON, editável à mão.
- **Search** — `/kai-search` com ranking BM25 puro shell (k1=1.5, b=0.75) sobre `.kai/intel/`, `docs/specs/_active/`, `docs/specs/_completed/`, playbooks, runbooks. Índice em `.kai/intel/search-index.json` com auto-rebuild >24h. Roadmap v2.5+ pode trocar BM25 por embeddings sem breaking change.
- **Drift detection** — `/kai-drift-check` compara spec/plan ativos com código real. Reporta HIGH/MEDIUM/LOW; modo `--ci` retorna exit 1 em HIGH.

### Telemetria opt-in (kai-ai-core)

`/kai-telemetry <status|enable|disable|show|reset>` — contagem 100% local de comandos e hooks em `.kai/telemetry/usage.json`. **Nada sai da máquina**, opt-in explícito, sem cloud, sem rede. Padrão: desabilitado.

### kai-cost: captura via transcript (resolve dívida da v1.x)

Novo hook `Stop`/`SessionEnd` (`cost-finalize.sh`) lê o transcript JSONL e agrega `usage` real por modelo. Substitui captura parcial do PostToolUse, que dependia de payloads que o Claude Code raramente preenche em tools individuais.

### Validação

- 10 plugins · 15 skills · 67 comandos `/kai-*` · 12 hooks
- Completeness 183 · smoke 127 · e2e 9 (todas verdes)
- Bump v2.0.0 → v2.1.0 sincronizado em todos manifests + marketplace + install.sh

### Sem breaking changes

Comandos da v2.0 continuam funcionando. `kai-intel` é plugin novo, opcional. Telemetria desligada por padrão. Hook `cost-finalize` é aditivo (não remove `cost-capture`).

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
