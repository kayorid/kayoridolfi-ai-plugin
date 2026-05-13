# kai-sdd

Espinha dorsal do Kayoridolfi AI Plugin. Ciclo Spec-Driven Development rígido com checkpoints humanos obrigatórios e audit-trail compatível com requisitos regulatórios.

## Comandos

| Comando | Fase do ciclo |
|---------|---------------|
| `/kai-spec` | Conduz o ciclo completo (discuss → spec → plan → execute → verify → review → ship → retro) |
| `/kai-spec-discuss` | Apenas DISCUSS (ambiguity scoring) |
| `/kai-spec-requirements` | Apenas SPEC (gera `requirements.md` em EARS) |
| `/kai-spec-design` | Apenas PLAN parte 1 (`design.md`) |
| `/kai-spec-plan` | Apenas PLAN parte 2 (`tasks.md`) |
| `/kai-spec-execute` | Executa tasks com commits atômicos |
| `/kai-spec-verify` | Verificação goal-backward |
| `/kai-spec-retro` | Retrospectiva da feature |
| `/kai-hotfix` | Modo expresso (pula DISCUSS/SPEC, post-mortem em 48h) |
| `/kai-spike` | Modo exploratório (branch descartável) |

## Ciclo

```
DISCUSS → SPEC → PLAN → EXECUTE → VERIFY → REVIEW → SHIP → RETRO
   ✓        ✓      ✓       commit     ✓       ✓       PR     ↻
   /kai-approve em cada fase
```

## Pré-requisitos

- `kai-ai-core` ativo.
- `kai-bootstrap` executado (`.kai/CLAUDE.md` existe).
- Recomendado: `kai-review`, `kai-security`, `kai-observability`, `kai-retro` para integração completa.

## Artefatos por feature

```
docs/specs/_active/<data>-<feature>/
├── discuss.md
├── requirements.md       # EARS notation
├── design.md
├── tasks.md
├── execution.log
├── verification.md
├── REVIEW.md             # via kai-review
├── THREAT-MODEL.md       # via kai-security (se aplicável)
├── OBSERVABILITY.md      # via kai-observability
├── approvals.log         # via /kai-approve
└── retro.md              # via kai-retro
```
