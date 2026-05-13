# Kayoridolfi AI Plugin — Design e Proposta de Implementação

**Data:** 2026-05-10
**Autor:** Kayori Dolfi (maintainers)
**Status:** Proposta v1.0 — pronta para revisão executiva e início de implementação
**Audiência:** Liderança de Engenharia, Tech Leads, maintainers, AI Champions

---

## 1. Sumário executivo

O **Kayoridolfi AI Plugin** é um harness corporativo de desenvolvimento assistido por IA para o Kayoridolfi. Não é uma biblioteca de código nem um framework de runtime — é um **framework de processo, governança e contexto** que padroniza como squads do  constroem software com Claude Code de forma:

- **Auditável** — toda decisão (spec, design, código) deixa trilha versionada compatível com requisitos regulatórios (Bacen, CVM, LGPD).
- **Segura** — hooks bloqueantes impedem vazamento de segredos, uso de MCPs não-aprovados e padrões de risco antes que cheguem a um commit.
- **Stack-agnóstica** — o SDK opina sobre **como** se trabalha, não sobre quais tecnologias usar; cada squad gera seu próprio contexto (CLAUDE.md, glossário, runbooks, skills custom) via bootstrap automatizado.
- **Pedagogicamente rígida** — força o ciclo Spec-Driven Development completo enquanto o time está aprendendo a trabalhar com IA; modos relaxados só após maturidade demonstrada.
- **Distribuída de forma modular** — um plugin obrigatório (`kai-ai-core`) carrega a baseline corporativa, e seis plugins opcionais (`kai-bootstrap`, `kai-sdd`, `kai-review`, `kai-observability`, `kai-security`, `kai-retro`) são adotados conforme necessidade do squad.

**Hipótese central:** times do  que operam dentro do harness produzem entregas com mais qualidade auditável, menor retrabalho e onboarding mais rápido para novos integrantes — sem sacrificar velocidade significativamente.

**Entregável da v1.0:** marketplace interno com sete plugins funcionais, documentação por papel (maintainers, Tech Lead, AI Champion, Dev), processo de bootstrap end-to-end testável, e roadmap evolutivo até v2.0.

---

## 2. Contexto e motivação

### 2.1 Por que agora

O Kayoridolfi está iniciando o uso intensivo de IA generativa em desenvolvimento. A janela atual é crítica: os primeiros padrões adotados se tornarão a cultura. Sem um harness corporativo:

- Cada squad reinventa seu próprio fluxo, gerando inconsistência entre times.
- Práticas inseguras (commit de segredos via prompt, uso de MCPs não-auditados, exposição de dados regulados a APIs externas) podem se normalizar antes de serem detectadas.
- Decisões importantes ficam apenas no chat efêmero do dev com o agente, sem trilha que sobreviva à rotação de pessoas ou auditoria externa.
- O aprendizado coletivo de "o que funciona" não se consolida — cada time aprende sozinho.

### 2.2 Restrições reais do

- **Regulação financeira:** Bacen, CVM, Receita Federal exigem rastreabilidade de mudanças em sistemas críticos (matching engine, custódia, KYC, liquidação). Decisões automatizadas precisam ser explicáveis e auditáveis.
- **Cripto-específicos:** integração com blockchains, custódia de chaves, antifraude e Travel Rule criam superfície de ataque única que ferramentas genéricas não cobrem.
- **Heterogeneidade de stack:** times usam Go, Node, Python, Rust, Java, Next.js, React Native, Swift/Kotlin nativo. Um SDK que dite stack não seria adotado.
- **Maturidade variável em IA:** alguns devs já operam Claude Code diariamente; outros nunca usaram. O harness precisa servir a ambos.
- **Cultura de squad autônomo:** o  valoriza autonomia de squads. O SDK precisa garantir baseline mas não engessar especialização.

### 2.3 O que já existe

A base deste SDK é o plugin **Spec-Driven Development (SDD)** já desenvolvido como prova de conceito. Ele entrega o ciclo `constitution → specify → clarify → plan → tasks → implement → validate → retrospective` com artefatos versionados em `docs/specs/`. O Kayoridolfi AI Plugin absorve, refatora e expande esse plugin como `kai-sdd`, mantendo seu DNA mas adicionando integração com os demais plugins do ecossistema.

---

## 3. Princípios fundadores

Estes princípios são **não-negociáveis** e governam todas as decisões de design do SDK e dos plugins. Eles serão materializados como `constitution.md` no `kai-ai-core`.

| # | Princípio | Implicação prática |
|---|-----------|-------------------|
| 1 | **Processo > Stack** | Nenhum plugin do SDK pode forçar uma linguagem ou framework. Templates e exemplos são ilustrativos, nunca obrigatórios. |
| 2 | **Auditabilidade nativa** | Toda decisão relevante (spec, design, aprovação de fase, exceção a regra) gera artefato em git. Conversa com IA é efêmera; spec é eterna. |
| 3 | **Rigidez pedagógica** | Enquanto o time não tem maturidade demonstrada (definida por métricas em §13), o ciclo SDD completo é obrigatório. Modos relaxados destravam após critérios objetivos. |
| 4 | **Segurança não-negociável** | Hooks de segurança e compliance **sempre** bloqueiam — em squad piloto, em produção, em desenvolvimento local, em hotfix. Sem exceção via flag. |
| 5 | **Contexto vivo, não congelado** | CLAUDE.md, glossário e skills do squad são atualizados continuamente via `kai-retro`. Documentação que não evolui morre. |
| 6 | **MCPs sob curadoria** | Apenas MCPs auditados pelo maintainers estão na allowlist. MCP novo passa por processo formal de avaliação (segurança, custo, risco de exfiltração de dados). |
| 7 | **Verificação antes de claim** | Nenhum agente pode declarar "pronto" sem evidência. O ciclo termina em `verification.md` com prova observável de que o goal foi atingido — não apenas tasks marcadas. |
| 8 | **Reversibilidade preferida** | Ações destrutivas (force-push, delete branch, drop table) sempre exigem confirmação humana explícita, mesmo em modo autônomo. |
| 9 | **Custo de IA é decisão de engenharia** | Chamadas a modelos grandes, contextos massivos, agentes paralelos agressivos têm custo. O SDK expõe esse custo (estimativa por fase) para decisões conscientes. |
| 10 | **Aprendizado coletivo** | Learnings extraídos por `kai-retro` são propostos para promoção à constitution via PR ao `kai-ai-core`. |

