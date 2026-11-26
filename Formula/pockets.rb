# Homebrew Formula for `github.com/runpockets/homebrew-tap` (Formula/pockets.rb).
# Installs both `pockets` and `podman` automatically on macOS (and Linuxbrew)
# with zero Apple Developer code-signing certificates or Gatekeeper prompts.
class Pockets < Formula
  desc "Local-first home for personal self-hosted web apps"
  homepage "https://github.com/runpockets/pockets"
  version "0.3.1"
  license "Apache-2.0"

  depends_on "podman"

  on_macos do
    on_arm do
      url "https://github.com/runpockets/pockets/releases/download/v#{version}/pockets-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "31a0681972486663d84dc780e1c4a26a9f2027dc53369d357560c982fde66102"
    end
    on_intel do
      url "https://github.com/runpockets/pockets/releases/download/v#{version}/pockets-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "bfe726b4320d93f3651a622741469c9fac41497d274c6b057ddadf1001c6599d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/runpockets/pockets/releases/download/v#{version}/pockets-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "34688111607b6e24fd1197e2d3697e102107ae5558e20c1405d4a06a6dab0729"
    end
    on_intel do
      url "https://github.com/runpockets/pockets/releases/download/v#{version}/pockets-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "549c4f9c932d1b4fc3f4ef9f84a86da4053612c9b0e3d0f8e5545de54f42a370"
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
    EOS
  end

  test do
    assert_match "pockets #{version}", shell_output("#{bin}/pockets --version")
  end
end
