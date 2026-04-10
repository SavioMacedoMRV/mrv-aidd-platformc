---
description: Configurar o repositorio atual como maestro multi-repo, vinculando repositorios pareados para replicacao automatica de spec e contratos.
tools: [read, edit, execute, vscode]
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Goal

Configure the current repository as the **maestro** in a multi-repo workflow. A maestro is the repository where the PO runs `/speckit.specify` to generate the unified spec, and from which the spec and contracts are automatically replicated to paired target repositories after `/sincronizar-us-devops`.

This command persists a `maestro-config.json` file in `.specify/extensions/mrv-aidd-producao/` that other commands read to activate multi-repo behavior.

## Outline

1. **Detect the installed preset** to determine ownership:
   - Read `.specify/presets.yml` or `.specify/init-options.json` in the current repository root.
   - If a preset with id `mrv-aidd-producao-backend` is installed, the maestro ownership is `backend`.
   - If a preset with id `mrv-aidd-producao-frontend` is installed, the maestro ownership is `frontend`.
   - If no MRV preset is detected, stop and tell the user to install one of `mrv-aidd-producao-backend` or `mrv-aidd-producao-frontend` before configuring maestro mode.
   - If `$ARGUMENTS` contains `--ownership backend` or `--ownership frontend`, use it as an explicit override.

2. **Resolve existing maestro config** (if any):
   - Check if `.specify/extensions/mrv-aidd-producao/maestro-config.json` already exists.
   - If it does, read it, show the current config to the user via `vscode_askQuestions` and ask whether they want to reconfigure or keep the existing setup.
   - If the user chooses to keep, stop with a confirmation message.

3. **Identify the paired repository**:
   - Scan the current VS Code workspace for other root folders:
     - Use `run_in_terminal` to inspect workspace folders or read the `.code-workspace` file if available.
   - If workspace folders other than the current repo are found, present them via `vscode_askQuestions` as selectable options for the paired repository.
   - If no other workspace folder is found, ask the user via `vscode_askQuestions` to provide the absolute path to the paired repository.
   - Accept `$ARGUMENTS` as an explicit path override (e.g., `/configurar-maestro C:\repos\my-back-repo`).

4. **Validate the paired repository**:
   - Confirm the paired path exists and contains a `.specify/` directory.
   - If `.specify/` is not found, stop and tell the user to run `specify init` in the paired repository first.
   - Detect the preset installed in the paired repo by reading its `.specify/presets.yml` or `.specify/init-options.json`.
   - If the paired repo has the same ownership as the maestro, warn the user that both repos have the same ownership and ask for confirmation before proceeding.

5. **Persist the maestro configuration**:
   - Create or overwrite `.specify/extensions/mrv-aidd-producao/maestro-config.json` with:

     ```json
     {
       "role": "maestro",
       "ownership": "<backend|frontend>",
       "targets": [
         {
           "path": "<absolute-path-to-paired-repo>",
           "name": "<folder-name>",
           "ownership": "<backend|frontend>",
           "syncSpec": true,
           "syncContracts": true
         }
       ],
       "configuredAt": "<ISO-8601-timestamp>"
     }
     ```

6. **Add the paired repo to the workspace** (if not already present):
   - If the paired repo is not already part of the VS Code workspace, offer to add it using `run_in_terminal` with the command:

     ```powershell
     code --add <paired-repo-path>
     ```

   - If the user declines, just note it in the output.

7. **Report completion** in pt-BR:
   - Show the maestro config summary: current repo ownership, paired repo path and ownership, sync options.
   - Explain that `/sincronizar-us-devops` will now automatically replicate `spec.md` and `contracts/` to the paired repo after syncing with Azure DevOps.
   - Explain that `/speckit.specify` will now generate user stories for both ownerships (dual-ownership mode) when run from this maestro repo.
   - Suggest next steps: run `/speckit.specify` to generate the unified spec, then `/sincronizar-us-devops` to publish and replicate.

## Behavior Rules

- This command does NOT modify any files in the paired repository. It only reads from it to validate the setup.
- The `maestro-config.json` is persisted ONLY in the current (maestro) repository.
- All questions and confirmations MUST use `vscode_askQuestions`.
- All messages to the user MUST be in pt-BR, preserving technical identifiers and paths as-is.
- If the user runs this command from a repo that is already configured as a target (not maestro), warn them and ask if they want to reconfigure it as maestro instead.
- Multiple targets are supported in the `targets` array for future extensibility, but the current flow configures exactly one paired repo.
- Do not create directories or files in the paired repository.
