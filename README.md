# compare2ftp
Test if your files in a local directory are in sync with an ftp directory.

This is a tool to help you with web development, i needed to compare 2 dirs one in a local folder and the other on a ftp 
server, i use netbeans a lot but the sync tool for php is useless to me so i decided to do it myself.

The script downloads all files on a ftp server dir to a local directory, then it generates 2 files one for the local dir
and the other for the server's directory each one containing a md5 string for each file.

Then you can use a tool like winmerge (winmerge.org) to compare the 2 files so you can find easily the differences.

I think the script is self explaining.
