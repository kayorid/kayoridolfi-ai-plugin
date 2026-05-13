---
description: Define ou consulta o orçamento mensal de IA do squad
argument-hint: [set <valor> | show]
---

# /kai-cost-budget

Gerenciamento de orçamento em `.kai/cost-budget.yaml`.

**Set budget:**
```bash
echo "monthly_budget_brl: $2" > .kai/cost-budget.yaml
echo "✓ Orçamento mensal: R$$2"
```

**Show:**
```bash
cat .kai/cost-budget.yaml 2>/dev/null && echo "" && bash "${CLAUDE_PLUGIN_ROOT}/scripts/cost-report.sh" month
```

Use `/kai-cost-alert` para verificar consumo vs budget.
