# Post-MVP change: Runtime JWT

Create a separate OpenSpec change, e.g. `/opsx:propose add-runtime-jwt`, after MVP is deployed. Requirements: bearer token in Authorization header, token issuer/audience/signature/exp validation, `flags:read` authorization, reject invalid tokens, retain same POST JSON schema and environment-global values. Address OAuth2 client credentials, key rotation, JWKS caching, negative and outage tests. Do not leak token contents in logs. Admin OIDC authentication is NOT deferred.
