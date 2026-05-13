# kai-security

Rigor de segurança específico para um projeto financeiro. Threat modeling estruturado, compliance regulatório, padrões cripto e hooks bloqueantes para PII e chaves privadas.

## Comandos

| Comando | Propósito |
|---------|-----------|
| `/kai-threat-model` | Threat model STRIDE para a feature corrente |
| `/kai-security-checklist` | Checklist específico cripto (chaves, custódia, transações, MFA) |
| `/kai-compliance-check <regulação>` | Verifica conformidade (`bacen`, `cvm`, `lgpd`, `travel-rule`, `pci`) |
| `/kai-secret-rotate` | Guia rotação de segredos vencidos ou comprometidos |

## Skills

- `kai-threat-modeler` — conduz threat modeling STRIDE estruturado.
- `kai-compliance-advisor` — conhece exigências regulatórias brasileiras de fintech.
- `kai-crypto-advisor` — orienta sobre BIP, gestão de chaves, custódia, multisig.

## Hooks bloqueantes (categoria SEGURANÇA — sempre bloqueiam)

- `pre-tool-pii-scan` — bloqueia escrita de PII brasileira (CPF, CNPJ, RG, dados bancários) em arquivo não-marcado como teste.
- `pre-tool-private-key-scan` — bloqueia escrita de qualquer formato de chave privada.

## Saídas

- `docs/specs/_active/<feature>/THREAT-MODEL.md`
- `docs/specs/_active/<feature>/SECURITY.md`
- `.kai/audit/security-events.log`
