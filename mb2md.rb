class Mb2md < Formula
  desc "Convert Mbox mailboxes to Maildir format."
  homepage "https://batleth.sapienti-sat.org/projects/mb2md/"
  url "http://batleth.sapienti-sat.org/projects/mb2md/mb2md-3.20.pl.gz"
  sha256 "af45a9b5413a9fe49be0092e560485bf17efc50a4eb4a90744e380c4869f732f"
  license :public_domain
  revision 1

  bottle :unneeded

  depends_on "gpatch" => :build

  patch :DATA

  def install
    bin.install "mb2md-3.20.pl" => "mb2md"
  end

  test do
    system "true"
  end
end

__END__
diff --git a/mb2md-3.20.pl b/mb2md-3.20.pl
--- mb2md-3.20.pl	2021-01-09 23:34:55.000000000 +0100
+++ mb2md-3.20-patched.pl	2021-01-09 23:34:35.000000000 +0100
@@ -172,8 +172,8 @@
 #                the corresponding maildir. The extension must be
 #                given without the leading dot ("."). See the example below.
 #
-#  -l WU-file    File containing the list of subscribed folders.  If
-#                migrating from WU-IMAP the list of subscribed folders will
+#  -l UW-file    File containing the list of subscribed folders.  If
+#                migrating from UW-IMAP the list of subscribed folders will
 #                be found in the file called .mailboxlist in the users
 #                home directory.  This will convert all subscribed folders
 #                for a single user:
@@ -402,6 +402,7 @@
 
 # Get uid, username and home dir
 my ($name, $passwd, $uid, $gid, $quota, $comment, $gcos, $homedir, $shell) = getpwuid($<);
+$homedir = $ENV{HOME} if exists $ENV{HOME} and defined($ENV{HOME});
 
 # Get arguments and determine source
 # and target directories.
@@ -411,6 +412,7 @@
 my $dest = undef;
 my $strip_ext = undef;
 my $use_cl = undef;	# defines whether we use the Content-Length: header if present
+my $pwd = `pwd`; chomp($pwd);
 
 # if option "-c" is given, we use the Content-Length: header if present
 # dangerous! may be unreliable, as the whole CL stuff is a bad idea
@@ -443,7 +445,7 @@
 	# it is a subdir of the users $home
 	# if it does start with a "/" then
 	# let's take $mbroot as a absolut path
-	$opts{s} = "$homedir/$opts{s}" if ($opts{s} !~ /^\//); 
+	$opts{s} = "$homedir/$opts{s}" if ($opts{s} !~ m(^[/.]));
 
 	# check if the given source is a mbox file
 	if (-f $opts{s})
@@ -493,13 +495,13 @@
 
 # if the destination is relative to the home dir,
 # check that the home dir exists
-die("Fatal: home dir $homedir doesn't exist.\n") if ($dest !~ /^\// &&  ! -e $homedir);
+die("Fatal: home dir $homedir doesn't exist.\n") if ($dest !~ m(^[/.]) &&  ! -e $homedir);
 
 #
 # form the destination value
 # slap the home dir on the front of the dest if the dest does not begin
 # with a '/'
-$dest = "$homedir/$dest" if ($dest !~ /^\//);
+$dest = "$homedir/$dest" if ($dest !~ m(^[/.]));
 # get rid of trailing /'s
 $dest =~ s/\/$//;
 
@@ -600,7 +602,7 @@
 	return 1 if(-z $mbxfile);
 	sysopen(MBXFILE, "$mbxfile", O_RDONLY) or die "Could not open $mbxfile ! \n";
 	while(<MBXFILE>) {
-		if (/^From/) {
+		if (/^From +\S+ .*\d\d:\d\d/) {
 			close(MBXFILE);
 			return 1;
 		}
@@ -642,6 +644,7 @@
 	
 	# Appending $oldpath => path is only missing $dest
 	$destinationdir = "$temppath.$destinationdir";
+	defined($strip_ext) && ($destinationdir =~ s/\_$strip_ext$//);
 
 	# Converting '/' to '.' in $destinationdir
 	$destinationdir =~s/\/+/\./g;
@@ -677,7 +680,7 @@
 		#
 		# if $strip_extension is defined,
 		# strip it off the $targetfile
-	    	defined($strip_ext) && ($destinationdir =~ s/\.$strip_ext$//);
+#	    	defined($strip_ext) && ($destinationdir =~ s/\_$strip_ext$//);
 		&convert("$mbroot/$oldpath/$dir","$dest/$destinationdir");
 		$mailboxcount++;
 	}
@@ -703,7 +706,7 @@
 # ------------------------
 #
 # It checks that the folder to be converted is in the list of subscribed
-# folders in WU-IMAP
+# folders in UW-IMAP
 #
 sub inlist
 {
@@ -754,6 +757,7 @@
         # Change to the target mailbox directory.
 
         chdir "$maildir" ;
+        $mbox = "$pwd/$mbox" if ($mbox !~ m(^/));
 
          	    # Converts a Mbox to multiple files
                     # in a Maildir.
@@ -1002,7 +1006,7 @@
                             # exchange possible Windows EOL (CRLF) with Unix EOL (LF)
             $_ =~ s/\r\n$/\n/;
 
-            if ( /^From /
+            if ( /^From +\S+ .*\d\d:\d\d/
 		&& $previous_line_was_empty
 		&& (!defined $contentlength) 
 	       )
