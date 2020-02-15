class Jormungandr < Formula
  desc "aspiring blockchain node"
  homepage "https://input-output-hk.github.io/jormungandr/"
  url "https://github.com/input-output-hk/jormungandr/archive/v0.8.6.tar.gz"
  sha256 "5477669992ce92e4f938154411ef09796bde6d41e8dbe1478ddd4d05cdc86009"
  head "https://github.com/input-output-hk/jormungandr/", :using => :git

  resource "chain-deps" do
    url "https://github.com/input-output-hk/chain-libs/archive/chain-libs-v0.8.6.tar.gz"
    sha256 "5c44a6812b51f1ea980b0fcb9a9262db9480eb142aaa54316a3200dfc87cad1f"
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
