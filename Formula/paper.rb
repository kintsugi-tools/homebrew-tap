class Paper < Formula
  desc "Local-first AI document search with exact page and line citations. One binary: CLI + MCP server for LLMs. PDF, DOCX and 15+ formats, no cloud, no telemetry."
  homepage "https://kintsugi.tools/paperscope.html"
  version "0.2.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/arrowassassin/paperscope/releases/download/v0.2.8/paperscope-aarch64-apple-darwin.tar.xz"
      sha256 "8955b3e3828d95241446bda4aada64ddfb4b16442af4532f61760c3e90db69db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/arrowassassin/paperscope/releases/download/v0.2.8/paperscope-x86_64-apple-darwin.tar.xz"
      sha256 "9a00afd2af66ab1aa2a9184f610b6f51eee6beef52a95891c5f4cb72fa1f8311"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/arrowassassin/paperscope/releases/download/v0.2.8/paperscope-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5820766e97d1a708ba2bf790952ed1b903cb9a04cfe86feb768d2d7c1b0c6f33"
    end
    if Hardware::CPU.intel?
      url "https://github.com/arrowassassin/paperscope/releases/download/v0.2.8/paperscope-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bd85df68814930e3b8060ab38d3c22f40b08a081c4b85290e53b4f4c3702cc2d"
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
