class CalculatorTui < Formula
  desc "A command-line calculator with symbolic math support"
  homepage "https://github.com/Mcas-996/calculator-cli"
  version "2.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Mcas-996/calculator-cli/releases/download/v2.0.2/calculator-tui-aarch64-apple-darwin.tar.xz"
      sha256 "9d53f418a2198d8e4e5934475ef16f22090df693fb19b0aadcfe38d665dcf4f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Mcas-996/calculator-cli/releases/download/v2.0.2/calculator-tui-x86_64-apple-darwin.tar.xz"
      sha256 "cec49087517d0469b5ccda8be667c437bef3f48438bdeba6cec20e8cc62b7d15"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Mcas-996/calculator-cli/releases/download/v2.0.2/calculator-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "57e2a51f4c947abd35de5a8ec6404dbec6dc46e2aa3c727f414e5d0d874bd124"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Mcas-996/calculator-cli/releases/download/v2.0.2/calculator-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8cca156812e4a46cf3d7d40398f4040bd22dfec9efc1dc3103232a12b035e911"
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
