class BountyHarness < Formula
  desc "Bug bounty workflows as curated skill packages for AI coding agents"
  homepage "https://github.com/Mr-Neutr0n/bounty-harness"
  url "https://github.com/Mr-Neutr0n/bounty-harness/releases/download/v3.1.0/bounty-harness-v3.1.0.tar.gz"
  sha256 "1d1a66c3eeba0a3e5a73011134ce22804fa97d5ab9f28feeb415347cf1a70c77"
  license "MIT"
  version "3.1.0"

  depends_on "python@3.11" => [:build, :test]
  depends_on "git"

  def install
    # Install the whole tree; .claude/skills must ship alongside bin/ because
    # the harness anchors execution at its own root.
    libexec.install Dir["*"]
    # Plain symlinks: the binaries resolve their own repo root through
    # BASH_SOURCE + readlink, so they work from any cwd once linked.
    %w[bb-init bb-validate bb-run bb-hunt bb-tools].each do |bin_name|
      bin.install_symlink(libexec / "bin" / bin_name)
    end
  end

  def caveats
    <<~EOS
      Run bb-init inside a project directory to create engagement context:

        cd your-project && bb-init example.com --program example

      Workflows execute against skills shipped with the formula and write
      output under the repo root by default. Set OUTDIR in context for
      per-project evidence directories.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bb-run --version")
    assert_match "recon", shell_output("#{bin}/bb-run list")
  end
end