---

## 4. Arquitetura macro

### 4.1 Camadas

```
┌────────────────────────────────────────────────────────────────────┐
│  CAMADA 0 — Distribuição                                            │
│  GitHub Enterprise → marketplace interno (kai-marketplace)        │
└────────────────────────────────────────────────────────────────────┘
                                   ▼
┌────────────────────────────────────────────────────────────────────┐
│  CAMADA 1 — Plugin obrigatório (kai-ai-core)                         │
│  • Constitution                                                   │
│  • Hooks bloqueantes de segurança e compliance                      │
│  • MCP allowlist                                                    │
│  • Comandos /kai-help, /kai-status, /kai-approve                       │
│  • Convenções de commit, PR, branch                                 │
└────────────────────────────────────────────────────────────────────┘
                                   ▼
┌────────────────────────────────────────────────────────────────────┐
│  CAMADA 2 — Plugins de processo (opt-in por squad)                  │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐                 │
│  │ kai-bootstrap │ │   kai-sdd     │ │  kai-review   │                 │
│  └──────────────┘ └──────────────┘ └──────────────┘                 │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐                 │
│  │kai-observabil │ │ kai-security  │ │   kai-retro   │                 │
│  └──────────────┘ └──────────────┘ └──────────────┘                 │
└────────────────────────────────────────────────────────────────────┘
                                   ▼
┌────────────────────────────────────────────────────────────────────┐
│  CAMADA 3 — Contexto do squad (.kai/ + docs/specs/ no repo)          │
│  • CLAUDE.md customizado                                            │
│  • glossary.md (domínio + jargões internos)                         │
│  • runbooks/                                                        │
│  • skills/ custom do squad                                          │
│  • hooks/ custom do squad                                           │
│  • docs/specs/_active/, docs/specs/_archive/                        │
└────────────────────────────────────────────────────────────────────┘
                                   ▼
┌────────────────────────────────────────────────────────────────────┐
│  CAMADA 4 — Audit trail e telemetria                                │
│  • Git como fonte de verdade (specs, decisões, commits)             │
│  • Logs estruturados de hook fires (futuro: stream para SIEM)       │
│  • Métricas de adoção e qualidade (futuro: dashboard)               │
└────────────────────────────────────────────────────────────────────┘
```

### 4.2 Repositório do SDK

O SDK vive em **um único repositório** (`kayorid/kai-ai-sdk`) com estrutura multi-plugin:

```
kayoridolfi-ai-plugin/
├── README.md                            # visão geral + por onde começar
├── LICENSE
├── CHANGELOG.md
├── docs/
│   ├── plans/                           # propostas e designs (este documento)
│   ├── governance/                      # papéis, processos, RACI
│   ├── playbooks/                       # como executar tarefas comuns
│   └── faq.md
├── .claude-plugin/
│   └── marketplace.json                 # lista os 7 plugins
└── plugins/
    ├── kai-ai-core/
    ├── kai-bootstrap/
    ├── kai-sdd/
    ├── kai-review/
    ├── kai-observability/
    ├── kai-security/
    └── kai-retro/
```

Cada plugin tem estrutura padrão:

```
plugins/<plugin-name>/
├── .claude-plugin/
│   └── plugin.json
├── README.md
├── skills/
│   └── <skill-name>/
│       ├── SKILL.md
│       ├── references/
│       ├── scripts/
│       └── assets/
├── commands/                            # slash commands
│   └── *.md
├── hooks/                               # hooks declarados via hooks.json
│   ├── hooks.json
│   └── scripts/
└── agents/                              # subagents quando aplicável
    └── *.md
```

### 4.3 Marketplace interno

A v1.0 usa o próprio repositório GitHub como marketplace. Squads adicionam ao `~/.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "kai": {
      "source": {
        "source": "github",
        "repo": "kayorid/kai-ai-sdk"
      }
    }
  },
  "enabledPlugins": {
    "kai-ai-core@kai": true,
    "kai-bootstrap@kai": true,
    "kai-sdd@kai": true
  }
}
```

A v2.0 considera infraestrutura própria (mirror interno, controle de versão centralizado, telemetria de uso) caso o  precise de isolamento total da rede pública para distribuição.

---

## 5. Os sete plugins em detalhe

Cada subseção descreve **propósito**, **comandos**, **skills**, **hooks**, **artefatos gerados** e **dependências** entre plugins.

### 5.1 `kai-ai-core` (obrigatório)

**Propósito:** estabelecer a baseline corporativa que todo squad carrega ao usar IA. É a "constituição" operacional do SDK.

**Comandos:**
- `/kai-help` — exibe overview do SDK, plugins instalados, comandos disponíveis, links para docs.
- `/kai-status` — diagnóstico: quais plugins  estão ativos, hooks carregados, MCPs aprovados em uso, presença de `.kai/` no repo, conformidade de constitution.
- `/kai-approve <fase>` — registra aprovação humana de fase do ciclo SDD com autor, timestamp e motivo, gravada em `docs/specs/_active/<feature>/approvals.log`.
- `/kai-exception` — abre processo formal de exceção a uma regra bloqueante (gera issue, exige aprovação do maintainers).

**Skills:**
- `kai-constitution` — carrega princípios  no contexto sempre que ativada. Auto-invocada quando o agente está prestes a tomar decisão arquitetural, de segurança ou de processo.

