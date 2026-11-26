class Paper < Formula
  desc "Local-first AI document search with exact page and line citations. One binary: CLI + MCP server for LLMs. PDF, DOCX and 15+ formats, no cloud, no telemetry."
  homepage "https://kintsugi.tools/paperscope.html"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kintsugi-tools/paperscope/releases/download/v0.4.1/paperscope-aarch64-apple-darwin.tar.xz"
      sha256 "9163afa9f484e98190c518b9f42f2fd3b10ef0c7ef66ff1fff340bec1753bb51"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kintsugi-tools/paperscope/releases/download/v0.4.1/paperscope-x86_64-apple-darwin.tar.xz"
      sha256 "503f1f54f4ee8393181a50fc57784a848f88f6858bde2c997fcfaf95602e4027"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kintsugi-tools/paperscope/releases/download/v0.4.1/paperscope-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "eeed88360923f8dda6a00ebc6b74d638f35b6d6175a04fcf067aad421d3df8b6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kintsugi-tools/paperscope/releases/download/v0.4.1/paperscope-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8888a4550240a6d466cabba8e89abd5a862dc0dbb111484e81bf5d5cc4bda604"
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
