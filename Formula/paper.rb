class Paper < Formula
  desc "Local-first AI document search with exact page and line citations. One binary: CLI + MCP server for LLMs. PDF, DOCX and 15+ formats, no cloud, no telemetry."
  homepage "https://kintsugi.tools/paperscope.html"
  version "0.2.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/arrowassassin/paperscope/releases/download/v0.2.9/paperscope-aarch64-apple-darwin.tar.xz"
      sha256 "8ae79f20e5c1c7818c71dcaa60cc6459ee5e01cb9ed1fba5873077b23753033d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/arrowassassin/paperscope/releases/download/v0.2.9/paperscope-x86_64-apple-darwin.tar.xz"
      sha256 "6476c08eefe6afa7f0a12a7f2d56d0912daa196f6367f7cc82021328c3271321"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/arrowassassin/paperscope/releases/download/v0.2.9/paperscope-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b2c061fc74a16cb2f2aeeec4de0b3a55066bc743463ae9755c0dc91b8179b692"
    end
    if Hardware::CPU.intel?
      url "https://github.com/arrowassassin/paperscope/releases/download/v0.2.9/paperscope-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "17cf886baee9e88f639a733e412a89ece79a28e7d23c45e479cec7ea92d1ff28"
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
