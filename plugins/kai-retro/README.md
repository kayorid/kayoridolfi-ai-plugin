# kai-retro

Transforma cada ciclo SDD em aprendizado coletivo. Extrai learnings, propõe evolução de constitution e skills, alimenta a memória organizacional do projeto.

## Comandos

| Comando | Propósito |
|---------|-----------|
| `/kai-retro` | Conduz retrospectiva estruturada da feature/fase corrente |
| `/kai-retro-promote` | Promove learning local para proposta de PR ao kai-ai-core |
| `/kai-retro-extract-skill` | Identifica padrões repetidos e propõe skill custom |
| `/kai-retro-quarterly` | Agrega retros do trimestre, gera relatório executivo |

## Skills

- `kai-retro-facilitator` — facilita a sessão de retrospectiva.
- `kai-learning-extractor` — analisa retros agregadas e identifica padrões promovíveis.

## Filosofia

A memória organizacional é vantagem competitiva. Cada feature gera aprendizado — sem captura sistemática, esse aprendizado se perde quando alguém sai do time ou quando contexto é trocado. `kai-retro` garante que learnings viram artefatos versionados, evoluem a constitution e retroalimentam o processo.

## Saídas

- `docs/specs/_active/<feature>/retro.md`
- `.kai/learnings/quarterly-<YYYY-Qn>.md`
- PRs ao `kayoridolfi-ai-plugin` com propostas de mudança
- Skills custom em `.kai/skills/`
