class SnakeGui < Formula
  desc "A Snake game with a macroquad desktop GUI."
  homepage "https://github.com/Mcas-996/rs_snake_game"
  version "4.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Mcas-996/rs_snake_game/releases/download/v4.0.0/snake_gui-aarch64-apple-darwin.tar.xz"
      sha256 "229819f136583b43de57df7519c0916575f867c1525adaafbf3bfcd99cc4332f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Mcas-996/rs_snake_game/releases/download/v4.0.0/snake_gui-x86_64-apple-darwin.tar.xz"
      sha256 "1e04e523b05008abfa4c696a92a12461acf37b07e16db9f59d346eaf99bc00fe"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Mcas-996/rs_snake_game/releases/download/v4.0.0/snake_gui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "893b1d55f94226d578c6a9320f8e60d978009f6c21e57bbc853477130b495709"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Mcas-996/rs_snake_game/releases/download/v4.0.0/snake_gui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8e0c1bd9261c6197d0cab93d46bf630916fa2926f4593c242571a71fc8a57d98"
    end
  end
  license "Apache-2.0"

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
    bin.install "snake_gui" if OS.mac? && Hardware::CPU.arm?
    bin.install "snake_gui" if OS.mac? && Hardware::CPU.intel?
    bin.install "snake_gui" if OS.linux? && Hardware::CPU.arm?
    bin.install "snake_gui" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
