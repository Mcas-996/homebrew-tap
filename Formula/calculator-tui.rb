class CalculatorTui < Formula
  desc "A command-line calculator with symbolic math support"
  homepage "https://github.com/anomalyco/calculator-cli"
  version "2.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/anomalyco/calculator-cli/releases/download/v2.0.1/calculator-tui-aarch64-apple-darwin.tar.xz"
      sha256 "182552ba5ebced1b340cca84096f2d918ab2b92c16c3310f5cfd3beb1521115f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/anomalyco/calculator-cli/releases/download/v2.0.1/calculator-tui-x86_64-apple-darwin.tar.xz"
      sha256 "e77291ed8321b29ad11d8455348357c3fa238cf2622d5c271600a7ea18e8f91a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/anomalyco/calculator-cli/releases/download/v2.0.1/calculator-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4aa0ae903fd0eb0b966ecad510a824a4cd09b2602c9f223eaf36ee4afd3d7ff2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/anomalyco/calculator-cli/releases/download/v2.0.1/calculator-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "246a84e96961b1620429bb0ed6aa605cd7f12d7892881d1d96ed5be2dfcf8e3f"
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
