class Mb2md < Formula
  desc "Convert Mbox mailboxes to Maildir format."
  homepage "https://batleth.sapienti-sat.org/projects/mb2md/"
  url "http://batleth.sapienti-sat.org/projects/mb2md/mb2md-3.20.pl.gz"
  sha256 "af45a9b5413a9fe49be0092e560485bf17efc50a4eb4a90744e380c4869f732f"
  license :public_domain

  bottle :unneeded

  def install
    bin.install "mb2md-3.20.pl" => "mb2md"
  end

  test do
    system "true"
  end
end
