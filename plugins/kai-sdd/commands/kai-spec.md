---
description: Conduz o ciclo SDD completo (discuss → spec → plan → execute → verify → review → ship → retro) com checkpoints obrigatórios
argument-hint: <slug-da-feature>
---

# /kai-spec

Conduza o ciclo SDD completo invocando a skill `kai-sdd`. Comportamento:

0. **Banner de início:**
   ```bash
   bash "${CLAUDE_PLUGIN_ROOT}/../kai-ai-core/lib/ascii.sh" spec-start accent
   ```
1. **Setup:** crie `docs/specs/_active/<YYYY-MM-DD>-<slug>/` com `status.md`.
2. **Para cada fase** (DISCUSS, SPEC, PLAN, EXECUTE, VERIFY, REVIEW, SHIP, RETRO):
   - Conduza a fase conforme `references/phase-playbook.md`.
   - Gere o(s) artefato(s) da fase.
   - **PAUSE** e peça ao usuário para executar `/kai-approve <FASE>` antes de prosseguir.
   - Após aprovação, prossiga para próxima fase.
3. **Integrações automáticas:**
   - Em PLAN: se a feature toca ativo crítico (ver `.kai/CLAUDE.md`, fluxos críticos, regulação), invoque `/kai-threat-model` antes de `design.md`. Sempre invoque `/kai-observability-design`.
   - Em REVIEW: invoque `/kai-review-pr` (code), `/kai-review-spec` (coverage), e `/kai-review-security` se ativo crítico.
   - Em SHIP: garanta PR aberto referenciando spec; tag com versão se aplicável.
   - Em RETRO: invoque `/kai-retro` ao fim.

**Importante:**
- Pular fases requer `/kai-exception` com justificativa.
- Tasks em EXECUTE devem gerar commits atômicos com `[spec:<slug>] <msg>`.
- Não declare "pronto" sem `verification.md` aprovado.
