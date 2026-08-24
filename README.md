# Mr-Neutr0n Homebrew Tap

```bash
brew install mr-neutr0n/tap/bounty-harness
```

[BountyHarness](https://github.com/Mr-Neutr0n/bounty-harness): bug bounty
workflows as curated skill packages for AI coding agents. 46 skills covering
recon, web vulns, auth/API, CI/CD, GraphQL, identity infra, reporting gates.

## Release flow

Tags on the main repo (`v*`) trigger a workflow that attaches a source tarball
and prints its sha256. Update `Formula/bounty-harness.rb` (url + sha256) per
release. The asset URL is used instead of `archive/refs/tags` because GitHub's
auto-generated archives are not byte-stable over time.
