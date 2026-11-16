# Ninox Homebrew tap

Install the development version from the Ninox `v1` branch:

```sh
brew install --HEAD made-by-moonlight/tap/ninox-gui
brew install --HEAD made-by-moonlight/tap/ninox-tui
```

Both formulae build from source and support macOS and Linux. Install either
or both. The GUI formula installs the executable, not a macOS app bundle.
The TUI also provides `nx`. Ninox creates its shared `ninox` shim on first
run. Upgrade with `brew upgrade --fetch-HEAD ninox-gui ninox-tui` (omitting
any formula you did not install), rather than `ninox update`.

See the [Ninox repository](https://github.com/Made-by-Moonlight/ninox) for
documentation and the Rust toolchain version required by the branch.
