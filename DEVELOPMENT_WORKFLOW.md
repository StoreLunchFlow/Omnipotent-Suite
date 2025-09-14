# CryptoSphere-Suite Development Workflow

## Branch Protection Rules
- Main branch requires PR with 1 approval minimum
- No direct pushes to main
- CI validation required before merge

## Standard Process
1. Create feature branch: `git checkout -b feat/feature-name`
2. Make changes and commit: `git commit -m "feat: description"`
3. Push branch: `git push origin feat/feature-name`
4. Create PR: `gh pr create --base main --head feat/feature-name`
5. Request review from team members
6. Address review comments
7. Wait for CI validation (green checkmark)
8. Merge after approval + CI pass

## Emergency Bypass (Admins only)
1. Temporarily disable protection in repo settings
2. Push hotfix directly
3. Re-enable protection immediately
4. Create retrospective PR for documentation

## Common Commands
- Check PR status: `gh pr status`
- List open PRs: `gh pr list`
- Review PR: `gh pr review <pr-number> --approve`
- Merge PR: `gh pr merge <pr-number> --merge`
