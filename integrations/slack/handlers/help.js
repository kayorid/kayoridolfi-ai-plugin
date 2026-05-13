// integrations/slack/handlers/help.js
export function registerHelpHandler(app) {
  app.message(/\bhelp\b/i, async ({ message, say }) => {
    await say({
      thread_ts: message.ts,
      text: [
        '*Kayoridolfi AI Plugin · comandos disponíveis no Slack*',
        '',
        '• `@kai-ai retro <squad>` — última retrospectiva do squad',
        '• `@kai-ai help` — esta mensagem',
        '',
        'CLI completa: rode `/kai-help` no Claude Code para ver 60+ comandos.',
      ].join('\n'),
    });
  });
}
