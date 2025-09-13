class Ghclean < Formula
  desc "Command-line tool to automatically manage your GitHub followers and following lists"
  homepage "https://github.com/chaseungjoon/ghclean"
  url "https://github.com/chaseungjoon/ghclean/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "b901820efbb39b32fa56c3049194e4bb4177850cd1a519f8c2a956ba25259bf3"
  license "MIT"

  depends_on "python@3.12"

  resource "requests" do
    url "https://files.pythonhosted.org/packages/source/r/requests/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  def install
    # Install Python dependencies
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources

    # Install the main script and Python module
    bin.install "ghclean"
    libexec.install "githubapi.py"
    
    # Fix the path in the bash script to point to the installed Python script
    inreplace bin/"ghclean", "$SCRIPT_DIR/githubapi.py", "#{libexec}/githubapi.py"
    inreplace bin/"ghclean", "$SCRIPT_DIR/requirements.txt", "#{libexec}/requirements.txt"
    
    # Install requirements.txt for reference
    libexec.install "requirements.txt"
    
    # Wrap the Python script to use our virtualenv
    (bin/"ghclean-python").write_env_script libexec/"githubapi.py", PATH: "#{libexec}/bin:$PATH"
    
    # Update the bash script to use our wrapped Python script
    inreplace bin/"ghclean", "python3 \"#{libexec}/githubapi.py\"", "\"#{bin}/ghclean-python\""
  end

  test do
    # Test that the command shows help
    assert_match "ghclean - manage GitHub follower/following cleanup", shell_output("#{bin}/ghclean -h")
  end
end
