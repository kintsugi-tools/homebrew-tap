class Paper < Formula
  desc "Local-first AI document search with exact page and line citations. One binary: CLI + MCP server for LLMs. PDF, DOCX and 15+ formats, no cloud, no telemetry."
  homepage "https://kintsugi.tools/paperscope.html"
  version "0.2.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kintsugi-tools/paperscope/releases/download/v0.2.12/paperscope-aarch64-apple-darwin.tar.xz"
      sha256 "f10677e0aadda7958ca8a1583cd04b119f4845d135bdbdf2916b88d3dacc7d35"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kintsugi-tools/paperscope/releases/download/v0.2.12/paperscope-x86_64-apple-darwin.tar.xz"
      sha256 "9a80357bebef9cff82ebea75afa364c987136b377d5b86fe7e8ea81f9b87144d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kintsugi-tools/paperscope/releases/download/v0.2.12/paperscope-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3f128787be5586232fc8bbaf7cb120d538e6fbe7e8f9e39e2d881150700e4f22"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kintsugi-tools/paperscope/releases/download/v0.2.12/paperscope-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7e8ed2390584bee552d637d16bae3f34dbe6a31b76b290c50b10596fad61768b"
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