**Hooks (bloqueantes — categoria SEGURANÇA/COMPLIANCE):**
- `pre-commit-secret-scan` — bloqueia commit que contenha padrões de segredo (chaves AWS/GCP, JWT, private keys, `.env` não-template, strings tipo `password=`, `secret=`, `bearer ...`). Implementação: regex + entropia em `scripts/secret-scan.sh`.
- `pre-tool-mcp-allowlist` — bloqueia uso de MCP que não esteja na allowlist `kai-ai-core/config/mcp-allowlist.json`. Mensagem orienta como propor inclusão.
- `pre-bash-destructive-confirm` — intercepta comandos destrutivos (`rm -rf`, `git push --force`, `git reset --hard`, `DROP TABLE`, `kubectl delete`) e exige confirmação explícita gravada em log.
- `post-commit-audit-log` — anexa metadado ao commit (plugins ativos, fase SDD vigente, spec referenciada) em git-notes para trilha de auditoria.

**Artefatos gerados:**
- `.kai/audit/approvals.log` — toda aprovação registrada via `/kai-approve`.
- `.kai/audit/exceptions.log` — exceções abertas via `/kai-exception`.
- `git notes` — metadados de IA por commit.

**Dependências:** nenhuma. É a base de todos os outros.

---

### 5.2 `kai-bootstrap`

**Propósito:** onboarding de squad ao SDK via fluxo híbrido (análise automática → entrevista guiada → enriquecimento contínuo).

**Comandos:**
- `/kai-bootstrap` — entra no fluxo completo de onboarding. Primeiro uso por squad.
- `/kai-bootstrap-rescan` — reanalisa o repositório para atualizar inferências (após refator grande, mudança de stack).
- `/kai-enrich-domain` — missão de enriquecimento: aprofunda glossário e contexto de domínio.
- `/kai-enrich-runbooks` — missão: documenta runbooks operacionais a partir de incidentes recentes ou conhecimento tribal.
- `/kai-enrich-skills` — missão: identifica skills custom que o squad se beneficiaria de criar e gera scaffolding.

**Skill:**
- `kai-bootstrap` — orquestra o fluxo:
  1. **Análise automática (5 min):** detecta linguagens (extensões, package files), frameworks (imports, dependencies), estrutura (monorepo vs multi-repo), CI (workflows existentes), padrões de teste, presença de IaC.
  2. **Entrevista guiada (20-30 min):** 10 perguntas estruturadas cobrindo domínio de negócio, fluxos críticos, stakeholders, dores recentes, prioridades trimestrais, estilo de revisão. Conduzida com Tech Lead + squad presente, maintainers acompanhando primeiras execuções.
  3. **Geração:** cria `.kai/CLAUDE.md`, `.kai/glossary.md`, `.kai/runbooks/README.md`, `.kai/hooks/` (template para hooks custom), `.kai/skills/` (template para skills custom).
  4. **Plano de enriquecimento:** sugere 3 missões para as próximas 4 semanas.

**Hooks:** nenhum próprio (consome hooks do core).

**Artefatos gerados:**
```
.kai/
├── CLAUDE.md                     # contexto principal do squad
├── glossary.md                   # jargões, abreviações, conceitos de domínio
├── runbooks/
│   ├── README.md
│   └── <runbook>.md              # criados via /kai-enrich-runbooks
├── skills/                       # skills custom do squad
├── hooks/                        # hooks custom do squad
└── bootstrap/
    ├── analysis.md               # output da fase de análise automática
    ├── interview.md              # respostas da entrevista
    └── enrichment-plan.md        # plano das missões sugeridas
```

**Dependências:** `kai-ai-core`.

---

### 5.3 `kai-sdd` (refator do plugin atual)

**Propósito:** ciclo Spec-Driven Development rígido com checkpoints obrigatórios. Espinha dorsal do trabalho não-trivial.

**Comandos:**
- `/kai-spec` — entra no fluxo completo (discuss → spec → plan → execute → verify → ship → retro).
- `/kai-spec-discuss` — fase 1 isolada (ambiguity scoring).
- `/kai-spec-requirements` — fase 2 isolada (gera `requirements.md` em EARS).
- `/kai-spec-design` — fase 3 isolada.
- `/kai-spec-plan` — fase 4 isolada (gera `tasks.md`).
- `/kai-spec-execute` — fase 5 (executa tasks com commits atômicos).
- `/kai-spec-verify` — fase 6 (verificação goal-backward).
- `/kai-spec-retro` — fase 7 (extração de learnings).
- `/kai-hotfix` — modo expresso: pula DISCUSS/SPEC, exige PLAN mínimo + post-mortem em 48h.
- `/kai-spike` — modo exploratório: gera apenas `spike.md`, código vai para branch descartável.

**Skill principal:**
- `kai-sdd` — herda integralmente do plugin atual `spec-driven-development`, com adaptações:
  - Templates referenciam constitution.
  - Cada fase fecha com chamada a `/kai-approve <fase>` para audit-trail.
  - Integração com `kai-review` (`kai-spec-ship` aciona review automático).
  - Integração com `kai-retro` (`kai-spec-retro` propõe learnings ao core).

**Hooks (categoria PROCESSO/QUALIDADE — começam como aviso, viram bloqueio após maturidade):**
- `pre-commit-spec-reference` — avisa/bloqueia commit que não referencie spec ativa (formato `[spec:<feature>] <msg>` ou label `chore:` para infra).
- `post-tool-checkpoint-reminder` — após geração de artefato de fase, lembra de chamar `/kai-approve`.

**Artefatos gerados:** ver `docs/specs/_active/<data>-<feature>/` na seção 6.

**Dependências:** `kai-ai-core`. Sinergia com `kai-bootstrap`, `kai-review`, `kai-retro`.

---

### 5.4 `kai-review`

**Propósito:** padronizar processo de revisão (code review, PR review, security review) como etapa formal do ciclo, não como atividade ad-hoc.

**Comandos:**
- `/kai-review-pr <pr-url-or-branch>` — code review estruturado contra a spec referenciada e contra a constitution. Gera `REVIEW.md`.
- `/kai-review-security` — security review: threat model rápido, OWASP top 10, segredos, dependências vulneráveis, cripto-específicos (custódia, KYC).
- `/kai-review-spec` — verifica se a implementação está coerente com `requirements.md` (todo critério EARS coberto?).
- `/kai-review-fix` — aplica correções dos achados de severidade alta/média de um `REVIEW.md`.

