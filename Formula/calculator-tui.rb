class CalculatorTui < Formula
  desc "A command-line calculator with symbolic math support"
  homepage "https://github.com/Mcas-996/calculator-cli"
  version "2.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Mcas-996/calculator-cli/releases/download/v2.1.2/calculator-tui-aarch64-apple-darwin.tar.xz"
      sha256 "21ffe17d531c91a2de153ad3e650a5823e6c38e56331baf313e9dbf3de753354"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Mcas-996/calculator-cli/releases/download/v2.1.2/calculator-tui-x86_64-apple-darwin.tar.xz"
      sha256 "e9846e6753216abaa4573c640ea67287ceea812ce7d6e95e849aeb434765245d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Mcas-996/calculator-cli/releases/download/v2.1.2/calculator-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ce2a8d8349b454c64dd0f243e4e72eaa2610507799146ca78d13c948cb99d3cd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Mcas-996/calculator-cli/releases/download/v2.1.2/calculator-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "80793cffe1ce76117a3d19d86ff2d0b7ac541ecc6f331f8e24867ab376e69aa9"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "calctui" if OS.mac? && Hardware::CPU.arm?
    bin.install "calctui" if OS.mac? && Hardware::CPU.intel?
    bin.install "calctui" if OS.linux? && Hardware::CPU.arm?
    bin.install "calctui" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
