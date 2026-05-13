---
description: Visão geral do Kayoridolfi AI — 9 plugins, comandos por categoria, links
---

# /kai-help

Apresente visão geral concisa do Kayoridolfi AI.

## 1. Identidade

> **Kayoridolfi AI (Kayoridolfi AI Plugin) v0.3.1** — harness corporativo de desenvolvimento assistido por IA do Kayoridolfi. Padroniza processo, garante auditabilidade e segurança, mantém squads alinhados sem engessar especialização.

## 2. Os 9 plugins

| Plugin | Propósito |
|--------|-----------|
| `kai-ai-core` | Constitution, hooks bloqueantes, MCP allowlist, achievements, doctor, dashboard, snapshot, search, themes |
| `kai-bootstrap` | Onboarding híbrido do squad |
| `kai-sdd` | Ciclo Spec-Driven rígido com checkpoints |
| `kai-review` | Code/security/spec review formais |
| `kai-observability` | Design e revisão de observabilidade |
| `kai-security` | Threat modeling, compliance, hooks PII/cripto |
| `kai-retro` | Retrospectivas e memória organizacional |
| `kai-cost` | Captura de tokens, custo por fase/feature, alertas |
| `kai-evals` | Eval framework para features que usam IA em runtime |

## 3. Comandos por categoria

**Setup & diagnóstico**
- `/kai-init` — wizard de primeira instalação
- `/kai-doctor` — health check completo
- `/kai-status` — diagnóstico do squad
- `/kai-version` — versões instaladas
- `/kai-update` — atualiza SDK

**Squad & contexto**
- `/kai-bootstrap` — onboarding inicial
- `/kai-bootstrap-rescan` — reanálise (com auto-snapshot)
- `/kai-enrich-domain | -runbooks | -skills` — missões de enriquecimento
- `/kai-new-skill <slug>` — scaffolder rápido

**Ciclo SDD**
- `/kai-spec` — ciclo completo (8 fases)
- `/kai-spec-discuss | -requirements | -design | -plan | -execute | -verify | -retro` — fases isoladas
- `/kai-hotfix` — modo expresso (post-mortem 48h)
- `/kai-spike` — exploração descartável
- `/kai-fast` — modo relaxado (squads maduros)
- `/kai-approve <fase>` — checkpoint humano
- `/kai-exception` — exceção formal

**Review**
- `/kai-review-pr | -security | -spec | -fix`

**Observabilidade & segurança**
- `/kai-observability-design | -review`
- `/kai-runbook-from-incident <descrição>`
- `/kai-threat-model`
- `/kai-security-checklist`
- `/kai-compliance-check <bacen|cvm|lgpd|travel-rule|pci>`
- `/kai-secret-rotate`

**Retro & aprendizado**
- `/kai-retro` — retrospectiva
- `/kai-retro-digest` — resumo das últimas N retros
- `/kai-retro-promote` — promove ao core
- `/kai-retro-extract-skill` — extrai skill custom
- `/kai-retro-quarterly` — consolidação trimestral (análise narrativa)
- `/kai-newsletter` — newsletter trimestral (Markdown + HTML) ⬢ v0.5
- `/kai-leaderboard` — leaderboard saudável agregado por squad ⬢ v0.5
- `/kai-adoption-report` — relatório corporativo de adoção ⬢ v1.0
- `/kai-spec-from-ticket <KEY>` — gera spec a partir de ticket Jira/Linear ⬢ v1.0

**Custo & avaliação**
- `/kai-cost | -feature | -budget | -alert`
- `/kai-evals-init | -run | -compare | -ci`

**UX & visual**
- `/kai-banner` — banner Kayoridolfi AI
- `/kai-ascii <nome>` — ASCII de momento-chave
- `/kai-theme set/show` — tema visual
- `/kai-dashboard` — painel ASCII
- `/kai-achievements` — conquistas
- `/kai-snapshot create/list/restore`
- `/kai-search <termo>` — busca em specs
- `/kai-tutorial init/roteiro/reset` — sandbox guiado

## 4. Por onde começar

| Situação | Comando |
|----------|---------|
| Primeira vez no SDK | `/kai-init` |
| Squad novo no Kayoridolfi AI | `/kai-bootstrap` (TL conduz) |
| Nova feature | `/kai-spec <slug>` |
| Verificar instalação | `/kai-doctor` |
| Algo travou | `/kai-exception` |
| Tutorial passo a passo | `/kai-tutorial init` |

## 5. Documentação e suporte

- **Docs:** [`README.md`](https://github.com/kayorid/kayoridolfi-ai-plugin), `docs/manual/MANUAL.md`, `docs/MIGRATION.md`, `docs/PLUGIN-DEVELOPMENT.md`
- **Slack:** `#kai-ai-plugin`
- **maintainers:** `kayocdi@gmail.com`
- **Issues:** [github.com/kayorid/kayoridolfi-ai-plugin/issues](https://github.com/kayorid/kayoridolfi-ai-plugin/issues)
- **Vulnerabilidade:** ver [`SECURITY.md`](https://github.com/kayorid/kayoridolfi-ai-plugin/blob/main/SECURITY.md)

Mantenha resposta concisa em uma tela. ⬡
