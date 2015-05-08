#!/usr/bin/perl -w
use strict;          
use warnings;
use Net::FTP;
use Net::FTP::Recursive;
use Digest::MD5;
use Cwd;

use Cwd qw(chdir);

#you must put this script one level over the folder you want to "compare"
# ex: /mydir1
#     /mydir1/c2ftp.pl
#     /mydir1/myfoldertocompare
my $host = "127.0.0.1";#ftp server 
my $user = 'user';#username for ftp server
my $password = "pass";#not anonymous
my $dirRoot = cwd();
my $remoteBaseDir = "remotedir";# you can change this directory on ftp example: myweb
my $baseDirSrv = "$remoteBaseDir"."Srv";#Do not change it
my $baseDirLocal = "localfolder";# this folder is your local folder you whant to compare with the remote directory


while (1) {
  print "You must put this script one level over $baseDirSrv y $baseDirLocal \n";
  print "1 Download files in ftp \n";
  print "2 Generate crc on remote files en $baseDirSrv\n";
  print "3 Generate crc on local files\n";
  print "4 Compare folders $baseDirLocal y $baseDirSrv \n";
  print "s Exit\n";
  print "Input options 1-4-s: ";
   my $input = <>;
   chomp $input;
  if($input eq "s")
  {
    last;
  }

  if($input eq "1")
  {
    print "\n";
    print "Downloading...\n";
    obtenerArchivos($host,$user,$password,$remoteBaseDir,$baseDirSrv);
    print "Downloading Complete..\n";
  }
  if($input eq "2")
  {
    print "\n";
    my $arch_reg_crc = "reg_crc_srv.dat"; #crc from files on server
    open (my $fh,'>',$arch_reg_crc) or die "Cannot open $arch_reg_crc";
    recorreDir($baseDirSrv,$fh);
    print "Crc for files complete";
    close $fh;
  }
  if($input eq "3")
  {
    print "\n";
    my $arch_reg_crc = "reg_crc_local.dat"; #crc with files on local folder
    open (my $fh,'>',$arch_reg_crc) or die "Cannot open $arch_reg_crc";
    recorreDir($baseDirLocal,$fh);
    print "Crc for files complete";
    close $fh;
  }
  if ($input eq "4")
  {
    sinImplementar();
  }


}


#Recorre una carpeta en el disco
sub recorreDir{
  my ($ruta) = $_[0];
  my $fh = $_[1];#filehandle
  return if not -d $ruta;
  opendir (my $dh, $ruta) or die;
  while (my $sub = readdir($dh)) {
    next if $sub eq '.' or $sub eq '..';
    if(-f "$ruta/$sub"){ # si es archivo generar crc
      print $fh generarHashArchivoServer("$ruta/$sub");
    }
    #print "$ruta/$sub\n";
    recorreDir("$ruta/$sub",$fh);
  }
  close $dh;
  return;

}

# Obtiene los archivos usando la libreria Recursive
sub obtenerArchivos{

  $host = $_[0];
  $user = $_[1];
  $password = $_[2];
  $remoteBaseDir = $_[3];
  $baseDirSrv = $_[4];
  
  my $ftp = Net::FTP::Recursive->new("$host", Debug => 1); #use Debug=>0 if you dont want to see what is happening or detailed error messages

  $ftp->login($user,"$password");

  if (length($remoteBaseDir)>0) {

  $ftp->cwd("$remoteBaseDir");

  }
  unless(-e $baseDirSrv or mkdir $baseDirSrv) {
    die "No puede crear directorio en disco $baseDirSrv\n";
  }else{
    print "Directorio $baseDirSrv ya existe\n";
  }
  if(-e $baseDirSrv){
    print "Cambiando a ".cwd()."/$baseDirSrv\n";
    chdir cwd()."/$baseDirSrv" or die "Cant chdir to /$baseDirSrv $!";;#se cambia a la carpeta en el disco
  }else{
    print "no se puede acceder a /$baseDirSrv\n";
  }  
 
  
  $ftp->binary();
  $ftp->rget();
  
  print "Listo transfiriendo los archivos\n";
  
  $ftp->quit;

  chdir $dirRoot  or die "Cant chdir to $dirRoot $!";;#se cambia al rut
}

sub generarHashArchivoServer{
    my $rutaArchivo = $_[0];

    my $filename = shift || "$rutaArchivo";
    open (my $fh, '<', $filename) or die "No se puede abrir '$filename': $!";
    binmode($fh);

    my $md5 = Digest::MD5->new;
    while (<$fh>) {
        $md5->add($_);
    }
    close($fh);
    return $md5->b64digest, " $filename\n";

}

sub sinImplementar{
  print "Not implemented use winmerge instead ;) is a better tool\n";
}