**Skills:**
- `kai-code-reviewer` — agente revisor com regras  (stack-agnostic).
- `kai-security-reviewer` — agente especializado em segurança e cripto.
- `kai-spec-reviewer` — agente que valida coverage spec ↔ implementação.

**Hooks:**
- `pre-pr-create-review-required` (categoria PROCESSO) — avisa se PR está sendo aberto sem `REVIEW.md` no diretório da spec ativa.

**Artefatos:** `docs/specs/_active/<feature>/REVIEW.md` com findings classificados (BLOCK / FLAG / PASS) e severidade (alta/média/baixa).

**Dependências:** `kai-ai-core`. Sinergia forte com `kai-sdd` e `kai-security`.

---

### 5.5 `kai-observability`

**Propósito:** garantir que toda feature nova nasça com observabilidade adequada — sem opinar sobre stack (Datadog, Grafana, NewRelic, OTel são equivalentes para o SDK).

**Comandos:**
- `/kai-observability-design` — guia design de observabilidade para a feature corrente: o que logar, o que metricar, o que tracear, alertas, SLOs. Gera `OBSERVABILITY.md`.
- `/kai-observability-review` — audita uma implementação existente: cobertura de logs estruturados, presença de trace context propagation, métricas RED/USE adequadas, alertas acionáveis (não apenas barulhentos).
- `/kai-runbook-from-incident` — gera runbook a partir de descrição de incidente recente.

**Skills:**
- `kai-observability-designer` — entrevista o dev sobre fluxos críticos da feature, identifica pontos cegos, propõe instrumentação.
- `kai-observability-reviewer` — audita código contra checklist de observabilidade.

**Hooks:** nenhum bloqueante na v1.0 (categoria QUALIDADE — vira aviso na v1.1, bloqueio na v2.0 após maturidade).

**Artefatos:** `docs/specs/_active/<feature>/OBSERVABILITY.md` + runbooks em `.kai/runbooks/`.

**Dependências:** `kai-ai-core`. Sinergia com `kai-sdd` (fase PLAN inclui observability design).

---

### 5.6 `kai-security`

**Propósito:** trazer rigor de segurança específico para um projeto financeiro. Threat modeling, controles de compliance, padrões de cripto, custódia, KYC/AML.

**Comandos:**
- `/kai-threat-model` — gera threat model STRIDE para a feature corrente, com foco em ativos de alto valor (chaves, fundos, dados regulados).
- `/kai-security-checklist` — checklist específico cripto: gestão de chaves, assinatura de transações, custódia, autenticação multi-fator, rate limiting, proteção contra MEV/front-running quando aplicável.
- `/kai-compliance-check <regulação>` — verifica conformidade com Bacen/CVM/LGPD/Travel Rule. Aceita `bacen`, `cvm`, `lgpd`, `travel-rule`, `pci`.
- `/kai-secret-rotate` — guia rotação de segredos detectada como vencida ou comprometida.

**Skills:**
- `kai-threat-modeler` — conduz threat modeling estruturado.
- `kai-compliance-advisor` — conhece exigências regulatórias brasileiras de fintech e orienta atendimento.
- `kai-crypto-advisor` — orienta sobre padrões cripto (BIP, gestão de chaves, custódia hot/warm/cold, multisig).

**Hooks (BLOQUEANTES — categoria SEGURANÇA):**
- `pre-commit-pii-scan` — bloqueia commit com PII (CPF, RG, dados bancários) em arquivos não-marcados como dados de teste.
- `pre-commit-private-key-scan` — bloqueia commit com qualquer formato de chave privada.
- `pre-tool-prod-secret-access` — alerta + audit-log quando ferramenta tenta acessar arquivo/var marcado como `prod-secret`.

**Artefatos:** `docs/specs/_active/<feature>/THREAT-MODEL.md`, `SECURITY.md`, `.kai/audit/security-events.log`.

**Dependências:** `kai-ai-core`. Sinergia com `kai-review` e `kai-sdd` (fase DESIGN exige threat-model para features tocando ativos críticos).

---

### 5.7 `kai-retro`

**Propósito:** transformar cada ciclo SDD em aprendizado coletivo. Extrai learnings, propõe evolução de constitution e de skills, alimenta a memória organizacional.

**Comandos:**
- `/kai-retro` — conduz retrospectiva da feature/fase corrente. Gera `retro.md` estruturado: o que funcionou, o que falhou, surpresas, decisões que viraram precedente, propostas de mudança ao processo.
- `/kai-retro-promote` — promove learning do squad para proposta de PR ao `kai-ai-core` (constitution).
- `/kai-retro-extract-skill` — identifica padrões repetidos no squad e propõe scaffolding de skill custom local.
- `/kai-retro-quarterly` — agrega retros do trimestre, gera relatório executivo de tendências e propostas.

**Skills:**
- `kai-retro-facilitator` — conduz a retrospectiva como agente facilitador.
- `kai-learning-extractor` — analisa retros e identifica padrões promovíveis.

**Hooks:** nenhum.

**Artefatos:** `docs/specs/_active/<feature>/retro.md`, `.kai/learnings/quarterly-<YYYY-Qn>.md`, PRs propostos ao `kai-ai-core`.

**Dependências:** `kai-ai-core`, `kai-sdd`.

---

## 6. Ciclo de desenvolvimento rígido

O ciclo é a espinha dorsal pedagógica. Toda feature não-trivial passa pelas 7 fases. Cada fase produz artefato versionado e tem checkpoint humano.

### 6.1 Diagrama do ciclo

