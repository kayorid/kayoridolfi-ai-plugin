# Guia de plugins opt-in

O Kayoridolfi AI Plugin distribui **9 plugins**. Sete são **default** (todo squad instala). Dois são **opt-in** — ligados conscientemente por quem precisa.

## Default (sempre instalado)

`kai-ai-core`, `kai-bootstrap`, `kai-sdd`, `kai-review`, `kai-observability`, `kai-security`, `kai-retro`.

## Opt-in

### `kai-evals` — framework de avaliação para features de IA

**Quando ligar:** seu squad está construindo uma feature que **chama um modelo de IA em runtime** (resposta a usuário, classificação, sumarização). Sem eval estruturado, regressão de qualidade fica invisível.

**Quando NÃO ligar:** squad que apenas usa IA como ferramenta de dev (Claude Code, Cursor) sem expor IA ao usuário final.

**Overhead:**
- `/kai-evals-init` para configurar: ~5min
- `/kai-evals-run` em CI: depende do golden dataset (10 exemplos ≈ 30s)
- Custo: chamadas extras ao modelo durante eval (cobrir no orçamento de IA do squad)

**Saída:**
- `evals/<feature>/runs/*.jsonl` — histórico de scores
- `/kai-evals-compare` — diff entre runs

### `kai-cost` — captura de tokens & custo

**Quando ligar:** squad que quer rastrear custo de uso de IA (Claude Code, AI features em produção) para reportar a Tech Lead / Finance.

**Quando NÃO ligar:** squad que ainda está em fase exploratória sem KPI de custo.

**Overhead:**
- Hook `PostToolUse` adiciona ~10ms por chamada
- Arquivo `.kai/cost-events.jsonl` cresce ~1MB/semana em uso intensivo
- Privacy: nenhum conteúdo de prompt é gravado — só tokens + modelo + timestamp

**Saída:**
- `/kai-cost-report` — relatório de uso e custo no período
- Limitação conhecida: Claude Code raramente expõe `usage` em payloads de tool individuais; captura é parcial. Em v1.0+ mudará para `Stop`/`SessionEnd` lendo transcript.

## Como ativar

```bash
# Adicione ao seu ~/.claude/settings.json
{
  "plugins": {
    "kai-evals": { "enabled": true },
    "kai-cost":  { "enabled": true }
  }
}
```

Ou via comando:

```bash
/plugin install kai-evals@kayoridolfi-ai-plugin
/plugin install kai-cost@kayoridolfi-ai-plugin
```

## Critério de decisão rápida

| Você está... | Ligar? |
|---|---|
| Construindo chatbot ou feature AI exposta ao usuário | **kai-evals: sim** |
| Reportando custo de IA mensalmente | **kai-cost: sim** |
| Apenas explorando IA como ferramenta interna | **nenhum** |
| Squad com orçamento de IA estourando | **kai-cost: urgente** |
| Squad com cliente reclamando de qualidade AI | **kai-evals: urgente** |

## Roadmap

- v0.5: este guia.
- v1.0: dashboard cross-squad de adoção (`/kai-adoption-report`) usa dados destes 2 plugins quando ligados.
- v1.5: telemetria opt-in agregada (sem PII) cruzando uso × custo × qualidade.
