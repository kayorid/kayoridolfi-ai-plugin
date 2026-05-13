# Integração Slack — `kai-bot`

> **v1.0 — implementação funcional.** Bolt JS (Node 20), com modo mock para testes offline.

Bot Slack que expõe comandos do Kayoridolfi AI Plugin no workspace.

## Comandos atuais

- `@kai-ai retro <squad>` — última retrospectiva do squad no thread
- `@kai-ai help` — lista de comandos disponíveis

Comandos planejados (futuras versões):
- `@kai-ai status <squad>` — saúde do squad (dashboard)
- `@kai-ai adoption` — sumário de adoção do SDK

## Como rodar

### Modo mock (testes / dev sem Slack)

```bash
cd integrations/slack
npm install
KAI_MOCK_SLACK=1 npm run dev
```

Em mock mode, o bot inicia sem conectar ao Slack e lê retros de `fixtures/`. Útil para CI e dev offline.

### Produção

```bash
cd integrations/slack
npm install --omit=dev

export SLACK_BOT_TOKEN=xoxb-...
export SLACK_SIGNING_SECRET=...
export SLACK_APP_TOKEN=xapp-...   # opcional, ativa Socket Mode
export KAI_RETROS_PATH=/path/to/.kai/retros

npm start
```

### Docker

```bash
docker build -t kai-slack .
docker run --rm \
  -e SLACK_BOT_TOKEN \
  -e SLACK_SIGNING_SECRET \
  -e KAI_RETROS_PATH=/data/retros \
  -v /opt/kai/retros:/data/retros \
  -p 3000:3000 \
  kai-slack
```

## Testes

```bash
npm test
```

Suite usa `node:test` (zero deps adicionais), exercita o mock mode + adapter.

## Configuração no Slack

Use o `manifest.yaml` na raiz desta pasta:

1. **Slack API → Apps → Create New App → From Manifest**
2. Cole o conteúdo de `manifest.yaml`
3. Instale no workspace
4. Copie tokens (`xoxb-`, `xapp-`, signing secret) para o cofre da Plataforma
5. Deploy do container

## Variáveis de ambiente

| Variável | Obrigatória | Descrição |
|---|---|---|
| `SLACK_BOT_TOKEN` | sim (prod) | `xoxb-...` |
| `SLACK_SIGNING_SECRET` | sim (prod) | secret do manifest |
| `SLACK_APP_TOKEN` | opcional | ativa Socket Mode (sem expor porta) |
| `KAI_RETROS_PATH` | não | path para retros (default `.kai/retros`) |
| `KAI_MOCK_SLACK` | não | `=1` ativa mock mode |
| `PORT` | não | default `3000` |

## Segurança

- Tokens **nunca** commitados (`.env*` bloqueado pelo `pre-write-guard.sh` do SDK)
- Bot responde **apenas** em threads onde foi mencionado (`@kai-ai`)
- Não executa comandos arbitrários — só os handlers em `handlers/`
- Mock mode é seguro para CI: zero network calls
