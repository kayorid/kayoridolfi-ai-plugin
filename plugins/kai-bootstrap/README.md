# kai-bootstrap

Onboarding híbrido de squad ao Kayoridolfi AI Plugin. Combina análise automática do repositório, entrevista guiada e plano de enriquecimento contínuo para gerar contexto rico e específico do squad.

## Comandos

| Comando | Quando usar |
|---------|-------------|
| `/kai-bootstrap` | Primeira vez do squad com o SDK |
| `/kai-bootstrap-rescan` | Após refator grande, mudança de stack ou trimestralmente |
| `/kai-enrich-domain` | Aprofundar glossário e contexto de domínio |
| `/kai-enrich-runbooks` | Documentar runbooks operacionais |
| `/kai-enrich-skills` | Identificar e gerar skills custom do squad |

## Fluxo

1. **Análise automática (5 min, sem humano):** detecta stack, frameworks, estrutura, CI, testes, IaC, observabilidade.
2. **Entrevista guiada (20-30 min, com TL + squad + maintainers):** 10 perguntas estruturadas sobre domínio, fluxos críticos, dores, prioridades.
3. **Geração:** cria `.kai/CLAUDE.md`, `.kai/glossary.md`, `.kai/runbooks/`, `.kai/skills/`, `.kai/hooks/`, plano de enriquecimento.

## Pré-requisitos

- `kai-ai-core` instalado e ativo.
- Repositório git inicializado.
- Permissão de escrita no repositório.
- Tech Lead presente; maintainers acompanhando primeiras execuções.
