cask "ninox-app" do
  version "1.0.1"
  sha256 "9c53a58374f722fab8e1843190e1196aeaf616415b6d016faabc972c67a5943f"

  url "https://github.com/Made-by-Moonlight/ninox/releases/download/v#{version}/Ninox.app.zip"
  name "Ninox"
  desc "Desktop interface for the Ninox coding-agent orchestrator"
  homepage "https://github.com/Made-by-Moonlight/ninox"

  app "Ninox.app"
end
