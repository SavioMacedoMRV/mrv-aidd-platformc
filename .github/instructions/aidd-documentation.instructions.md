---
description: "Use when editing README, docs, AIDD flow documentation, installation guides, contribution guides, extension READMEs, or preset READMEs. Covers MRV AIDD conceptual hierarchy, documentation entrypoints, and AIDD flow truth rules."
name: "AIDD Documentation"
applyTo:
  [
    "README.md",
    "docs/**/*.md",
    "extensions/**/README.md",
    "presets/**/README.md",
  ]
---

# AIDD Documentation Guidelines

- Keep the conceptual hierarchy consistent: AIDD is the broader MRV strategy, BDD + SDD form the operational journey, Spec Kit is one toolkit used in the SDD layer, and MRV AIDD Platform is the layer that operationalizes this strategy.
- Preserve the `humans in the loop` model whenever explaining the flow: people define objective, constraints, quality, ownership, and gate decisions; agents operate the execution loop with guardrails.
- Treat upstream feature text as input, not as final truth. `spec.md` only becomes the functional source of truth after clarification and validation. `plan.md` is the technical source of truth.
- When documenting execution, make it clear that the board must mirror the validated `spec.md`, and that `/tasks` and `/implement` must run for an assumed US with explicit scope.
- Keep `docs/aidd/README.md` as the canonical textual definition of the AIDD flow. Satellite docs should complement it, not redefine it.
- In the root README, prioritize intent-based navigation so readers can quickly choose between understanding the base, configuring a consumer repository, inspecting the catalog, or collaborating on the platform.
- Treat long institutional explanations as supporting material. The top of the root README should optimize for quick discovery of flow, installation, catalog, and contribution paths.
- Prefer pt-BR for team-facing documentation unless an external format requires another language.
- When changing public flow documentation, check consistency across the root README, `docs/aidd/README.md`, diagrams, prompts, templates, and package READMEs.
