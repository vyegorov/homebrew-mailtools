class LibcourierUnicode < Formula
  desc "Courier Unicode Library — implements several algorithms related to the Unicode Standard."
  homepage "https://www.courier-mta.org/unicode/"
  url "https://downloads.sourceforge.net/project/courier/courier-unicode/2.1.2/courier-unicode-2.1.2.tar.bz2"
  sha256 "9da4cfe5c14c635d815ef3e2b3f5f81887dc5bc873dffb19a64acf5c5f73c7cf"
  license "GPL-3.0-only"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "true"
  end
end
