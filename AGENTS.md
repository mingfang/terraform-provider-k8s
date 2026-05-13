---
applyTo: '**'
---

## Critical rules — NEVER violate

### Never lose uncommitted changes

- **NEVER** run `git checkout -- <files>`, `git restore`, `git reset --hard`, or any command that overwrites working tree files — **in any repo, not just this one**.
- If you need to inspect the committed version of a file, use `git show HEAD:<path>` or `git diff` — never overwrite uncommitted work.
- Before removing any uncommitted changes, **always ask the user first**.
- If you accidentally lose uncommitted changes, immediately run `git reflog` to find the commit and `git checkout` to restore the state.

### Never run `terraform destroy`

- **NEVER** run `terraform destroy` unless explicitly instructed by the user.
- This is especially dangerous in production environments with running databases and services.

## Lessons learned

- `AGENTS.md` rules apply to **every repo** we work on, not just the one the file lives in. Always check for uncommitted changes in any repo before modifying anything.
- Never assume a file contains only local config — always ask before discarding uncommitted changes, even if they look trivial.
- **GPG signing is mandatory** for provider releases. Never remove or disable `signs:` in `.goreleaser.yml` without explicit user approval. If the GPG key fails, the issue is the key registration — not the signing config itself.
- When a GPG key needs to be published to the Terraform Registry, use the maintainer's existing trusted key (`43DFB6A3D9FE8D69`) if available. Do NOT generate a new random key for signing — that key will never be trusted by the registry.
- Before running `goreleaser release`, always verify that: (1) `GITHUB_TOKEN` is set, (2) `GPG_FINGERPRINT` env var matches a key that exists AND is registered with the registry, (3) the git working tree is clean, (4) the tag is pushed.
