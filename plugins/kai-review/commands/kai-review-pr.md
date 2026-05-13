---
description: Code review estruturado de PR ou branch contra spec ativa e constitution
argument-hint: <pr-url-or-branch>
---

# /kai-review-pr

Execute code review estruturado:

1. Identifique escopo (PR via `gh pr view`, branch via `git diff main...HEAD`).
2. Identifique spec ativa relacionada (`docs/specs/_active/<feature>/`).
3. Invoque a skill `kai-code-reviewer` para análise.
4. Para cada arquivo modificado, avalie correctness, design, clareza, padrões , testes.
5. Classifique findings (BLOCK/HIGH/MEDIUM/LOW/INFO).
6. Gere/atualize `docs/specs/_active/<feature>/REVIEW.md`.
7. Sugira ao usuário: invocar `/kai-review-security` se houver suspeita de issue de segurança, e `/kai-review-spec` para coverage.
8. Se findings BLOCK ou HIGH: oriente correção antes de SHIP.

Para findings que dá pra corrigir automaticamente, sugira `/kai-review-fix`.
