class NinoxGui < Formula
  desc "Desktop interface for the Ninox coding-agent orchestrator"
  homepage "https://github.com/Made-by-Moonlight/ninox"
  head "https://github.com/Made-by-Moonlight/ninox.git", branch: "v1"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "tmux"

  on_linux do
    depends_on "libxkbcommon"
    depends_on "wayland"
  end

  # ort-sys downloads ONNX Runtime during compilation, so build in the
  # network-enabled fetch phase as well as fetching the Cargo dependencies.
  def fetch
    system "cargo", "build", "--release", "--locked", "-p", "ninox-gui"
  end

  def install
    bin.install "target/release/ninox-gui"
  end

  test do
    assert_match "ninox", shell_output("#{bin}/ninox-gui --version")
  end
end
