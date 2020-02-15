class Jormungandr < Formula
  desc "aspiring blockchain node"
  homepage "https://input-output-hk.github.io/jormungandr/"
  url "https://github.com/input-output-hk/jormungandr/archive/v0.8.7.tar.gz"
  sha256 "77806c380562e0f838d7618b839fba47482068b885ad5a1e3f3b0de37a935943"
  head "https://github.com/input-output-hk/jormungandr/", :using => :git

  resource "chain-deps" do
    url "https://github.com/input-output-hk/chain-libs/archive/chain-libs-v0.8.7.tar.gz"
    sha256 "35bfd1cd41760fbba9006a4650aedc7f4b95c385f4a8a14d53bd534bc61624c1"
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
