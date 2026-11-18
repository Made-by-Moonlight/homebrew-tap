#!/usr/bin/env python3
"""Generate stable formulae from the release assets' verified checksums."""
import re
import sys
from pathlib import Path

version, linux_sha, mac_sha, icon_sha = sys.argv[1:]
if not re.fullmatch(r"\d+\.\d+\.\d+", version):
    raise SystemExit("invalid release version")
if any(not re.fullmatch(r"[0-9a-f]{64}", sha) for sha in (linux_sha, mac_sha, icon_sha)):
    raise SystemExit("invalid SHA-256")

for ui, title in (("gui", "Desktop"), ("tui", "Terminal")):
    linux_deps = '    depends_on "libxkbcommon"\n    depends_on "wayland"\n' if ui == "gui" else ""
    revision = "  revision 1\n" if ui == "gui" else ""
    nx = '\n    bin.install_symlink bin/"ninox-tui" => "nx"' if ui == "tui" else ""
    bins = f'"ninox-{ui}"'
    build_bin = f', "--bin", "ninox-{ui}"'
    icon_resource = f'''
  resource "icon" do
    url "https://raw.githubusercontent.com/Made-by-Moonlight/ninox/v{version}/crates/ninox-gui/assets/icon-1024.png"
    sha256 "{icon_sha}"
  end
''' if ui == "gui" else ""
    desktop = '''
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
    end''' if ui == "gui" else ""
    caveats = '''
  def caveats
    return unless OS.linux?
    <<~EOS
      If your desktop does not search Homebrew's application directory, add
      Ninox to your launcher with:
        mkdir -p ~/.local/share/applications
        ln -sf #{opt_share}/applications/ninox-gui.desktop ~/.local/share/applications/ninox-gui.desktop
    EOS
  end
''' if ui == "gui" else ""
    formula = f'''class Ninox{ui.title()} < Formula
  desc "{title} interface for the Ninox coding-agent orchestrator"
  homepage "https://github.com/Made-by-Moonlight/ninox"
  version "{version}"
{revision}  license "MIT"

  on_macos do
    depends_on arch: :arm64
    url "https://github.com/Made-by-Moonlight/ninox/releases/download/v#{{version}}/ninox-#{{version}}-aarch64-apple-darwin.tar.gz"
    sha256 "{mac_sha}"
  end

  on_linux do
    depends_on arch: :x86_64
{linux_deps}    url "https://github.com/Made-by-Moonlight/ninox/releases/download/v#{{version}}/ninox-#{{version}}-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "{linux_sha}"
  end

  head do
    url "https://github.com/Made-by-Moonlight/ninox.git", branch: "main"
    depends_on "cmake" => :build
    depends_on "pkgconf" => :build
    depends_on "rust" => :build
  end
  depends_on "tmux"
{icon_resource}

  def fetch
    return unless build.head?
    system "cargo", "build", "--release", "--locked", "-p", {bins}{build_bin}
  end

  def install
    bin.install(build.head? ? "target/release/ninox-{ui}" : "ninox-{ui}"){nx}{desktop}
  end
{caveats}

  test do
    assert_match "ninox", shell_output("#{{bin}}/ninox-{ui} --version")
  end
end
'''
    Path(f"Formula/ninox-{ui}.rb").write_text(formula)