```
   ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
   │ DISCUSS  │───▶│   SPEC   │───▶│   PLAN   │───▶│ EXECUTE  │
   │ ambiguity│    │ EARS req │    │ tasks    │    │ batches  │
   │ scoring  │    │ + design │    │ + deps   │    │ atomic   │
   └────┬─────┘    └────┬─────┘    └────┬─────┘    └────┬─────┘
        │ ✓ approve     │ ✓ approve     │ ✓ approve    │ commits
        ▼               ▼                ▼               ▼
   ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
   │  RETRO   │◀───│   SHIP   │◀───│  REVIEW  │◀───│  VERIFY  │
   │ learnings│    │ PR + tag │    │ code/sec │    │ goal-back│
   │ → const. │    │ audit    │    │ /spec    │    │ + UAT    │
   └──────────┘    └──────────┘    └──────────┘    └──────────┘
```

### 6.2 Definição de cada fase

| Fase | Pergunta-chave | Artefato | Pronto quando |
|------|----------------|----------|---------------|
| **DISCUSS** | O que estamos resolvendo e onde está a ambiguidade? | `discuss.md` com ambiguity score | Score < limiar e premissas explícitas |
| **SPEC** | O que precisa ser construído (sem stack)? | `requirements.md` em EARS | Produto consegue ler e dizer "é isso" |
| **PLAN** | Como construímos? | `design.md` + `tasks.md` | Tasks ≤1 dia cada, deps claras, threat-model se ativo crítico |
| **EXECUTE** | Vamos construir | commits atômicos referenciando spec | Toda task com checkbox marcado e commit referenciado |
| **VERIFY** | O goal foi atingido? | `verification.md` com evidência | Critérios EARS testados, UAT aprovado |
| **REVIEW** | Está pronto para produção? | `REVIEW.md` (code+sec+spec) | Sem findings BLOCK, FLAGs documentados |
| **SHIP** | Entregar com trilha | PR + tag + audit-log | PR mergeado com referência à spec, audit-log fechado |
| **RETRO** | O que aprendemos? | `retro.md` + propostas | Learnings extraídos, propostas abertas se aplicável |

### 6.3 Checkpoints obrigatórios

Após cada fase, o agente **pausa** e exige `/kai-approve <fase>` executado por humano. Sem aprovação:

- A próxima fase **não inicia**.
- O agente não pode declarar progresso.
- Tentativa de pular checkpoint dispara hook bloqueante.

A aprovação é gravada em `.kai/audit/approvals.log` com formato:

```
2026-05-10T14:32:11Z | feature=user-onboarding-v2 | phase=DESIGN | actor=joao.silva | reason="Design aprovado em sync com TL e maintainers"
```

### 6.4 Modos especiais (ainda rígidos)

- **`/kai-hotfix <descrição>`** — pula DISCUSS e SPEC. Exige `hotfix-plan.md` mínimo (problema, solução, impacto, rollback). Produz commit + PR. Agenda `post-mortem.md` obrigatório em 48h via lembrete persistente.
- **`/kai-spike <pergunta>`** — exploratório. Gera apenas `spike.md` com pergunta, hipótese, experimento, resultado. Código em branch `spike/<topic>` que **não pode ser mergeado** — só usado para extrair aprendizado.

### 6.5 Estrutura de artefatos por feature

```
docs/specs/
├── INDEX.md                         # gerado por script
├── constitution.md                  # herdada do kai-ai-core + extensões do squad
├── _active/
│   └── 2026-05-10-user-onboarding-v2/
│       ├── discuss.md
│       ├── requirements.md
│       ├── design.md
│       ├── tasks.md
│       ├── execution.log
│       ├── verification.md
│       ├── REVIEW.md
│       ├── THREAT-MODEL.md          # se ativo crítico
│       ├── OBSERVABILITY.md
│       ├── approvals.log
│       └── retro.md
└── _archive/
    └── 2026-Q1/                     # arquivado após /kai-spec-ship
```

---

## 7. Modelo de bootstrap (híbrido em três passos)

### 7.1 Passo 1 — Análise automática (5 min, sem humano)

`kai-bootstrap` roda scripts que produzem `.kai/bootstrap/analysis.md`:

- **Stack:** linguagens detectadas (por extensão e arquivos `go.mod`, `package.json`, `pyproject.toml`, `Cargo.toml`, `pom.xml`, `Gemfile`).
- **Frameworks:** inferidos de dependências (Next.js, FastAPI, Gin, Express, Spring Boot, etc).
- **Estrutura:** monorepo (Turborepo, Nx, workspaces) vs multi-repo, presença de `apps/`, `packages/`, `services/`.
- **CI/CD:** workflows GitHub Actions, GitLab CI, CircleCI presentes.
- **Testes:** frameworks detectados (Jest, Vitest, pytest, go test, RSpec).
- **IaC:** presença de Terraform, Pulumi, Helm charts.
- **Observabilidade:** presença de OTel, Datadog, Sentry libs.
- **Segurança:** presença de `.gitleaks`, `pre-commit-config`, `dependabot`, `snyk`.

### 7.2 Passo 2 — Entrevista guiada (20-30 min, com TL + squad + maintainers)

10 perguntas estruturadas. O agente conduz, registra em `.kai/bootstrap/interview.md`:

1. **Domínio:** Em uma frase, o que esse serviço/produto faz para o cliente final?
2. **Fluxos críticos:** Quais são os 3-5 fluxos que, se quebrarem, geram incidente Sev1?
3. **Stakeholders:** Quem usa o que vocês entregam? (clientes finais, B2B, times internos, reguladores)
4. **Dores recentes:** Que tipo de bug/incidente mais consumiu vocês nos últimos 90 dias?
5. **Prioridades trimestrais:** Quais são os 2-3 objetivos do squad para o próximo trimestre?
6. **Estilo de revisão:** Vocês fazem PR review síncrono, assíncrono? Há rituais (pair, mob, ensemble)?
7. **Maturidade de testes:** Cobertura ~%? E2E existe? Testes em produção (canary, shadow)?
8. **Gargalos atuais:** Onde o time gasta tempo demais? (debug, ambientes, deploy, contexto)
9. **Glossário:** Liste 5-10 jargões/abreviações que um dev novo precisa entender no primeiro dia.
10. **Relação com regulação:** Esse serviço toca algo regulado (KYC, AML, custódia, ordens, fiscal)?

