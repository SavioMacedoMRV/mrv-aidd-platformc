---
description: "Use when editing extension or preset manifests, commands, templates, package READMEs, or catalog-related files. Covers package boundaries, public IDs, and MRV catalog maintenance rules."
name: "Catalog Packages"
applyTo: ["extensions/**", "presets/**"]
---

# Catalog Package Guidelines

- Treat this repository as a shared platform catalog, not as a consumer repository or business application repository.
- Preserve public package IDs unless there is a clear technical reason and a documented migration plan.
- Keep package README, manifest, catalog references, and actual behavior aligned whenever a package changes.
- Use `extension` for new operational capabilities such as commands, hooks, or integrations that should exist independently of backend or frontend ownership.
- Use `preset` for ownership, language, templates, prompts, and behavior customization of existing capabilities without redefining the platform flow.
- Do not move consumer-specific rules into the shared platform unless they are truly reusable across repositories.
- Preserve relative paths and portability inside packages; avoid assumptions tied to local machine state or undocumented tools.
- For extension and preset documentation, keep the distinction explicit: extensions add capabilities, presets customize how those capabilities are experienced in a specific context.
- When package changes affect the public flow, verify coherence with `README.md`, `docs/guia-instalacao.md`, `docs/guia-contribuicao.md`, and `docs/aidd/README.md`.
