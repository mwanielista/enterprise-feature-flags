# ADR-001: POST-only business APIs
Status: Accepted for MVP

All `/api/v1/admin/**` and `/api/v1/runtime/**` business operations use HTTP POST with JSON body, including reads. Motivation: uniform enterprise gateway conventions and no keys in URL parameters. Trade-offs: HTTP caching and conventional REST semantics are reduced; idempotent reads must still be side-effect free and retry-safe. TLS is required; POST does not hide bodies from loggers, proxies or authorized parties. Kubernetes probes and telemetry are infrastructure endpoints and retain GET methods.
