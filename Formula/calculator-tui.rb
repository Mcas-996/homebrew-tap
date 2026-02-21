class CalculatorTui < Formula
  desc "A command-line calculator with symbolic math support"
  homepage "https://github.com/Mcas-996/calculator-cli"
  version "2.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Mcas-996/calculator-cli/releases/download/v2.2.1/calculator-tui-aarch64-apple-darwin.tar.xz"
      sha256 "fafbaa054e4e536b997b4def51bb513e07e0eea27f3ed2e0006ee99a5e369627"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Mcas-996/calculator-cli/releases/download/v2.2.1/calculator-tui-x86_64-apple-darwin.tar.xz"
      sha256 "36dc58e9f3bc5459e6105efbac2062efbbb56258abcc402a8d031a4fdc0bfa9c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Mcas-996/calculator-cli/releases/download/v2.2.1/calculator-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "81e7b58c5361cf43235772029b8bdd01500431669846cb9ea52b34f6ec79ba66"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Mcas-996/calculator-cli/releases/download/v2.2.1/calculator-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "02ee4db268da2fa307318cabc999f790c8c78cfd5f26b32dee9b39e48b01e06b"
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
