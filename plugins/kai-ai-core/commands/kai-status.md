---
description: Diagnóstico de instalação do Kayoridolfi AI Plugin no repositório atual — plugins, hooks, MCPs, presença de .kai/, conformidade
---

# /kai-status

Produza um diagnóstico estruturado do estado do Kayoridolfi AI Plugin no repositório atual.

## Verificações a executar

### 1. Plugins  ativos

Liste plugins  instalados (consulte `~/.claude/settings.json` e plugins disponíveis no contexto). Para cada um indique versão.

### 2. Estrutura `.kai/` do squad

Verifique a presença e validade de:
- `.kai/CLAUDE.md` (existe? última atualização?)
- `.kai/glossary.md`
- `.kai/runbooks/`
- `.kai/skills/`
- `.kai/hooks/`
- `.kai/audit/` (logs presentes?)
- `.kai/bootstrap/` (squad foi bootstrapado?)

### 3. Specs ativas

Conte e liste specs em `docs/specs/_active/`. Para cada uma indique fase atual estimada (último artefato presente).

### 4. Conformidade com constitution

Sinalize divergências:
- `.env` rastreado em git? (deve usar `.env.example`)
- Hooks do `kai-ai-core` carregados?
- MCP allowlist sendo respeitada?

### 5. Audit-trail

- Quantas aprovações registradas em `.kai/audit/approvals.log` nos últimos 30 dias?
- Quantas exceções abertas em `.kai/audit/exceptions.log`?
- Quantos hook fires bloqueantes em `.kai/audit/hook-fires.log` nos últimos 7 dias?

## Formato da saída

```
Kayoridolfi AI Plugin — Status do repositório

Plugins ativos:
  ✓ kai-ai-core@0.1.0
  ✓ kai-sdd@0.1.0
  ✗ kai-bootstrap não instalado
  ...

Bootstrap do squad: [✓ feito em 2026-04-20 | ✗ não realizado — rode /kai-bootstrap]

.kai/ presente: [✓ | ✗]
  ├─ CLAUDE.md ........... [✓ atualizado | ⚠ desatualizado >90d | ✗ ausente]
  ├─ glossary.md ......... ...
  ...

Specs ativas: 2
  • 2026-05-10-onboarding-v2 (fase: PLAN)
  • 2026-05-08-fee-engine-rewrite (fase: EXECUTE)

Conformidade:
  ✓ .env não rastreado
  ✓ Hooks de segurança carregados
  ⚠ MCP "exemplo" em uso, não está na allowlist

Audit-trail (últimos 30d):
  Aprovações: 14
  Exceções: 1
  Hook fires bloqueantes: 3

Próxima ação sugerida: <ação contextual>
```

Seja preciso e factual. Se algo não pode ser verificado, diga explicitamente.
