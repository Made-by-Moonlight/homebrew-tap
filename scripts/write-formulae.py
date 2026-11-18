#!/usr/bin/env python3
"""Generate stable formulae from the release assets' verified checksums."""
import re
import sys
from pathlib import Path

version, linux_sha, mac_sha = sys.argv[1:]
if not re.fullmatch(r"\d+\.\d+\.\d+", version):
    raise SystemExit("invalid release version")
if any(not re.fullmatch(r"[0-9a-f]{64}", sha) for sha in (linux_sha, mac_sha)):
    raise SystemExit("invalid SHA-256")

for ui, title in (("gui", "Desktop"), ("tui", "Terminal")):
    linux_deps = '    depends_on "libxkbcommon"\n    depends_on "wayland"\n' if ui == "gui" else ""
    nx = '\n    bin.install_symlink bin/"ninox-tui" => "nx"' if ui == "tui" else ""
    bins = f'"ninox-{ui}"'
    build_bin = f', "--bin", "ninox-{ui}"'
    formula = f'''class Ninox{ui.title()} < Formula
  desc "{title} interface for the Ninox coding-agent orchestrator"
  homepage "https://github.com/Made-by-Moonlight/ninox"
  version "{version}"
  license "MIT"

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

  def fetch
    return unless build.head?
    system "cargo", "build", "--release", "--locked", "-p", {bins}{build_bin}
  end

  def install
    bin.install(build.head? ? "target/release/ninox-{ui}" : "ninox-{ui}"){nx}
  end

  test do
    assert_match "ninox", shell_output("#{{bin}}/ninox-{ui} --version")
  end
end
'''
    Path(f"Formula/ninox-{ui}.rb").write_text(formula)