### 7.3 Passo 3 — Geração e plano de enriquecimento

A partir de análise + entrevista, `kai-bootstrap` gera:

- `.kai/CLAUDE.md` — contexto principal do squad (síntese do que importa).
- `.kai/glossary.md` — jargões da entrevista.
- `.kai/runbooks/README.md` — esqueleto, runbooks reais virão por `/kai-enrich-runbooks`.
- `.kai/skills/` — pasta vazia + template para primeira skill custom.
- `.kai/hooks/` — pasta vazia + template para primeiro hook custom.
- `.kai/bootstrap/enrichment-plan.md` — 3 missões para próximas 4 semanas:
  - Semana 1: `/kai-enrich-runbooks` para fluxo crítico #1.
  - Semana 2-3: `/kai-enrich-domain` aprofundando 2 conceitos identificados como "ambíguos".
  - Semana 4: `/kai-enrich-skills` propondo primeira skill custom do squad.

### 7.4 Reanálise periódica

`/kai-bootstrap-rescan` roda trimestralmente (ou após refator grande). Atualiza `analysis.md`, propõe deltas para `.kai/CLAUDE.md`. Não sobrescreve sem aprovação.

---

## 8. Modelo de enforcement (hooks bloqueantes por categoria)

### 8.1 Categorização

| Categoria | Postura | Exemplo de hook |
|-----------|---------|-----------------|
| **SEGURANÇA** | Sempre bloqueante, sem exceção via flag | `pre-commit-secret-scan`, `pre-commit-private-key-scan` |
| **COMPLIANCE** | Sempre bloqueante, exceção apenas via `/kai-exception` (gera issue + aprovação maintainers) | `pre-commit-pii-scan`, `pre-tool-mcp-allowlist` |
| **PROCESSO** | Inicia como aviso (warning), vira bloqueante após 4 semanas de uso pelo squad | `pre-commit-spec-reference`, `pre-pr-create-review-required` |
| **QUALIDADE** | Sempre aviso, nunca bloqueia | `post-tool-checkpoint-reminder`, lembretes de observabilidade |

### 8.2 Mecânica de evolução

O hook `pre-commit-spec-reference` (PROCESSO) começa em modo `warn`. Após 4 semanas (configurável em `.kai/config.yaml`), vira `block`. O squad recebe lembrete automático 1 semana antes da virada. Se necessário adiar, TL abre exceção via `/kai-exception`.

### 8.3 Auditabilidade dos disparos

Todo hook fire é gravado em `.kai/audit/hook-fires.log` com:

```
2026-05-10T15:42:09Z | hook=pre-commit-secret-scan | tool=Bash | status=BLOCKED | reason="AWS access key detected in src/config.ts:42" | actor=joao.silva
```

Logs são append-only. Tentativa de remoção é detectada por `pre-commit-audit-log-tamper` (categoria COMPLIANCE).

### 8.4 Execução local vs CI

Os mesmos hooks bloqueantes do harness Claude Code rodam também como GitHub Actions checks via workflow `kai-ai-checks.yml` distribuído pelo `kai-ai-core`. Garante que mesmo dev que desabilite hook localmente seja barrado no PR.

---

## 9. Audit trail e compliance

### 9.1 O que é auditável

| Evento | Onde fica | Formato |
|--------|-----------|---------|
| Aprovação de fase SDD | `.kai/audit/approvals.log` | append-only, assinado |
| Exceção a regra | `.kai/audit/exceptions.log` + GitHub issue | log + issue |
| Hook fire | `.kai/audit/hook-fires.log` | append-only |
| Decisão de design | `docs/specs/.../design.md` | git commit |
| Spec aprovada | `docs/specs/.../requirements.md` | git commit |
| Threat model | `docs/specs/.../THREAT-MODEL.md` | git commit |
| Comando executado | git-notes no commit | metadado |

### 9.2 Mapeamento a requisitos regulatórios

- **Bacen Resolução 4.658 (segurança cibernética):** rastreabilidade de mudanças (✓ via git + audit logs), gestão de incidentes (✓ via `kai-retro` post-mortem), gestão de acessos a ferramentas (✓ via MCP allowlist).
- **CVM Resolução 35 (custódia):** segregação de ambientes e aprovações (✓ via checkpoints SDD), trilha de decisões (✓ via specs).
- **LGPD:** prevenção de exposição de PII (✓ via `pre-commit-pii-scan`), rastreio de quem acessou o quê (✓ parcial via audit logs; integração SIEM em v2.0).

### 9.3 Retenção

`.kai/audit/` é versionado em git (retenção indefinida pela política ). Logs antigos (>1 ano) podem ser arquivados em `.kai/audit/_archive/` para evitar crescimento excessivo do diretório ativo.

---

## 10. Governança e papéis

### 10.1 Papéis

| Papel | Responsabilidade | Treinamento |
|-------|-----------------|-------------|
| **maintainers** | Mantém `kai-ai-core`, governa marketplace, avalia inclusão de MCPs, treina champions, audita uso, evolui constitution | Programa interno + acompanhamento de bootstrap nos primeiros 3 squads |
| **Tech Lead do Squad** | Opera o SDK no dia a dia, conduz `/kai-bootstrap` com squad, aprova fases SDD, decide exceções menores, conecta com maintainers | Workshop de 4h + bootstrap acompanhado |
| **AI Champion (designado por squad)** | Mantém contexto vivo (CLAUDE.md, glossário, skills), evangeliza no squad, propõe learnings aos maintainers, é ponto de contato | Programa de 8h + comunidade interna mensal |
| **Dev** | Usa o harness no dia a dia, propõe melhorias, abre exceções quando necessário | Onboarding de 1h ao instalar plugins |

### 10.2 Processo de proposta de mudança

Mudanças no `kai-ai-core` (constitution, hooks bloqueantes, MCP allowlist) seguem fluxo:

