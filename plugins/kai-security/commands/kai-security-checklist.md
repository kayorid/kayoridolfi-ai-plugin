---
description: Aplica checklist específico cripto (chaves, custódia, transações, MFA, antifraude)
argument-hint: [feature-slug]
---

# /kai-security-checklist

Invoque a skill `kai-crypto-advisor` e percorra o checklist específico de fintech / cripto:

- [ ] Gestão de chaves: tier correto, geração, armazenamento, rotação.
- [ ] Multisig adequado ao tier.
- [ ] Validação de payload antes de assinar.
- [ ] Replay protection.
- [ ] Confirmações de blockchain adequadas; tratamento de reorg.
- [ ] Allowlist/blocklist de endereços.
- [ ] Limites operacionais.
- [ ] MFA para ações sensíveis.
- [ ] Logs de eventos de segurança em sink separado.
- [ ] Rate limiting em endpoints sensíveis.

Documente em `SECURITY.md` da feature ou seção do `REVIEW.md`.
