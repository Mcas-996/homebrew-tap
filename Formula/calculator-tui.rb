class CalculatorTui < Formula
  desc "A command-line calculator with symbolic math support"
  homepage "https://github.com/Mcas-996/calculator-cli"
  version "2.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Mcas-996/calculator-cli/releases/download/v2.0.3/calculator-tui-aarch64-apple-darwin.tar.xz"
      sha256 "8a79b1fd88951c56f1731953693604f8e7dc76b8fed371fd61cb86014133e983"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Mcas-996/calculator-cli/releases/download/v2.0.3/calculator-tui-x86_64-apple-darwin.tar.xz"
      sha256 "9407362e605aafdd3068e3b479796a4b2e07238a2dafe8c1c271f9bc84040ae7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Mcas-996/calculator-cli/releases/download/v2.0.3/calculator-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9ce306d207055b6d7b09614da9e40d1ec6b702ef74124bf3cee8bf93cbcfe531"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Mcas-996/calculator-cli/releases/download/v2.0.3/calculator-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1e9372f1eb5ebefa00f66cfe00a793fb5214866e446d62dda672922e8402617b"
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
