---
name: kai-intel
description: Use quando o usuário pedir para registrar uma decisão de arquitetura, consultar histórico de decisões cross-squad, buscar conteúdo em specs/retros/audit, ou verificar se a implementação atual divergiu da spec/plan. Cobre `/kai-graph-add`, `/kai-graph-query`, `/kai-graph-export`, `/kai-search`, `/kai-drift-check`. Acione também quando o usuário mencionar "knowledge graph", "drift", "busca semântica", "decisões anteriores", "memória organizacional" ou pedir para mapear dependências entre squads.
---

# Inteligência Operacional Kayoridolfi AI

Esta skill cobre três pilares de inteligência sobre o que o squad já produziu:

## 1. Knowledge Graph (`.kai/intel/graph.json`)

Grafo JSON local com nós tipados (`decision`, `learning`, `spec`, `incident`, `runbook`, `dependency`) e arestas livres. Pensado para registrar decisões cross-squad que costumam ser perdidas em Slack.

**Quando adicionar nó:**
- Decisão arquitetural não-trivial ("escolhemos gRPC", "kafka tem 3 partições por tópico")
- Learning de retro que tem aplicação cross-squad
- Incidente cuja causa raiz vai informar próximas decisões
- Dependência entre squads que não está documentada no código

**Comandos:**
- `/kai-graph-add <type> "<title>" [--tags t1,t2] [--squad name] [--links id1,id2]`
- `/kai-graph-query [--type T] [--tag T] [--squad S] [--text "..."]`
- `/kai-graph-export [--format dot|mermaid|json] > graph.dot`

## 2. Search (`/kai-search`)

Busca lexical com ranking BM25 sobre:
- `.kai/intel/graph.json` (nós + tags + descrições)
- `.kai/audit/*.log` (eventos auditados)
- `docs/specs/_active/**/*.md` e `_completed/**/*.md`
- `docs/playbooks/`, `docs/runbooks/` se existirem

Indexa sob demanda em `.kai/intel/search-index.json`. Reconstruído com `/kai-search --reindex`.

**Quando usar:**
- "Já decidimos algo sobre rate limiting?"
- "Onde está a spec do feature X?"
- "Quem implementou retry policy similar antes?"

## 3. Drift Detection (`/kai-drift-check`)

Compara a spec ativa (`docs/specs/_active/<feature>/`) com o estado atual do código:
- Arquivos prometidos no `plan.md` que não existem
- Endpoints/funções descritos em `design.md` ausentes do repo
- Decisões em `decisions.md` contraditas pelo código

Não bloqueia — apenas reporta. Roda em CI opcionalmente via `/kai-drift-check --ci`.

## Princípios

- **Local-first**: nada sai da máquina. Sem cloud, sem telemetria externa.
- **Plain JSON**: arquivos editáveis à mão, versionáveis no git.
- **Sem dependências exóticas**: bash + jq + awk + ripgrep (opcional).
- **Upgrade path**: a interface de busca é estável; v2.5+ pode trocar BM25 por embeddings sem breaking change.

## Anti-patterns

- ❌ Não use o grafo como ticket tracker — Linear/Jira existem para isso. Grafo é para **decisões persistentes**.
- ❌ Não rode `/kai-drift-check` em fases iniciais de spec — só faz sentido após DESIGN/PLAN.
- ❌ Não confunda `/kai-search` com `grep` — search retorna nós do grafo + trechos rankeados, não linhas brutas.
