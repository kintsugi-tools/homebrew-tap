class Paper < Formula
  desc "Paper: local-first document search with exact page and line citations. CLI + MCP server in one binary."
  homepage "https://github.com/arrowassassin/paperscope"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/arrowassassin/paperscope/releases/download/v0.2.4/paperscope-aarch64-apple-darwin.tar.xz"
      sha256 "d90c4d2d82fdf68f17151c686123fac093a383418e597345016d41ff9ac0fda4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/arrowassassin/paperscope/releases/download/v0.2.4/paperscope-x86_64-apple-darwin.tar.xz"
      sha256 "9f46808eee27059109b480e153ba3f1824b9dde579507959d0577cf8d76d1183"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/arrowassassin/paperscope/releases/download/v0.2.4/paperscope-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0cfdab8d5462382220f8a9367b51f54382cc7b7f8e0785569f49ed7dffe72879"
    end
    if Hardware::CPU.intel?
      url "https://github.com/arrowassassin/paperscope/releases/download/v0.2.4/paperscope-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6d51c6eb091c1bbc3fb67e0b8d0d72e8598d32595c4a66ecd1b622099e1ed49f"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static": {}
  }

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "paper"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "paper"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "paper"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "paper"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
