# Homebrew Formula for `github.com/runpockets/homebrew-tap` (Formula/pockets.rb).
# Installs both `pockets` and `podman` automatically on macOS (and Linuxbrew)
# with zero Apple Developer code-signing certificates or Gatekeeper prompts.
class Pockets < Formula
  desc "Local-first home for personal self-hosted web apps"
  homepage "https://github.com/runpockets/pockets"
  version "0.1.0"
  license "Apache-2.0"

  depends_on "podman"

  on_macos do
    on_arm do
      url "https://github.com/runpockets/pockets/releases/download/v#{version}/pockets-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "e2f1dce03c197dec075d92db60f91d53cfea51aa8c535f618b1dfe8816116280"
    end
    on_intel do
      url "https://github.com/runpockets/pockets/releases/download/v#{version}/pockets-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "9774120390cc8cc3391cc8ebb387de4c088771f61045e4a11ef4d49ab65a2c09"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/runpockets/pockets/releases/download/v#{version}/pockets-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "223a84473c3e2eadca81394333cc9f3409d558296a98f11cbb709fc953bcf6fa"
    end
    on_intel do
      url "https://github.com/runpockets/pockets/releases/download/v#{version}/pockets-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2ef4217bfb41a38c1f8f9bf36b8aac3106f6c382b0cfa85a4e7598332211bbe5"
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
