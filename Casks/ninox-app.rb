cask "ninox-app" do
  version "1.0.0"
  sha256 "274189273689490115450e6c0fd21d2a85831e5c15f2a88fe713488f7df023a9"

  url "https://github.com/Made-by-Moonlight/ninox/releases/download/v#{version}/Ninox.app.zip"
  name "Ninox"
  desc "Desktop interface for the Ninox coding-agent orchestrator"
  homepage "https://github.com/Made-by-Moonlight/ninox"

  app "Ninox.app"
end
