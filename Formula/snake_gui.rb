class SnakeGui < Formula
  desc "A Snake game with a macroquad desktop GUI."
  homepage "https://github.com/Mcas-996/rs_snake_game"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Mcas-996/rs_snake_game/releases/download/v0.6.0/snake_gui-aarch64-apple-darwin.tar.xz"
      sha256 "26d5524ab80bce948e5d01e41da7fcb71be53c690c1b12aae692a0658f0c69fd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Mcas-996/rs_snake_game/releases/download/v0.6.0/snake_gui-x86_64-apple-darwin.tar.xz"
      sha256 "970c728f267e839f1aedc2aeacaba4807d9def01346becce9680b49215a6b8e6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Mcas-996/rs_snake_game/releases/download/v0.6.0/snake_gui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fdc3ce939ab5d9b103850b215da8003605f63973f80721c32621364fb81d868f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Mcas-996/rs_snake_game/releases/download/v0.6.0/snake_gui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "22ae5ff55d7df93668523e46233d7d4259eb5842824798b882b88cfc7b6984a4"
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
