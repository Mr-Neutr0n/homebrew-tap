class BountyHarness < Formula
  include Language::Python::Virtualenv
  desc "Bug bounty workflows as curated skill packages for AI coding agents"
  homepage "https://github.com/Mr-Neutr0n/bounty-harness"
  url "https://github.com/Mr-Neutr0n/bounty-harness/releases/download/v3.1.1/bounty-harness-v3.1.1.tar.gz"
  sha256 "c636a424eebd40818b3afaf76c4de15a2dd2b373464ea25142271138292124dd"
  license "MIT"
  version "3.1.1"

  depends_on "python@3.11"
  depends_on "git"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    # Install the whole tree INCLUDING .claude (skills live there); brew's
    # Dir["*"] skips dotdirs, so install it explicitly.
    libexec.install Dir["*"]
    libexec.install ".claude"

    # Self-contained runtime: venv provides pyyaml for the workflow scripts.
    venv = virtualenv_create(libexec/"venv", "python@3.11")
    venv.pip_install resource("pyyaml")
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
