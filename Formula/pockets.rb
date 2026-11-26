# Homebrew Formula for `github.com/runpockets/homebrew-tap` (Formula/pockets.rb).
# Installs both `pockets` and `podman` automatically on macOS (and Linuxbrew)
# with zero Apple Developer code-signing certificates or Gatekeeper prompts.
class Pockets < Formula
  desc "Local-first home for personal self-hosted web apps"
  homepage "https://github.com/runpockets/pockets"
  version "0.3.3"
  license "Apache-2.0"

  depends_on "podman"

  on_macos do
    on_arm do
      url "https://github.com/runpockets/pockets/releases/download/v#{version}/pockets-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "cf0c0314d38d838095a57482b8e3c3b49da75d15270fb13af6580435dd9fc112"
    end
    on_intel do
      url "https://github.com/runpockets/pockets/releases/download/v#{version}/pockets-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "668c4c348bcf89d1ae452030fa4c3227768a770307b8a7f19dfbe33617e8d7c9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/runpockets/pockets/releases/download/v#{version}/pockets-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0a2a313357afb215a3ecbbb97c7abf41162afb16f7aef5e9f0df7a857e9017eb"
    end
    on_intel do
      url "https://github.com/runpockets/pockets/releases/download/v#{version}/pockets-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d94231ef892ed47ad7819fd4875c0aec900ca4622086f66b85c4c1c809376f72"
    end
  end

  def install
    bin.install "pockets"
  end

  service do
    run [opt_bin/"pockets", "serve"]
    keep_alive true
    environment_variables PATH: std_service_path_env
    log_path var/"log/pockets.log"
    error_log_path var/"log/pockets.log"
  end

  def caveats
    <<~EOS
      To keep Pockets running in the background so your saved URL always works:
        brew services start pockets
        pockets open

      After opening once in your browser, bookmark http://pockets.localhost:18786/
      (or use Safari "Add to Dock" / Chrome "Install App").

      To uninstall Pockets later (and optionally remove its data and Podman):
        pockets uninstall
    EOS
  end

  test do
    assert_match "pockets #{version}", shell_output("#{bin}/pockets --version")
  end
end
