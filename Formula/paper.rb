class Paper < Formula
  desc "Local-first AI document search with exact page and line citations. One binary: CLI + MCP server for LLMs. PDF, DOCX and 15+ formats, no cloud, no telemetry."
  homepage "https://kintsugi.tools/paperscope.html"
  version "0.4.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kintsugi-tools/paperscope/releases/download/v0.4.3/paperscope-aarch64-apple-darwin.tar.xz"
      sha256 "d46d2c715ee497f9bb8bcab768428b9f74c9461317ecdfb819ffac1662bd4523"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kintsugi-tools/paperscope/releases/download/v0.4.3/paperscope-x86_64-apple-darwin.tar.xz"
      sha256 "3d5a5891ac56ccc8a41fd70cf58136d2c6a336d9ccb0245f5b9480bd7d6e1f75"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kintsugi-tools/paperscope/releases/download/v0.4.3/paperscope-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3b73aaa7d3e8ba1cb5973b832d36f87308b8359f449598fa2fc5bf10fdf5daa1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kintsugi-tools/paperscope/releases/download/v0.4.3/paperscope-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ffa72c1d18fe7ef1a1eaddfc5ba5623371065a0fb56b3897668e1ffd163131e9"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
