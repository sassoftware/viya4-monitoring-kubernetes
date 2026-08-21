# How to Contribute

We'd love to accept your patches and contributions to this project. There are
just a few guidelines you need to follow.

## Developer Certificate of Origin (Sign-off)

In addition to the Contributor Agreement, every commit must be signed off to
certify that you wrote it or otherwise have the right to submit it, per the
[Developer Certificate of Origin](https://developercertificate.org/). Add a
`Signed-off-by` trailer to each commit message, which `git commit -s` does
for you:

```
Signed-off-by: Firstname Lastname <user@domain>
```

Pull requests are checked for sign-off automatically; PRs with unsigned
commits will fail this check and need to be amended (`git commit --amend -s`
or `git rebase --signoff`) before they can be merged.

## Getting Started

1. Fork the repository and clone your fork locally.
2. Create a topic branch off of `main` for your change
   (e.g. `git checkout -b fix/some-issue`).
3. Make your change, following the existing conventions and style of the
   surrounding code.
4. Test your change locally against a Kubernetes cluster where possible.
5. Commit your change with a clear, descriptive message and a `Signed-off-by`
   trailer (see above).
6. Push your branch to your fork and open a pull request against `main` in
   this repository.

If you're planning a larger change, please open an issue first to discuss the approach before investing significant time in an implementation.

## Reporting Issues

Bugs and feature requests are tracked via
[GitHub Issues](https://github.com/sassoftware/viya4-monitoring-kubernetes/issues).
Before filing a new issue, please search existing issues to avoid
duplicates. When filing a bug, include as much detail as possible: steps to
reproduce, expected vs. actual behavior, and relevant environment details
(Kubernetes version, cloud provider, deployment configuration, etc.).

For reporting security vulnerabilities, see [SECURITY.md](SECURITY.md)
instead of filing a public issue.

## Code Reviews

All submissions, including submissions by project members, require review.
We use GitHub pull requests for this purpose. Consult
[GitHub Help](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests)
for more information on using pull requests.

In addition to review by a maintainer, pull requests are automatically
reviewed by [CodeRabbit](https://www.coderabbit.ai/), an AI code review tool
that leaves inline comments and a summary on the PR. CodeRabbit's feedback is
meant to help catch issues early and speed up review; treat its suggestions
as input to consider, not as a blocking requirement. A maintainer will still
review and approve the substance of the change before it's merged.

## Continuous Integration

Pull requests are automatically checked by GitHub Actions, including a
shell-script linting/formatting check (`shellcheck` / `shfmt`) run against
any changed shell scripts. Make sure these checks pass before requesting
review; CI results are posted directly on the PR.

## Updating the Changelog

Most user-facing changes should include an entry in
[CHANGELOG.md](CHANGELOG.md) under the `## Unreleased` section at the top of
the file (add that section if it doesn't exist yet). Entries are grouped by
functional area (e.g. **Overall**, **Logging**, **Metrics**, **Tracing**)
and tagged with the type of change, following the existing style:

* `[FEATURE]`: new functionality
* `[CHANGE]`: a change in existing behavior
* `[BREAKING]`: a change that requires action from existing deployments to
  avoid disruption when upgrading (e.g. a required environment variable
  rename, a removed default). Call these out clearly, including any
  migration steps.
* `[FIX]`: a bug fix
* `[SECURITY]`: a security-related fix or upgrade
* `[UPGRADE]`: a version bump of a bundled component
* `[CHORE]`: internal cleanup with no user-facing behavior change
* `[ANNOUNCEMENT]`: a notable, project-wide change worth calling out

Reference the related GitHub issue number where applicable (e.g.
`(Fixes #882)`). Maintainers move `Unreleased` entries under a new version
heading as part of cutting a release, so you generally don't need to worry
about versioning your own entry.

Purely internal changes with no effect on users of the project (e.g. CI
config, test-only changes) don't need a changelog entry.

### Artifact Inventory

Do not update the [ARTIFACT_INVENTORY.md](ARTIFACT_INVENTORY.md) file. It's regenerated automatically by a GitHub Actions workflow (`.github/workflows/artifact-inventory.yml`) on every push to `main`, which opens its own follow-up pull request with the changes. Leave
this file out of your diff.

## Style and Conventions

Follow the conventions already used in the files you're editing (shell
script style, YAML formatting, documentation structure, etc.) rather than
introducing a new style. Keep changes focused; unrelated formatting or
refactoring changes make PRs harder to review and should be submitted
separately.

## Code of Conduct

Be respectful and constructive in issues, pull requests, and discussions.
We want this to be a welcoming project for contributors of all experience
levels.
