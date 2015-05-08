# compare2ftp
Test if your files in a local directory are in sync with a ftp directory.

This is a tool made with perl https://www.perl.org/ to help you with web development, i needed to compare 2 dirs one in a local folder and the other on a ftp 
server, i use netbeans a lot but the sync tool for php is useless to me so i decided to do it myself.

The script downloads all files on a ftp server dir to a local directory, then it generates 2 files one for the local dir
and the other for the server's directory each one containing a md5 string for each file.

Then you can use a tool like winmerge (winmerge.org) to compare the 2 files so you can  easily find the differences, i was going to make this part until i found a better tool.

I think the script is self explaining.

you must put this script one level over the folder you want to "compare"
 ex: /mydir1
     /mydir1/c2ftp.pl
     /mydir1/myfoldertocompare

It will generate:
2 files: reg_crc_srv.dat and reg_crc_local.dat you can use winmerge to compare them side to side
1 folder with the files downloaded from the ftp server (this could take a while depending on how many files you have)


