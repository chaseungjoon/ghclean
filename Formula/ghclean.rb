class Ghclean < Formula
  desc "Command-line tool to automatically manage your GitHub followers and following lists"
  homepage "https://github.com/chaseungjoon/ghclean"
  url "https://github.com/chaseungjoon/ghclean/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "b901820efbb39b32fa56c3049194e4bb4177850cd1a519f8c2a956ba25259bf3"
  license "MIT"

  depends_on "python@3.12"

  def install
    # Install the main script
    bin.install "ghclean"
    
    # Install Python script to libexec
    libexec.install "githubapi.py"
    libexec.install "requirements.txt"
    
    # Update paths in the bash script
    inreplace bin/"ghclean", "$SCRIPT_DIR/githubapi.py", "#{libexec}/githubapi.py"
    inreplace bin/"ghclean", "$SCRIPT_DIR/requirements.txt", "#{libexec}/requirements.txt"
  end

  test do
    # Test that the command shows help
    assert_match "ghclean - manage GitHub follower/following cleanup", shell_output("#{bin}/ghclean -h")
  end
end
