class NinoxTui < Formula
  desc "Terminal interface for the Ninox coding-agent orchestrator"
  homepage "https://github.com/Made-by-Moonlight/ninox"
  version "1.0.1"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
    url "https://github.com/Made-by-Moonlight/ninox/releases/download/v#{version}/ninox-#{version}-aarch64-apple-darwin.tar.gz"
    sha256 "b3efb554cd40c3dff21a03f8814dfb16a4701e046932bcf510703fa6af4f39bf"
  end

  on_linux do
    depends_on arch: :x86_64
    url "https://github.com/Made-by-Moonlight/ninox/releases/download/v#{version}/ninox-#{version}-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "df23787aee376e51d3de874a43a87b7ff6eec822ef5b5c46ff97428227bd9430"
  end

  head do
    url "https://github.com/Made-by-Moonlight/ninox.git", branch: "main"
    depends_on "cmake" => :build
    depends_on "pkgconf" => :build
    depends_on "rust" => :build
  end
  depends_on "tmux"


  def fetch
    return unless build.head?
    system "cargo", "build", "--release", "--locked", "-p", "ninox-tui", "--bin", "ninox-tui"
  end

  def install
    bin.install(build.head? ? "target/release/ninox-tui" : "ninox-tui")
    bin.install_symlink bin/"ninox-tui" => "nx"
  end


  test do
    assert_match "ninox", shell_output("#{bin}/ninox-tui --version")
  end
end
