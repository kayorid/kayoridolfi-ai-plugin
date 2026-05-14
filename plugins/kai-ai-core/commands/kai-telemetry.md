---
description: Gerencia telemetria opt-in local (status, enable, disable, show)
argument-hint: <status|enable|disable|show|reset>
---

# /kai-telemetry

Telemetria **local-first, opt-in, sem rede**. Conta uso de comandos `/kai-*` e hooks em `.kai/telemetry/usage.json` apenas. Útil para o próprio squad entender quais features pega e quais não pega.

## Uso

```bash
/kai-telemetry status        # mostra estado e opt-in/out
/kai-telemetry enable        # habilita (cria .kai/telemetry/opt-in)
/kai-telemetry disable       # desabilita + apaga histórico
/kai-telemetry show          # contadores agregados
/kai-telemetry reset         # zera contadores mas mantém opt-in
```

## Execução

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/telemetry.sh" "$@"
```

## Garantias

- **Nada sai da máquina.** Não há HTTP, não há cloud, não há envio.
- **Opt-in explícito.** Por padrão desligado. Precisa rodar `/kai-telemetry enable`.
- **Reset destrutivo.** `disable` apaga `.kai/telemetry/`.
- **Auditoria visível.** Arquivos em texto puro JSON.

## O que coleta

- Contagem por comando `/kai-*` executado (apenas nome)
- Contagem por hook acionado
- Timestamp da última execução
- **NÃO coleta:** args, payloads, conteúdo, paths, identidade
