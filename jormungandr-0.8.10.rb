class Jormungandr < Formula
  desc "aspiring blockchain node"
  homepage "https://input-output-hk.github.io/jormungandr/"
  url "https://github.com/input-output-hk/jormungandr/archive/v0.8.10.tar.gz"
  sha256 "f4aa8639f325d675ce4c3fec5508f39e22be5c4b3a5a04c05b33f4f7dabcd93e"
  head "https://github.com/input-output-hk/jormungandr/", :using => :git

  resource "chain-deps" do
    url "https://github.com/input-output-hk/chain-libs/archive/chain-libs-v0.8.10.tar.gz"
    sha256 "5b53a6fd965a1cb28404030098f049a55ef5d3da096e316075d27afc50741ca0"
  end

  depends_on "rust" => :build

  def install
    if !build.head?
      (buildpath/"chain-deps").install resource('chain-deps')
    end
    # ENV.deparallelize  # if your formula fails when building in parallel
    system "cargo", "install", "--locked", "--root", prefix, "--path", "jormungandr"
    system "cargo", "install", "--locked", "--root", prefix, "--path", "jcli"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test jormungandr`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "jcli key generate --type ed25519"
    system "jormungandr --version"
  end
end