1. **Proposta:** PR ao repo `kayoridolfi-ai-plugin` com label `proposal`.
2. **Review:** maintainers + 2 AI Champions de squads diferentes.
3. **Período de comentário:** 5 dias úteis.
4. **Aprovação:** maioria simples + veto possível pelo maintainers por motivo de segurança/compliance.
5. **Release:** versão minor (`0.X.0`) ou patch (`0.X.Y`); breaking change exige major (`X.0.0`) e janela de migração de 30 dias.

### 10.3 RACI resumido

| Atividade | maintainers | Tech Lead | AI Champion | Dev |
|-----------|:----------:|:---------:|:-----------:|:---:|
| Manter constitution | R/A | C | C | I |
| Aprovar inclusão de MCP | R/A | C | C | I |
| Bootstrap do squad | C | R | A | I |
| Manter `.kai/CLAUDE.md` do squad | I | A | R | C |
| Aprovar fases SDD | I | R/A | C | C |
| Abrir exceção bloqueante | A | R | C | I |
| Propor learning ao core | C | C | R | I |

---

## 11. Roadmap faseado

### v0.1 — Foundation (Semana 1-3)

- `kai-ai-core` funcional com constitution, 4 hooks bloqueantes, comandos `/kai-help`, `/kai-status`, `/kai-approve`.
- `kai-bootstrap` funcional end-to-end.
- `kai-sdd` refatorado a partir do plugin atual.
- Marketplace interno publicado.
- Documentação por papel (maintainers, TL, Champion, Dev).
- 1 squad piloto operando.

### v0.5 — Expansão de processo (Semana 4-8)

- `kai-review` com 3 modos (code, security, spec).
- `kai-observability` com design + review.
- `kai-security` com threat-model + checklist cripto + 3 hooks bloqueantes específicos.
- `kai-retro` com extração de learnings + promoção a constitution.
- 3-5 squads operando.
- Primeira retrospectiva trimestral consolidada.

### v1.0 — Maturidade pedagógica (Semana 9-13)

- Squads piloto destravam modos relaxados após critérios objetivos atingidos.
- Hooks de PROCESSO migram de aviso para bloqueio nos squads maduros.
- CI integrado: hooks rodando como GitHub Actions checks.
- Programa formal de AI Champions com comunidade ativa.
- Dashboard básico de adoção (squads ativos, ciclos completados, exceções abertas).

### v1.5 — Inteligência e otimização (Semana 14-20)

- Análise de retros agregada via skill dedicada.
- Sugestões automáticas de skills custom baseadas em padrões repetidos.
- Detecção de drift de constitution (squads divergindo demais).
- Integração com Jira/Linear para abrir specs a partir de tickets.

### v2.0 — Plataforma corporativa (Trimestre 2)

- Marketplace interno com infraestrutura própria (mirror, controle de versão, telemetria).
- Audit logs streaming para SIEM corporativo.
- Dashboard executivo de qualidade e custo de IA por squad.
- API formal para integração com ferramentas internas (TPM, SRE, Compliance).
- Programa de certificação interno para AI Champions e TLs.

---

## 12. Riscos e mitigações

| # | Risco | Probabilidade | Impacto | Mitigação |
|---|-------|:-------------:|:-------:|-----------|
| 1 | Adoção baixa por percepção de overhead | Alta | Alto | Squad piloto com TL engajado, retro semanal, métricas de "tempo economizado em onboarding" |
| 2 | Hooks bloqueantes geram fricção excessiva | Média | Alto | Categoria QUALIDADE/PROCESSO inicia como aviso; canal direto com maintainers para feedback |
| 3 | Vazamento de dados regulados via prompt para modelos externos | Média | Crítico | MCP allowlist, hooks de PII, treinamento obrigatório, monitoramento |
| 4 | Squads driftarem da constitution | Média | Médio | Comunidade de Champions mensal, dashboard de drift na v1.0 |
| 5 | Manutenção do SDK virar gargalo no maintainers | Média | Alto | Modelo de proposta via PR distribui carga; rotação de revisores entre Champions |
| 6 | Excesso de plugins gera complexidade cognitiva | Baixa | Médio | Plugin obrigatório é mínimo; opt-in granular; `/kai-help` orienta o que cada um faz |
| 7 | Custo de IA explode sem controle | Média | Alto | Princípio #9 (custo é decisão); `kai-ai-core` expõe estimativa por fase; alertas de uso anômalo |
| 8 | Compliance regulatório identifica lacuna | Baixa | Crítico | Engajar Compliance/Jurídico em revisão formal antes de v1.0 |
| 9 | Chave de modelo IA exposta por dev | Baixa | Crítico | Hooks bloqueantes + rotação automática + secret manager corporativo |
| 10 | SDK fica desatualizado vs evolução do Claude Code | Alta | Médio | Versionamento independente, changelog disciplinado, smoke tests em cada release do Claude Code |

---

## 13. Critérios de sucesso e métricas

### 13.1 Critérios qualitativos para v1.0

- 5+ squads ativos com `kai-ai-core` + ao menos 2 plugins opcionais.
- 80%+ das features não-triviais nesses squads passando pelo ciclo SDD completo.
- Zero incidentes de vazamento de segredo via Claude Code nos squads piloto.
- maintainers consegue manter o SDK com ≤20% de seu tempo.
- Comunidade de AI Champions ativa (encontro mensal com >70% de presença).

### 13.2 Métricas quantitativas (capturadas via audit logs e git)

| Métrica | Como mede | Meta v1.0 |
|---------|-----------|-----------|
| Adoção | Squads com `.kai/` no repo | ≥5 |
| Ciclos completados | Pastas em `_archive/` por trimestre | ≥3 por squad ativo |
| Hook fires bloqueantes | Eventos em `hook-fires.log` por semana | Decrescente após semana 4 |
| Exceções abertas | Issues label `kai-exception` | ≤2 por squad por mês |
| Tempo de bootstrap | Início → `.kai/CLAUDE.md` gerado | ≤1h |
| Tempo de onboarding novo dev | Junção do dev → primeiro PR mergeado | -30% vs baseline pré-SDK |
| Cobertura de threat-model | Features tocando ativos críticos com `THREAT-MODEL.md` | 100% |

