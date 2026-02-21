class CalculatorTui < Formula
  desc "A command-line calculator with symbolic math support"
  homepage "https://github.com/Mcas-996/calculator-cli"
  version "2.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Mcas-996/calculator-cli/releases/download/v2.2.0/calculator-tui-aarch64-apple-darwin.tar.xz"
      sha256 "4a3226517958513d4d710dd3014037cbcba1d0e7d50d7ce273b7d5d72df5ac42"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Mcas-996/calculator-cli/releases/download/v2.2.0/calculator-tui-x86_64-apple-darwin.tar.xz"
      sha256 "3db253c937e439418ffc05f16a92bc061e1480467c70db3908d31bcebb3512f9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Mcas-996/calculator-cli/releases/download/v2.2.0/calculator-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b550e9c36cc7fb1a1867a8dd322eb3d171896bed0a41e60cfa494081a594e846"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Mcas-996/calculator-cli/releases/download/v2.2.0/calculator-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3e0b8b59a38f4d9d16975309897a1eb3ac2ae4601bdba069585bd7ac667483cb"
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
