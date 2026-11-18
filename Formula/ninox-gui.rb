class NinoxGui < Formula
  desc "Desktop interface for the Ninox coding-agent orchestrator"
  homepage "https://github.com/Made-by-Moonlight/ninox"
  version "1.0.0"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
    url "https://github.com/Made-by-Moonlight/ninox/releases/download/v#{version}/ninox-#{version}-aarch64-apple-darwin.tar.gz"
    sha256 "b7e2e8f98783870de83e3ac29ccc0485d2cf126d9100745635a49828cbbd7511"
  end

  on_linux do
    depends_on arch: :x86_64
    depends_on "libxkbcommon"
    depends_on "wayland"
    url "https://github.com/Made-by-Moonlight/ninox/releases/download/v#{version}/ninox-#{version}-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "7beb36c65a158bfe157198e7346d87ffd473805ac57416bad9fd8acae0a7d93f"
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
    system "cargo", "build", "--release", "--locked", "-p", "ninox-gui", "--bin", "ninox-gui"
  end

  def install
    bin.install(build.head? ? "target/release/ninox-gui" : "ninox-gui")
  end

  test do
    assert_match "ninox", shell_output("#{bin}/ninox-gui --version")
  end
end
