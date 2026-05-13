---
description: Promove learning local a proposta de PR ao kai-ai-core (constitution)
argument-hint: <descrição-da-proposta>
---

# /kai-retro-promote

Promova um learning do squad para proposta corporativa:

1. Capture do usuário:
   - Qual o learning (regra, padrão, comportamento)?
   - Por quê deve ir para constitution? (universalidade, frequência, impacto)
   - Que retros documentam essa necessidade? (links/refs)
   - Proposta de redação para o `constitution.md`.
2. Faça fork (ou clone) do `kayoridolfi-ai-plugin` (ou prepare branch local se você tem acesso direto).
3. Crie branch `proposal/<slug>`.
4. Edite `plugins/kai-ai-core/config/constitution.md` com a proposta.
5. Atualize `CHANGELOG.md` com a proposta.
6. Abra PR com:
   - Título: `[proposal] <título-curto>`
   - Labels: `proposal`, `needs-maintainer-review`
   - Body: justificativa, retros de origem, redação proposta, squads que se beneficiariam.
7. Notifique maintainers no canal Slack.

Reveja `docs/governance/proposal-process.md` para detalhes do fluxo de aprovação.
