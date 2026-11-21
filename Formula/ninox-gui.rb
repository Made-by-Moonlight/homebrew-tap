class NinoxGui < Formula
  desc "Desktop interface for the Ninox coding-agent orchestrator"
  homepage "https://github.com/Made-by-Moonlight/ninox"
  version "1.0.1"
  revision 1
  license "MIT"

  on_macos do
    depends_on arch: :arm64
    url "https://github.com/Made-by-Moonlight/ninox/releases/download/v#{version}/ninox-#{version}-aarch64-apple-darwin.tar.gz"
    sha256 "b3efb554cd40c3dff21a03f8814dfb16a4701e046932bcf510703fa6af4f39bf"
  end

  on_linux do
    depends_on arch: :x86_64
    depends_on "libxkbcommon"
    depends_on "wayland"
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

  resource "icon" do
    url "https://raw.githubusercontent.com/Made-by-Moonlight/ninox/v1.0.1/crates/ninox-gui/assets/icon-1024.png"
    sha256 "882f0ccc5e37338ab23677ffddde01f61562eab4b307952b457e32331acf0fb8"
  end


  def fetch
    return unless build.head?
    system "cargo", "build", "--release", "--locked", "-p", "ninox-gui", "--bin", "ninox-gui"
  end

  def install
    bin.install(build.head? ? "target/release/ninox-gui" : "ninox-gui")
    if OS.linux?
      resource("icon").stage do
        (share/"icons/hicolor/1024x1024/apps").install "icon-1024.png" => "ninox.png"
      end
      (buildpath/"ninox-gui.desktop").write <<~EOS
        [Desktop Entry]
        Type=Application
        Name=Ninox
        Comment=Coordinate coding agents with Ninox
        Exec=#{opt_bin}/ninox-gui
        Icon=#{opt_share}/icons/hicolor/1024x1024/apps/ninox.png
        Terminal=false
        Categories=Development;
      EOS
      (share/"applications").install "ninox-gui.desktop"
    end
  end

  def caveats
    return unless OS.linux?
    <<~EOS
      If your desktop does not search Homebrew's application directory, add
      Ninox to your launcher with:
        mkdir -p ~/.local/share/applications
        ln -sf #{opt_share}/applications/ninox-gui.desktop ~/.local/share/applications/ninox-gui.desktop
    EOS
  end


  test do
    assert_match "ninox", shell_output("#{bin}/ninox-gui --version")
  end
end
