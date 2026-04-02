# AGENTS.md
Guide for agentic coding assistants working in this repository.

## 1) Repository Overview
- Project: `KOTS2007` (legacy Quake II mod/game DLL, mostly C).
- Main source folder: `game/`.
- Main solution: `kots2007.sln` (Visual Studio 2010 format).
- Legacy solution: `kots2007_vs2005.sln`.
- Main artifact on Windows: `gamex86.dll`.
- Runtime destination in Quake II folder: `kots2007` or `kots2007dev`.

## 2) Build / Lint / Test Commands

### 2.1 Preconditions
- Initialize submodules:
  - `git submodule update --init --recursive`
- Expected sibling dependency dirs referenced by project files:
  - `mysql/`
  - `pthreads/`
  - `curl/`
- Optional but useful env var for post-build copy:
  - `Q2DIR` (Quake II root path)

### 2.2 Build Commands (Windows, preferred)
- Build whole solution, Debug:
  - `msbuild kots2007.sln /p:Configuration=Debug /p:Platform=Win32`
- Build whole solution, Release:
  - `msbuild kots2007.sln /p:Configuration=Release /p:Platform=Win32`
- Build official configs:
  - `msbuild kots2007.sln /p:Configuration=Debug_Official /p:Platform=Win32`
  - `msbuild kots2007.sln /p:Configuration=Release_Official /p:Platform=Win32`

### 2.3 Build Commands (single project / faster iteration)
- Build only the game DLL project:
  - `msbuild game/game.vcxproj /p:Configuration=Debug /p:Platform=Win32`
- Build dependency projects only when needed:
  - `msbuild curl/lib/curllib.vcxproj /p:Configuration=Debug /p:Platform=Win32`
  - `msbuild pthreads/pthread.vcxproj /p:Configuration=Debug /p:Platform=Win32`

### 2.4 Linux Build Notes
- Linux support exists historically, but docs are incomplete.
- `game/.project` and `game/.cproject` indicate Eclipse CDT managed builds.
- If using CDT-managed build output, target is usually `all`.
- Do not assume Linux and Windows outputs are behavior-identical.

### 2.5 Lint / Static Analysis
- No dedicated lint command exists in-repo.
- No `.clang-format` or `.editorconfig` exists in-repo.
- Use compile warnings as the primary static check.
- Current VS project uses warning levels around `/W3` and `/W4` depending on config.
- If adding local static checks, avoid full-repo auto-formatting.

### 2.6 Tests
- There is no automated unit/integration test suite in this repository.
- There is no native single-test runner command.

### 2.7 "Single Test" Equivalent (important)
- Use focused runtime verification for the changed subsystem:
  - Build only `game/game.vcxproj` in Debug.
  - Launch one map and exercise only the modified command/system.
  - Watch console output for regressions and DB/job errors.

### 2.8 Manual Smoke Test Commands
- Dedicated server example:
  - `r1q2ded +game kots2007 +exec server.cfg`
- Local debug run example:
  - `r1q2.exe +set game kots2007dev +set deathmatch 1 +set public 0 +map q2dm1`

## 3) Code Style Guidelines

### 3.1 General Style
- Language is C, not modern C++.
- Prefer small, surgical edits over broad refactors.
- Keep legacy gameplay behavior stable unless explicitly asked to change it.

### 3.2 File Layout / Module Boundaries
- Core engine/game logic uses files like `g_*.c`, `p_*.c`, `m_*.c`.
- KOTS-specific systems use `kots_*.c` and `kots_*.h`.
- DB scripts live in `game/*.sql`; keep C and SQL changes synchronized.

### 3.3 Includes / Imports
- Use `<...>` for system headers and `"..."` for project headers.
- Typical include order:
  - system headers,
  - module header,
  - related project headers.
- Keep include lists minimal; add only what the file truly needs.

### 3.4 Formatting
- Match local file formatting exactly.
- Tabs are widely used for indentation/alignment; do not normalize globally.
- Function braces are commonly on the next line; preserve local convention.
- Existing single-line `if` statements without braces are common; do not churn.

### 3.5 Naming Conventions
- Public KOTS functions generally use `Kots_PascalCase`.
- Some subsystems intentionally use lowercase prefixes (for example `mysql_iterator_*`).
- Macros/constants/enums use upper snake case.
- Header guards are uppercase and filename-derived.

### 3.6 Types and Data Conventions
- Use Quake II types (`edict_t`, `cvar_t`, `qboolean`, `vec3_t`, etc.).
- Use `true`/`false` with `qboolean` where existing code does so.
- Respect fixed-size buffer patterns used throughout the codebase.

### 3.7 Memory Management
- In game-thread gameplay paths, prefer tagged allocation patterns already used:
  - `gi.TagMalloc(..., TAG_LEVEL/TAG_GAME)` and `gi.TagFree(...)`.
- In DB/thread/helper paths, `malloc/free` is common and acceptable.
- Never mix alloc/free families.
- Document ownership implicitly through clear create/free pairing.

### 3.8 String Safety
- Prefer wrappers already used by project code:
  - `Kots_snprintf`
  - `Kots_vsnprintf`
  - `Kots_strncpy`
- Avoid introducing new raw `sprintf`/`strcpy` calls.
- Keep explicit size bounds and null-termination behavior intact.

### 3.9 Error Handling and Logging
- Use guard clauses and early returns for invalid state.
- Use `gi.dprintf` for server/debug logging.
- Use `gi.cprintf`, `gi.centerprintf`, `gi.bprintf` for player-visible messaging.
- Reserve `gi.error(ERR_FATAL, ...)` for unrecoverable errors.
- For async DB jobs, surface failures via result codes and `last_error`.

### 3.10 Concurrency Rules (critical)
- DB thread code has an explicit lock-order rule.
- When both queue locks are needed, lock input first, then output.
- Reversing lock order can deadlock.
- Do not mutate live client/game state from worker threads.
- Do state mutation in main-thread callbacks after job completion.

### 3.11 SQL / DB Integration
- Keep SQL operation names and C job names descriptive and aligned.
- Keep query construction bounded by existing fixed query buffer sizes.
- Preserve character login/save/result-code semantics.

### 3.12 Comments and Docs
- Keep comments concise and local to non-obvious logic.
- Do not mass-edit historical comments unless they are misleading.

## 4) Cursor and Copilot Rules
- Checked `.cursor/rules/`: not present.
- Checked `.cursorrules`: not present.
- Checked `.github/copilot-instructions.md`: not present.
- Therefore, this `AGENTS.md` is the active agent guidance in this repo.

## 5) Recommended Agent Workflow
- Read nearby functions first; mirror established style in that file.
- Implement minimal change set necessary for the request.
- Run at least a targeted build for touched project(s).
- Because no test runner exists, always include manual verification notes.
