class Paper < Formula
  desc "Local-first AI document search with exact page and line citations. One binary: CLI + MCP server for LLMs. PDF, DOCX and 15+ formats, no cloud, no telemetry."
  homepage "https://kintsugi.tools/paperscope.html"
  version "0.2.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/arrowassassin/paperscope/releases/download/v0.2.10/paperscope-aarch64-apple-darwin.tar.xz"
      sha256 "ee437ed7af0537a19effde6844185a54c68881849dbdf57a2e77a5fe98f616ea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/arrowassassin/paperscope/releases/download/v0.2.10/paperscope-x86_64-apple-darwin.tar.xz"
      sha256 "ec2ab40f3b5ed80bc88a024e2d5503b815e0374b877bb1178c360f0254ff4406"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/arrowassassin/paperscope/releases/download/v0.2.10/paperscope-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "133d6db6eb4d37baa9667c03edc806c0c2fb02a5c47927a69005c1e6f92309d2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/arrowassassin/paperscope/releases/download/v0.2.10/paperscope-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "00683a286812008e42429b13643a74eb2ddf65ac1709b2f5d0c8e43df148166d"
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
