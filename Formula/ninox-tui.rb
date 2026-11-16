class NinoxTui < Formula
  desc "Terminal interface for the Ninox coding-agent orchestrator"
  homepage "https://github.com/Made-by-Moonlight/ninox"
  head "https://github.com/Made-by-Moonlight/ninox.git", branch: "main"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "tmux"

  # ort-sys downloads ONNX Runtime during compilation, so build in the
  # network-enabled fetch phase as well as fetching the Cargo dependencies.
  def fetch
    system "cargo", "build", "--release", "--locked", "-p", "ninox-tui", "--bin", "ninox-tui"
  end

  def install
    bin.install "target/release/ninox-tui"
    bin.install_symlink bin/"ninox-tui" => "nx"
  end

  test do
    assert_match "ninox", shell_output("#{bin}/ninox-tui --version")
    assert_match "ninox", shell_output("#{bin}/nx --version")
  end
end
