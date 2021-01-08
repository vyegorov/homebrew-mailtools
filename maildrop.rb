class Maildrop < Formula
  desc "Mail delivery agent with filtering abilities"
  homepage "https://www.courier-mta.org/maildrop/"
  url "https://downloads.sourceforge.net/project/courier/maildrop/3.0.1/maildrop-3.0.1.tar.bz2"
  sha256 "5d0c3643ebfd45a31335dcabc09d014388476db3da329ab9cd5e5dd2aa484a7e"
  license "GPL-3.0-only"

  depends_on "pkg-config" => :build
  depends_on "libidn"
  depends_on "libcourier-unicode"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-use-dotlock=1",
                          "--enable-use-flock=1",
                          "--enable-maildirquota",
                          "--with-locking-method=fcntl"
    system "make", "install"
  end

  test do
    (testpath/"original").write <<~EOS
      From: test@example.org
      To: core@example.org
      Subject: maildrop test

      A test
    EOS
    (testpath/"testrc").write <<~EOS
      if ( /^From:.*test@example.org/:H )
        to example.org
    EOS
    system "cat", "original", "maildrop", "testrc"
  end
end