### 13.3 Critérios para destravar modo relaxado

Squad demonstra maturidade quando:
- 3+ ciclos SDD completos sem exceção a hook bloqueante.
- 2+ retros consecutivas com proposta promovida ao core.
- Champion ativo no programa há ≥8 semanas.

Destravado: pode usar `/kai-fast` para tarefas pequenas (commit direto com hooks de qualidade), mantendo ciclo completo para features.

---

## 14. Apêndices

### A. Estrutura de pastas — exemplo completo

```
kayoridolfi-ai-plugin/
├── README.md
├── LICENSE
├── CHANGELOG.md
├── .claude-plugin/
│   └── marketplace.json
├── docs/
│   ├── plans/2026-05-10-kayoridolfi-ai-plugin-design.md
│   ├── governance/raci.md
│   ├── governance/proposal-process.md
│   ├── playbooks/install-by-role.md
│   ├── playbooks/run-bootstrap.md
│   ├── playbooks/handle-exception.md
│   └── faq.md
└── plugins/
    ├── kai-ai-core/
    │   ├── .claude-plugin/plugin.json
    │   ├── README.md
    │   ├── skills/kai-constitution/SKILL.md
    │   ├── commands/{kai-help,kai-status,kai-approve,kai-exception}.md
    │   ├── hooks/hooks.json
    │   ├── hooks/scripts/{secret-scan,destructive-confirm,audit-log,mcp-allowlist}.sh
    │   ├── config/mcp-allowlist.json
    │   └── config/constitution.md
    ├── kai-bootstrap/
    │   ├── .claude-plugin/plugin.json
    │   ├── README.md
    │   ├── skills/kai-bootstrap/SKILL.md
    │   ├── skills/kai-bootstrap/scripts/repo-scan.sh
    │   ├── skills/kai-bootstrap/assets/templates/{CLAUDE.md.tpl,glossary.md.tpl,runbook.md.tpl}
    │   └── commands/{kai-bootstrap,kai-bootstrap-rescan,kai-enrich-domain,kai-enrich-runbooks,kai-enrich-skills}.md
    ├── kai-sdd/
    │   ├── .claude-plugin/plugin.json
    │   ├── README.md
    │   ├── skills/kai-sdd/  (refator do plugin atual)
    │   └── commands/{kai-spec,kai-spec-discuss,kai-spec-requirements,kai-spec-design,kai-spec-plan,kai-spec-execute,kai-spec-verify,kai-spec-retro,kai-hotfix,kai-spike}.md
    ├── kai-review/
    │   ├── .claude-plugin/plugin.json
    │   ├── README.md
    │   ├── skills/{kai-code-reviewer,kai-security-reviewer,kai-spec-reviewer}/SKILL.md
    │   └── commands/{kai-review-pr,kai-review-security,kai-review-spec,kai-review-fix}.md
    ├── kai-observability/
    │   ├── .claude-plugin/plugin.json
    │   ├── README.md
    │   ├── skills/{kai-observability-designer,kai-observability-reviewer}/SKILL.md
    │   └── commands/{kai-observability-design,kai-observability-review,kai-runbook-from-incident}.md
    ├── kai-security/
    │   ├── .claude-plugin/plugin.json
    │   ├── README.md
    │   ├── skills/{kai-threat-modeler,kai-compliance-advisor,kai-crypto-advisor}/SKILL.md
    │   ├── hooks/hooks.json
    │   ├── hooks/scripts/{pii-scan,private-key-scan,prod-secret-access}.sh
    │   └── commands/{kai-threat-model,kai-security-checklist,kai-compliance-check,kai-secret-rotate}.md
    └── kai-retro/
        ├── .claude-plugin/plugin.json
        ├── README.md
        ├── skills/{kai-retro-facilitator,kai-learning-extractor}/SKILL.md
        └── commands/{kai-retro,kai-retro-promote,kai-retro-extract-skill,kai-retro-quarterly}.md
```

### B. Glossário rápido

- **EARS:** Easy Approach to Requirements Syntax — formato `When/Where/While/If <trigger> Then <system response>`.
- **STRIDE:** Spoofing, Tampering, Repudiation, Info disclosure, DoS, Elevation of privilege — modelo de threat modeling.
- **Spec ativa:** spec em `docs/specs/_active/` — em desenvolvimento.
- **Constitution:** princípios não-negociáveis carregados em todo contexto.
- **Hook bloqueante:** intercepta ação e impede sua execução até critério ser atendido.
- **MCP allowlist:** lista de Model Context Protocol servers aprovados pelo maintainers.
- **AI Champion:** referência de IA dentro do squad, ponto de contato com maintainers.

### C. FAQ

**P: Sou dev solo num squad pequeno, preciso de tudo isso?**
R: Não. Comece com `kai-ai-core` + `kai-sdd`. Adicione outros conforme necessidade.

**P: Posso desabilitar um hook que está atrapalhando?**
R: Hooks de SEGURANÇA/COMPLIANCE não. Hooks de PROCESSO/QUALIDADE sim, via `.kai/config.yaml`. Mudança fica registrada.

**P: Meu squad usa stack X, vocês não documentaram nada para X.**
R: Por design — o SDK é stack-agnostic. `/kai-bootstrap` gera contexto específico para sua stack.

**P: Como reportar bug no SDK?**
R: Issue no repo `kayoridolfi-ai-plugin` com label `bug`. Para problemas urgentes, contato direto com maintainers.

**P: O SDK envia dados para fora?**
R: O SDK em si não envia nada. As ferramentas que ele orquestra (Claude Code, MCPs aprovados) seguem suas próprias políticas. MCPs externos passam por avaliação de exfiltração.

---

**Fim do documento. Próximos passos:** publicar este documento, conduzir kick-off com maintainers e TLs piloto, iniciar implementação conforme roadmap §11.
