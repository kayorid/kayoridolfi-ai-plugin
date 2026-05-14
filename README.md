<div align="center">

```
       ╱▔▔▔▔▔▔▔╲
      ╱         ╲     ██╗  ██╗ █████╗ ██╗
     ╱           ╲    ██║ ██╔╝██╔══██╗██║
    ╱             ╲   █████╔╝ ███████║██║
    ╲             ╱   ██╔═██╗ ██╔══██║██║
     ╲           ╱    ██║  ██╗██║  ██║██║
      ╲         ╱     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝
       ╲▁▁▁▁▁▁▁╱
```

# Kayoridolfi AI Plugin

**Harness open-source para desenvolvimento assistido por IA no Claude Code.**

*Padroniza processo · Garante auditabilidade · Mantém o time alinhado · Não engessa a stack*

[![Versão](https://img.shields.io/badge/versão-2.1.0-E8550C?style=for-the-badge)]()
[![Licença](https://img.shields.io/badge/licença-MIT-blue?style=for-the-badge)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-2.x-9333ea?style=for-the-badge)]()
[![Testes](https://img.shields.io/badge/suítes-5%20verdes-success?style=for-the-badge)]()

[Instalar](#-instalação) · [Como funciona](#-como-funciona) · [Comandos](#-comandos) · [Plugins](#-os-9-plugins) · [Filosofia](#-filosofia)

</div>

---

## ⚡ Instalação

### Opção A — Marketplace GitHub (recomendado)

Um comando configura tudo via `settings.json`:

```bash
git clone https://github.com/kayorid/kayoridolfi-ai-plugin ~/dev/kayoridolfi-ai-plugin
cd ~/dev/kayoridolfi-ai-plugin
bash scripts/install.sh github
```

Habilita os 10 plugins, faz backup do `settings.json`. Reinicie o Claude Code → `/kai-doctor` valida → `/kai-bootstrap` no seu repo → primeira spec com `/kai-spec`.

### Opção B — Marketplace local (desenvolvimento / fork)

O Claude Code não aceita marketplaces locais via `settings.json` — eles precisam ser registrados pelo comando interno `/plugin marketplace add`. Fluxo:

```bash
git clone https://github.com/kayorid/kayoridolfi-ai-plugin ~/dev/kayoridolfi-ai-plugin
cd ~/dev/kayoridolfi-ai-plugin
bash scripts/install.sh        # valida deps + imprime próximos passos
```

Depois, **dentro do Claude Code**:

```
/plugin marketplace add ~/dev/kayoridolfi-ai-plugin
/plugin install kai-ai-core@kai
/plugin install kai-bootstrap@kai
/plugin install kai-sdd@kai
/plugin install kai-review@kai
/plugin install kai-observability@kai
/plugin install kai-security@kai
/plugin install kai-retro@kai
/plugin install kai-cost@kai
/plugin install kai-evals@kai
/plugin install kai-intel@kai
```

Valide com `/kai-doctor`.

---

## 🎯 O que problema isso resolve?

Sua equipe usa Claude Code. Cada dev tem seu próprio ritmo, seu próprio jeito de "pedir pra IA". Spec mora na cabeça de quem escreveu. Decisões de design somem no chat. Quando algo dá errado em produção, ninguém reproduz como a IA chegou ali.

**Kayoridolfi AI Plugin transforma "vibe coding" em engenharia auditável:**

| Sem o plugin | Com o plugin |
|---|---|
| Cada dev usa IA do seu jeito | Ciclo SDD padronizado, 8 fases |
| Decisões somem no chat | Trilha versionada em `docs/specs/` |
| "Funciona aqui mas não em prod" | Hooks bloqueantes + checkpoints humanos |
| Custo de IA é caixa preta | `/kai-cost` agrega por fase, feature, dev |
| Onboarding leva semanas | `/kai-bootstrap` em 1 sessão |
| Retro é call que ninguém anota | `/kai-retro` extrai learnings → constitution |
| MCPs aleatórios sem revisão | Allowlist auditada com PR de aprovação |
| Sem padrão de security/compliance | Skills especialistas + hooks de PII/secret |

---

## 🧭 Como funciona

```
       ╔══════════════════════════════════════════════════════════════╗
       ║                                                              ║
       ║   1.  /kai-bootstrap     ◀── onboarding 1x por repo          ║
       ║       └─ Analisa repo + entrevista guiada + .kai/CLAUDE.md   ║
       ║                                                              ║
       ║   2.  /kai-spec <slug>   ◀── começa toda feature aqui        ║
       ║       │                                                      ║
       ║       ▼                                                      ║
       ║      ┌─────────────────────────────────────────────────┐    ║
       ║      │  discuss → spec → plan → execute → verify →     │    ║
       ║      │            ↑                                 │     │ ║
       ║      │     hooks bloqueantes em cada checkpoint     │     │ ║
       ║      │            ↓                                 │     │ ║
       ║      │            review → ship → retro             ◀──    │ ║
       ║      └─────────────────────────────────────────────────┘    ║
       ║                                                              ║
       ║   3.  /kai-retro         ◀── learnings viram skills/regras   ║
       ║                                                              ║
       ║   4.  /kai-cost          ◀── tudo medido, tudo auditável     ║
       ║                                                              ║
       ╚══════════════════════════════════════════════════════════════╝
```

### Os 4 pilares

**1. Constitution viva** · `kai-ai-core` carrega princípios não-negociáveis em todo contexto. Hooks bloqueantes (secret scan, MCP allowlist, destructive confirm, audit log) garantem que regras não dependem de boa vontade — são impossíveis de pular.

**2. Spec-Driven Development rígido** · `kai-sdd` força o ciclo `discuss → spec → plan → execute → verify → review → ship → retro`. Cada fase tem checkpoint humano via `/kai-approve`. Audit-trail compatível com requisitos regulatórios. Modos `hotfix`, `spike` e `fast` para casos onde rigidez não cabe.

**3. Contexto vivo do time** · `.kai/CLAUDE.md`, glossário, runbooks e skills do squad evoluem continuamente. `kai-bootstrap` faz onboarding híbrido (análise automática + entrevista). `kai-retro` extrai learnings que voltam à constitution.

**4. Verificação antes de claim** · Nada está "pronto" sem evidência observável. `kai-review` agentes especializados para code/security/spec coverage. `kai-evals` para features que usam IA em runtime.

---

## 🧩 Os 10 plugins

<table>
  <tr>
    <th>Plugin</th>
    <th>Obrigatório?</th>
    <th>Para quê</th>
  </tr>
  <tr>
    <td><a href="plugins/kai-ai-core/"><code>kai-ai-core</code></a></td>
    <td align="center">✅</td>
    <td>Constitution, hooks bloqueantes, MCP allowlist, comandos base, achievements, doctor, dashboard, snapshot, search, themes</td>
  </tr>
  <tr>
    <td><a href="plugins/kai-bootstrap/"><code>kai-bootstrap</code></a></td>
    <td align="center">⭐ recomendado</td>
    <td>Onboarding do squad: análise + entrevista + plano de enriquecimento contínuo</td>
  </tr>
  <tr>
    <td><a href="plugins/kai-sdd/"><code>kai-sdd</code></a></td>
    <td align="center">⭐ recomendado</td>
    <td>Spec-Driven Development rígido com checkpoints obrigatórios e audit-trail</td>
  </tr>
  <tr>
    <td><a href="plugins/kai-review/"><code>kai-review</code></a></td>
    <td align="center">⚙️ opt-in</td>
    <td>Code review, security review e spec coverage como agentes formais</td>
  </tr>
  <tr>
    <td><a href="plugins/kai-observability/"><code>kai-observability</code></a></td>
    <td align="center">⚙️ opt-in</td>
    <td>Design e revisão de observabilidade stack-agnostic (logs, métricas, traces, SLOs)</td>
  </tr>
  <tr>
    <td><a href="plugins/kai-security/"><code>kai-security</code></a></td>
    <td align="center">🛡 obrigatório se ativo crítico</td>
    <td>Threat modeling, compliance (Bacen/CVM/LGPD), padrões cripto, hooks bloqueantes</td>
  </tr>
  <tr>
    <td><a href="plugins/kai-retro/"><code>kai-retro</code></a></td>
    <td align="center">⚙️ opt-in</td>
    <td>Retrospectivas estruturadas, learning extraction, memória organizacional</td>
  </tr>
  <tr>
    <td><a href="plugins/kai-cost/"><code>kai-cost</code></a></td>
    <td align="center">⭐ recomendado</td>
    <td>Captura de tokens, custo por fase/feature/dev/dia, alertas de budget</td>
  </tr>
  <tr>
    <td><a href="plugins/kai-evals/"><code>kai-evals</code></a></td>
    <td align="center">🤖 essencial para AI features</td>
    <td>Eval framework — datasets golden, rubricas, runners, A/B compare, integração CI</td>
  </tr>
  <tr>
    <td><a href="plugins/kai-intel/"><code>kai-intel</code></a></td>
    <td align="center">🧠 v2.1</td>
    <td>Knowledge graph cross-squad, busca BM25, drift detection spec ↔ código</td>
  </tr>
</table>

### 3 integrações externas (opcionais)

- **`integrations/slack`** — bot Bolt JS (Node 20). Comandos `@kai-ai retro <squad>` e `help`. Modo mock para CI offline. Dockerfile produção-ready.
- **`integrations/jira`** — adapter shell normaliza ticket → JSON (Cloud + on-prem + mock). `/kai-spec-from-ticket <KEY>` cria spec a partir do ticket.
- **`integrations/pagerduty`** — webhook Node zero-deps com HMAC. Gera runbook automático a partir de incidente.

---

## 🚀 Comandos

> Lista completa: `/kai-help` · Por categoria abaixo:

<details>
<summary><b>🔧 Setup & Diagnóstico</b></summary>

```bash
/kai-init          # wizard de primeira instalação
/kai-doctor        # health check do ambiente
/kai-status        # diagnóstico do squad/repo
/kai-help          # visão geral
/kai-update        # verifica atualizações
/kai-version       # versões dos plugins
/kai-list-plugins  # plugins ativos
```
</details>

<details>
<summary><b>👥 Squad & Contexto</b></summary>

```bash
/kai-bootstrap            # onboarding inicial (1x por repo)
/kai-bootstrap-rescan     # reanalisa com auto-snapshot
/kai-enrich-domain        # aprofunda glossário
/kai-enrich-runbooks      # cria runbook para fluxo crítico
/kai-enrich-skills        # cria skill custom
/kai-new-skill <slug>     # scaffolder rápido
```
</details>

<details>
<summary><b>📜 Ciclo Spec-Driven (SDD)</b></summary>

```bash
/kai-spec <slug>            # ciclo completo (8 fases)
/kai-spec-discuss           # 1ª fase isolada (explorar o quê)
/kai-spec-requirements      # 2ª fase (EARS)
/kai-spec-design            # 3ª fase (decisões técnicas)
/kai-spec-plan              # 4ª fase (tarefas atômicas)
/kai-spec-execute           # 5ª fase (implementação)
/kai-spec-verify            # 6ª fase (verificação)
/kai-spec-from-ticket <K>   # bridge Jira → spec
/kai-hotfix                 # modo expresso (post-mortem 48h)
/kai-spike                  # exploração descartável
/kai-fast                   # modo relaxado (squad maduro)
/kai-approve <fase>         # checkpoint humano
/kai-exception              # exceção formal a regra bloqueante
```
</details>

<details>
<summary><b>🔍 Review</b></summary>

```bash
/kai-review-pr        # code review estruturado
/kai-review-security  # security review (OWASP + cripto + PII/KYC/AML)
/kai-review-spec      # coverage spec ↔ implementação
/kai-review-fix       # aplica fixes do REVIEW.md
```
</details>

<details>
<summary><b>📡 Observability & 🛡 Security</b></summary>

```bash
/kai-observability-design     # logs/métricas/traces/alertas/SLOs
/kai-observability-review     # auditoria de instrumentação
/kai-runbook-from-incident    # runbook a partir de PD/incidente
/kai-threat-model             # STRIDE + cripto-específicos
/kai-security-checklist       # checklist por categoria
/kai-secret-rotate            # rotação de segredos
/kai-compliance-check <reg>   # bacen/cvm/lgpd/travel-rule/pci
```
</details>

<details>
<summary><b>🎓 Retro & Aprendizado</b></summary>

```bash
/kai-retro                # retrospectiva estruturada (5 dimensões)
/kai-retro-digest         # resumo das últimas N retros
/kai-retro-promote        # promove learning à constitution
/kai-retro-quarterly      # consolidação trimestral
/kai-retro-extract-skill  # vira skill instalável
/kai-newsletter           # gera newsletter MD + HTML
/kai-leaderboard          # top squads em adoção
/kai-adoption-report      # relatório por squad
```
</details>

<details>
<summary><b>💰 Custo & 🧪 Eval</b></summary>

```bash
/kai-cost                       # agregado por dia/semana/mês
/kai-cost-feature <slug>        # custo por feature
/kai-cost-budget                # define budgets
/kai-cost-alert                 # verifica vs budget
/kai-evals-init <feature>       # scaffolding de eval
/kai-evals-run <feature>        # executa eval
/kai-evals-compare <a> <b>      # A/B prompts/modelos
/kai-evals-ci <feature>         # modo CI (exit 0/1)
```
</details>

<details>
<summary><b>🎨 UX & Visual</b></summary>

```bash
/kai-banner                          # banner do projeto
/kai-ascii <nome>                    # ASCII art (welcome, ship, hotfix, retro...)
/kai-theme set <default|festive|compact|accessible|none>
/kai-dashboard                       # painel ASCII com métricas
/kai-achievements                    # conquistas do squad
/kai-snapshot create|list|restore    # backup reversível de .kai/
/kai-search <termo>                  # busca em specs
/kai-tutorial                        # sandbox guiado (45-60min)
```
</details>

---

## 🏛 Filosofia

Dez princípios fundadores. Não-negociáveis em features de ativo crítico.

1. **Processo > Stack** — opina sobre como se trabalha, não sobre tecnologia.
2. **Auditabilidade nativa** — toda decisão deixa trilha versionada.
3. **Rigidez pedagógica** — força o ciclo enquanto o time aprende; modos relaxados após maturidade.
4. **Segurança não-negociável** — hooks sempre bloqueiam.
5. **Contexto vivo** — `.kai/CLAUDE.md`, glossário e skills evoluem com o squad.
6. **MCPs sob curadoria** — apenas allowlist aprovada.
7. **Verificação antes de claim** — nada está "pronto" sem evidência.
8. **Reversibilidade preferida** — destrutivo exige confirmação humana.
9. **Custo de IA é decisão de engenharia** — exposto via `kai-cost`.
10. **Aprendizado coletivo** — learnings dos times alimentam o core.

---

## 📂 Estrutura do repositório

```
kayoridolfi-ai-plugin/
├── README.md                      ← você está aqui
├── CHANGELOG.md  LICENSE  SECURITY.md  CONTRIBUTING.md
├── .claude-plugin/marketplace.json   ← lista os 10 plugins
├── scripts/
│   ├── install.sh                 ← instalador one-shot
│   └── pilot-check.sh             ← 11 health checks
├── plugins/                       ← 10 plugins kai-*
│   ├── kai-ai-core/    kai-bootstrap/    kai-sdd/
│   ├── kai-review/     kai-observability/  kai-security/
│   └── kai-retro/      kai-cost/          kai-evals/
├── integrations/
│   ├── slack/       ← bot Bolt JS
│   ├── jira/        ← adapter shell
│   └── pagerduty/   ← webhook zero-deps
├── docs/
│   ├── manual/             MANUAL.md (técnico completo)
│   ├── plans/              roadmap + design
│   ├── playbooks/          guias práticos por papel
│   ├── governance/         RACI + Champions
│   ├── specs/              specs SDD (atuais + arquivadas)
│   └── PLUGIN-DEVELOPMENT.md
└── tests/
    ├── completeness-check.sh    167 entregáveis
    ├── smoke/run.sh             120+ checks
    └── e2e/run.sh               ciclo SDD completo
```

---

## ✅ Verificação local

```bash
bash scripts/pilot-check.sh                     # 11 checks (deps + 4 suites + integrations)
bash plugins/kai-ai-core/scripts/version.sh     # versões sincronizadas
bash tests/completeness-check.sh                # 167 entregáveis
bash tests/smoke/run.sh                         # 120+ verificações
bash tests/e2e/run.sh                           # ciclo SDD completo
node --test integrations/slack/test/            # 4 testes Slack
node --test integrations/pagerduty/test/        # 1 teste PagerDuty
```

---

## 📚 Documentação

| Documento | Para quem |
|-----------|-----------|
| [**PILOT-SETUP.md**](PILOT-SETUP.md) | Instalando numa máquina nova ou ambiente isolado |
| [**docs/manual/MANUAL.md**](docs/manual/MANUAL.md) | Manual técnico completo (arquitetura, fluxos, ciclo SDD) |
| [**docs/PLUGIN-DEVELOPMENT.md**](docs/PLUGIN-DEVELOPMENT.md) | Criando plugins novos (extensão) |
| [**docs/playbooks/install-by-role.md**](docs/playbooks/install-by-role.md) | Playbook por papel (Tech Lead, Champion, Dev) |
| [**docs/governance/raci.md**](docs/governance/raci.md) | Governança e RACI |
| [**docs/plans/2026-05-10-evolution-roadmap.md**](docs/plans/2026-05-10-evolution-roadmap.md) | Roadmap evolutivo |
| [**docs/faq.md**](docs/faq.md) | Perguntas frequentes |
| [**CONTRIBUTING.md**](CONTRIBUTING.md) | Como contribuir |
| [**SECURITY.md**](SECURITY.md) | Reportar vulnerabilidade |

---

## 🤝 Contribuir

PRs welcome. Leia [CONTRIBUTING.md](CONTRIBUTING.md) primeiro — convenções de commit, processo de revisão, requisitos das suítes de teste.

Para discussão estratégica abra issue com label `proposal`.
Para reportar vulnerabilidade ver [SECURITY.md](SECURITY.md) — não abra issue pública.

---

## 📄 Licença

[MIT](LICENSE) © [Kayo Ridolfi](https://github.com/kayorid)

<div align="center">

**Open source · Sem amarras · Para qualquer time · Para qualquer stack**



</div>
