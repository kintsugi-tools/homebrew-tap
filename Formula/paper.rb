class Paper < Formula
  desc "Local-first AI document search with exact page and line citations. One binary: CLI + MCP server for LLMs. PDF, DOCX and 15+ formats, no cloud, no telemetry."
  homepage "https://kintsugi.tools/paperscope.html"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kintsugi-tools/paperscope/releases/download/v0.3.1/paperscope-aarch64-apple-darwin.tar.xz"
      sha256 "dbc9c26a5a446a23ad07cb8819117c0a61f7fca4fee2db925c1ac62fcd1bd590"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kintsugi-tools/paperscope/releases/download/v0.3.1/paperscope-x86_64-apple-darwin.tar.xz"
      sha256 "d51699a5569c42a96844ffe0a3e0f67a9fe46700955ae09fba894a5dabfdb0b8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kintsugi-tools/paperscope/releases/download/v0.3.1/paperscope-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "29c346846e728c12007d8f03ceefbe6894dcd91154a96008ac277f24b915298e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kintsugi-tools/paperscope/releases/download/v0.3.1/paperscope-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a890ed1d8e3127c8ace883a2b0de273d4753567afd13e46936c3039f582afc19"
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
