# Security controls and rollout gate

- Admin API MUST authenticate administrators in MVP (organization OIDC recommended). No open admin endpoints.
- Runtime API without JWT MUST be restricted to private ingress, network policies and approved trusted callers. No public route.
- After MVP: JWT bearer tokens in Authorization header, issuer/audience/signature/expiry/scope verification. No app-dependent flag selection.
- Never allow user input to interpolate SQL or raw dynamic expressions.
- Feature flags cannot substitute authentication, authorization, transaction limits, fraud gates or regulatory controls.
- No credentials in git, examples, request bodies, logs or audit events.
- Production startup MUST reject dangerous dev-only auth mode.
- Review CSRF, CORS, security headers, rate limits, request size and batch size.
- Before production: threat model, dependency scan, image scan, secret scan, external pen test if mandated.
