# Guia de instalação por papel

Como instalar e configurar o Kayoridolfi AI Plugin conforme seu papel.

---

## 🛡 maintainers (responsável pelo SDK)

### O que você precisa fazer uma vez

1. **Manter o repositório `kayorid/kayoridolfi-ai-plugin`** no GitHub (espelho do `kayorid/kayoridolfi-ai-plugin` para devs externos).
2. **Validar instalação local** completa via wizard automático:
   ```
   /kai-init
   ```
   Configura `~/.claude/settings.json` com 9 plugins + backup automático.

   **Ou setup manual** em `~/.claude/settings.json`:
   ```json
   {
     "extraKnownMarketplaces": {
       "kai": {
         "source": {
           "source": "github",
           "repo": "kayorid/kayoridolfi-ai-plugin"
         }
       }
     },
     "enabledPlugins": {
       "kai-ai-core@kai": true,
       "kai-bootstrap@kai": true,
       "kai-sdd@kai": true,
       "kai-review@kai": true,
       "kai-observability@kai": true,
       "kai-security@kai": true,
       "kai-retro@kai": true,
       "kai-cost@kai": true,
       "kai-evals@kai": true
     }
   }
   ```
3. **Validar** com `/kai-doctor` em qualquer repositório de teste.
4. **Configurar permissões** no GitHub para PRs ao SDK (label `proposal` requer review dos maintainers).

### Suas responsabilidades operacionais

- Aprovar inclusão de novos MCPs (PRs ao `mcp-allowlist.json`).
- Aprovar mudanças à `constitution.md`.
- Conduzir/acompanhar primeiros 3 bootstraps de squads.
- Treinar AI Champions (programa de 8h).
- Manter comunidade mensal de Champions.
- Auditar exceções abertas (`kai-exception` issues).
- Releases do SDK: cadência, changelog, comunicação.

---

## 👨‍💻 Tech Lead (operador do SDK no squad)

### Antes do primeiro uso

1. **Confirme que o maintainers já validou o SDK** internamente (versão estável).
2. **Em `~/.claude/settings.json`**: copie o bloco do maintainers acima.
3. **Reinicie o Claude Code**.
4. Em qualquer repositório, rode `/kai-status` para confirmar plugins ativos.

### Conduzindo o bootstrap do squad

1. **Agende 60-90min** com squad inteiro + maintainers presente (primeira vez).
2. No repositório principal do squad, rode:
   ```
   /kai-bootstrap
   ```
3. Acompanhe a análise automática (5min) — leia o resumo com o squad.
4. Conduza a entrevista (10 perguntas, 20-30min). Squad inteiro contribui; você consolida.
5. Revise os artefatos gerados (`.kai/CLAUDE.md`, `glossary.md`, plano de enriquecimento).
6. Commit inicial (sugerido pelo plugin).

### No dia a dia

- Toda feature não-trivial passa por `/kai-spec`.
- Você é quem aprova fases via `/kai-approve <fase>` (ou delega ao AI Champion).
- Você decide quando abrir `/kai-exception`.
- Após cada feature: `/kai-spec-retro`.
- Trimestralmente: `/kai-retro-quarterly` para consolidar learnings.

### Quando escalar ao maintainers

- Hooks bloqueantes gerando fricção excessiva → discutir antes de abrir exceção.
- Necessidade de novo MCP → PR + revisão dos maintainers.
- Proposta de mudança à constitution → `/kai-retro-promote`.
- Dúvidas regulatórias → Compliance + maintainers.

---

## 🌟 AI Champion (referência local do squad)

### Suas responsabilidades

- Manter `.kai/CLAUDE.md` vivo (atualizar após mudanças significativas).
- Conduzir missões de enriquecimento mensais (`/kai-enrich-domain`, `/kai-enrich-runbooks`, `/kai-enrich-skills`).
- Ser ponto de contato para devs do squad em dúvidas sobre o SDK.
- Identificar candidatos a skill custom (`/kai-retro-extract-skill`).
- Promover learnings ao core (`/kai-retro-promote`).
- Participar da comunidade mensal de Champions com maintainers.

### Setup técnico

Mesmo do Tech Lead. Adicionalmente:
- Tenha acesso ao repositório `kayorid/kayoridolfi-ai-plugin` para abrir PRs com propostas.
- Configure notificações Slack para canal `#kai-ai-plugin`.

### Programa de treinamento

- 8h iniciais (acompanhar maintainers em 1-2 bootstraps).
- Comunidade mensal (1h).
- Sessão de revisão semestral com maintainers sobre evolução do SDK.

---

## 👤 Dev (consumidor do SDK)

### Setup mínimo

1. Em `~/.claude/settings.json`, ative os plugins (peça o JSON ao Tech Lead/Champion):
   ```json
   {
     "enabledPlugins": {
       "kai-ai-core@kai": true,
       "kai-sdd@kai": true,
       "kai-review@kai": true
     }
   }
   ```
   *(Adicione os demais conforme o squad usa.)*
2. Reinicie o Claude Code.
3. Confirme com `/kai-help`.

### No dia a dia

- Para entender o squad: leia `.kai/CLAUDE.md`.
- Para nova feature: `/kai-spec <slug>`.
- Para review de PR: `/kai-review-pr`.
- Para hotfix: `/kai-hotfix`.
- Para dúvida sobre o SDK: `/kai-help` ou pergunte ao AI Champion.

### Boas práticas

- Sempre referencie spec ativa em mensagens de commit (`[spec:<slug>] <msg>`).
- Não tente desabilitar hooks bloqueantes — abra `/kai-exception` se necessário.
- Contribua para retros: o squad só melhora se vocês falarem.
- Sugira skills custom ao AI Champion quando perceber repetição.

---

## Verificação rápida pós-instalação

Em qualquer repositório, rode:

```
/kai-status
```

Saída esperada (mínimo):

```
Kayoridolfi AI Plugin — Status do repositório

Plugins ativos:
  ✓ kai-ai-core@0.1.0
  ✓ kai-sdd@0.1.0
  ...

Bootstrap do squad: ✗ não realizado — rode /kai-bootstrap (apenas TL)

Conformidade:
  ✓ .env não rastreado
  ✓ Hooks de segurança carregados

Próxima ação sugerida: rodar /kai-bootstrap (TL) ou /kai-help (visão geral)
```

Se algo estiver vermelho, pergunte ao AI Champion ou ao maintainers.
