# kai-cost

Exposição de custo de IA — princípio Kayoridolfi AI #9: "custo de IA é decisão de engenharia". Sem visibilidade, custo escala silenciosamente.

## Comandos

| Comando | Propósito |
|---------|-----------|
| `/kai-cost` | Resumo do dia/semana corrente |
| `/kai-cost-feature <slug>` | Custo total de uma feature por fase |
| `/kai-cost-budget set <valor>` | Define orçamento mensal do squad |
| `/kai-cost-alert` | Alerta se consumo > X% do budget |

## Mecânica

- Hook `PostToolUse` captura input/output tokens reportados nos resultados de tool.
- Persiste em `.kai/audit/cost.log` (linha por evento, append-only).
- Agrega por fase SDD (lê spec ativa), feature, dia, dev.

Esquema do log:

```
2026-05-10T14:32:11Z | feature=onboarding-v2 | phase=DESIGN | tool=Read | in_tokens=2400 | out_tokens=850 | model=claude-opus | actor=joao@example.com
```

## Pré-requisitos

- `kai-ai-core` ativo (constitution + audit dir).
- Idealmente `kai-sdd` (para mapear fase atual).
