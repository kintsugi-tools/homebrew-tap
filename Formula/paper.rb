class Paper < Formula
  desc "Local-first AI document search with exact page and line citations. One binary: CLI + MCP server for LLMs. PDF, DOCX and 15+ formats, no cloud, no telemetry."
  homepage "https://kintsugi.tools/paperscope.html"
  version "0.2.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kintsugi-tools/paperscope/releases/download/v0.2.11/paperscope-aarch64-apple-darwin.tar.xz"
      sha256 "624302006a5a7eb85d3338ca9f23c4d97eeed3785b76b4360247a661b7058a4e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kintsugi-tools/paperscope/releases/download/v0.2.11/paperscope-x86_64-apple-darwin.tar.xz"
      sha256 "1e6962f20542c701ba38c4e2a6942927708ae6aced961d0be032151193c2c711"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kintsugi-tools/paperscope/releases/download/v0.2.11/paperscope-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "423920bcb0b2272bdefb9e047dfbdaa786fe057c9ed8d2e7797a8cfcd74c5487"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kintsugi-tools/paperscope/releases/download/v0.2.11/paperscope-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "786b5a3d19177c52e105f8274d36c5d820dcad5c9e44e8d0650d3845838aabc7"
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
