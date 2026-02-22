class SnakeGui < Formula
  desc "A Snake game with a macroquad desktop GUI."
  homepage "https://github.com/Mcas-996/rs_snake_game"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Mcas-996/rs_snake_game/releases/download/v0.7.0/snake_gui-aarch64-apple-darwin.tar.xz"
      sha256 "2dabaf6e43383809ae34446cfcc3199abfb71e59c56fcc5819222afeb9c24ca6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Mcas-996/rs_snake_game/releases/download/v0.7.0/snake_gui-x86_64-apple-darwin.tar.xz"
      sha256 "e2fc3ede6697d8bbb0a0dd4de7dbccd5dd7b489db25fb6a7acad601ad96ae8fa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Mcas-996/rs_snake_game/releases/download/v0.7.0/snake_gui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0f45575ccab5b5afb565fed6fc60cace55212a7244229ffba55df42a46482abe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Mcas-996/rs_snake_game/releases/download/v0.7.0/snake_gui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "90d527d484b2a08dcb53978a8c4a7e9d5f0806d14f61bd142ac28c1672f71842"
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
