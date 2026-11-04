class Ghclean < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to automatically manage your GitHub followers and following lists"
  homepage "https://github.com/chaseungjoon/ghclean"
  url "https://github.com/chaseungjoon/ghclean/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "651069d4dc02c40ebeb69a37446a76b4b6f18c689dd7b8a2eaddb001b20a6c11"
  license "MIT"

  depends_on "python@3.12"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/a3/c2/24167ea9858356b47a87a50d39908bfdb72ceeefe0041586e704e5376b3a/certifi-2026.7.22.tar.gz"
    sha256 "741e2c3b351ddf169a738da9f2c048608ff7f2c5cc02f1ebc6b118bb090d5d55"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    # Install Python dependencies into a private virtualenv
    venv = virtualenv_create(libexec/"venv", "python3.12")
    venv.pip_install resources

    # Install the main script
    bin.install "ghclean"

    # Install Python script to libexec
    libexec.install "githubapi.py"
    libexec.install "requirements.txt"

    # Update paths in the bash script
    inreplace bin/"ghclean", "$SCRIPT_DIR/githubapi.py", "#{libexec}/githubapi.py"
    inreplace bin/"ghclean", "$SCRIPT_DIR/requirements.txt", "#{libexec}/requirements.txt"
    inreplace bin/"ghclean", '"${GHCLEAN_PYTHON:-python3}"', "\"#{libexec}/venv/bin/python\""
  end

  test do
    # Test that the command shows help
    assert_match "ghclean - manage GitHub follower/following cleanup", shell_output("#{bin}/ghclean -h")
    system libexec/"venv/bin/python", "-c", "import requests"
  end
end
