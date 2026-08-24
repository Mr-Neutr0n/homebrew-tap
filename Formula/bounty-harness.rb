class BountyHarness < Formula
  desc "Bug bounty workflows as curated skill packages for AI coding agents"
  homepage "https://github.com/Mr-Neutr0n/bounty-harness"
  url "https://github.com/Mr-Neutr0n/bounty-harness/releases/download/v3.1.1/bounty-harness-v3.1.1.tar.gz"
  sha256 "c636a424eebd40818b3afaf76c4de15a2dd2b373464ea25142271138292124dd"
  license "MIT"

  depends_on "python@3.11" => :build
  depends_on "git"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    # Pure-python fallback build of PyYAML (skip optional libyaml ext)
    ENV["PyYAML_WITH_LIBYAML"] = "0"
    libexec.install Dir["*"]
    libexec.install ".claude"   # skills live here; Dir["*"] skips dotdirs

    system "python3.11", "-m", "pip", "install",
           "--no-binary=:all:", "--no-deps", "--ignore-installed",
           "--target", libexec/"vendor", resource("pyyaml").cached_download

    %w[bb-init bb-validate bb-run bb-hunt bb-tools].each do |bin_name|
      (bin/bin_name).write_env_script(libexec / "bin" / bin_name,
                                      PYTHONPATH: libexec / "vendor")
    end
  end

  def caveats
    <<~EOS
      Start an engagement inside any project directory:

        cd your-project && bb-init example.com --program example

      Skills ship with the formula under libexec/.claude; workflow output
      lands under the install root unless OUTDIR is set in context.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bb-run --version")
    assert_match "recon", shell_output("#{bin}/bb-run list")
  end
end
