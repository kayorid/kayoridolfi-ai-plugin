# kai-review

Processo padronizado de revisão para o Kayoridolfi AI Plugin. Code review, security review e spec coverage como agentes formais — não como atividade ad-hoc.

## Comandos

| Comando | Propósito |
|---------|-----------|
| `/kai-review-pr <pr-or-branch>` | Code review estruturado contra spec e constitution |
| `/kai-review-security` | Security review (OWASP top 10 + cripto + segredos) |
| `/kai-review-spec` | Coverage spec ↔ implementação (todo critério EARS coberto?) |
| `/kai-review-fix` | Aplica correções de findings BLOCK/HIGH de um REVIEW.md |

## Skills (subagentes especializados)

- `kai-code-reviewer` — revisor de código (qualidade, design, padrões).
- `kai-security-reviewer` — revisor de segurança (OWASP + cripto + dados).
- `kai-spec-reviewer` — verifica coverage spec ↔ implementação.

## Saídas

`docs/specs/_active/<feature>/REVIEW.md` com findings classificados por severidade:

| Severidade | Significado | Ação requerida |
|-----------|-------------|----------------|
| BLOCK | Não pode mergear | Resolver antes de SHIP |
| HIGH | Risco real | Resolver ou justificar |
| MEDIUM | Qualidade ou manutenibilidade | Resolver na sprint |
| LOW | Nice-to-have | Backlog |
| INFO | Observação | Documentar |

## Pré-requisitos

- `kai-ai-core` ativo.
- Recomendado: `kai-sdd` (review se beneficia de spec referenciada) e `kai-security` (delegação para revisor de segurança).
