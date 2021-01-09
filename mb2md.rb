class Mb2md < Formula
  desc "Convert Mbox mailboxes to Maildir format."
  homepage "https://batleth.sapienti-sat.org/projects/mb2md/"
  url "http://batleth.sapienti-sat.org/projects/mb2md/mb2md-3.20.pl.gz"
  sha256 "af45a9b5413a9fe49be0092e560485bf17efc50a4eb4a90744e380c4869f732f"
  license :public_domain
  revision 1

  bottle :unneeded

  depends_on "gpatch" => :build

  def install
    sed -e '1,/^$/d' patches/mb2md-01-fix-dash-r-option.patch | patch -p1 mb2md.pl
    sed -e '1,/^$/d' patches/mb2md-02-better-separator-line-detection.patch | patch -p1 src/mb2md-3.20.pl
    sed -e '1,/^$/d' patches/mb2md-03-fix-uw-imap-misspellings.patch | patch -p1 src/mb2md-3.20.pl
    sed -e '1,/^$/d' patches/mb2md-04-use-HOME-to-determine-home-directory.patch | patch -p1 src/mb2md-3.20.pl
    sed -e '1,/^$/d' patches/mb2md-05-Make-source-and-destination-path-expansion-behave-mo.patch | patch -p1 src/mb2md-3.20.pl
    bin.install "mb2md-3.20.pl" => "mb2md"
  end

  test do
    system "true"
  end
end
