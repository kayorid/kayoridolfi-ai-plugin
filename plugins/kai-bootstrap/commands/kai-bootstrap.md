---
description: Onboarding completo do squad ao Kayoridolfi AI Plugin — análise automática + entrevista guiada + plano de enriquecimento
---

# /kai-bootstrap

Invoque a skill `kai-bootstrap` e conduza o fluxo completo:

1. **Análise automática:** rode `${CLAUDE_PLUGIN_ROOT}/skills/kai-bootstrap/scripts/repo-scan.sh` e apresente o resumo.
2. **Entrevista guiada:** conduza as 10 perguntas de `references/interview-questions.md`, uma por vez, registrando em `.kai/bootstrap/interview.md`.
3. **Geração:** crie `.kai/CLAUDE.md`, `.kai/glossary.md`, `.kai/runbooks/`, `.kai/skills/`, `.kai/hooks/`, `.kai/bootstrap/enrichment-plan.md`, `.kai/config.yaml` usando templates de `assets/templates/`.
4. **Commit:** sugira commit inicial.
5. **Próxima ação:** oriente rodar `/kai-spec` na primeira feature e cumprir missão da semana 1.

Pré-requisito: `kai-ai-core` ativo, repositório git, sem `.kai/CLAUDE.md` existente (caso contrário, sugira `/kai-bootstrap-rescan`).
