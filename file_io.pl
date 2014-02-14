#!/usr/bin/perl

use strict;
use warnings;
use IO::Uncompress::Gunzip qw(gunzip $GunzipError);
use IO::Compress::Gzip qw(gzip $GzipError);
use File::Basename;

my ($in1, $in2, $inf1, $inf2, $out1, $out2, $outf1, $outf2);
my (@temp, @header1, @header2);


$inf1 = shift @ARGV;
$inf2 = shift @ARGV;

#print "$inf1\n";
#print "$inf2\n";

@temp = fileparse($inf1, '.fastq.gz');
$outf1 = $temp[0].'_passed.fastq.gz';
@temp = fileparse($inf2, '.fastq.gz');
$outf2 = $temp[0].'_passed.fastq.gz';

#print "$outf1\n";

#print "$outf2\n";

$in1 = new IO::Uncompress::Gunzip $inf1 or die "IO::Uncompress::Gunzip failed: $GunzipError\n";
$in2 = new IO::Uncompress::Gunzip $inf2 or die "IO::Uncompress::Gunzip failed: $GunzipError\n";
$out1 = new IO::Compress::Gzip $outf1 or die "IO::Uncompress::Gzip failed: $GzipError\n";
$out2 = new IO::Compress::Gzip $outf2 or die "IO::Uncompress::Gzip failed: $GzipError\n";

while(<$in1>){
  chomp($temp[0] = $_);          # First line id an id.
  chomp($temp[1] = <$in1>);      # Second line is a sequence.
  chomp($temp[2] = <$in1>);      # Third line is an id.
  chomp($temp[3] = <$in1>);      # Fourth line is quality.
  #
  chomp($temp[4] = <$in2>);
  chomp($temp[5] = <$in2>);
  chomp($temp[6] = <$in2>);
  chomp($temp[7] = <$in2>);

#  print "$temp[0]\n";
  @header1 = split(/:/,$temp[0]);
  @header2 = split(/:/,$temp[4]);

#  print "$header1[7]\n";

  if($header1[7] eq 'N' && $header2[7] eq 'N'){
    print $out1 "$temp[0]\n";
    print $out1 "$temp[1]\n";
    print $out1 "$temp[2]\n";
    print $out1 "$temp[3]\n";
    #
    print $out2 "$temp[4]\n";
    print $out2 "$temp[5]\n";
    print $out2 "$temp[6]\n";
    print $out2 "$temp[7]\n";
  }
}

close $in1 or die "$in1: $GunzipError\n";
close $in2 or die "$in2: $GunzipError\n";
close $out1 or die "$out1: $GzipError\n";
close $out2 or die "$out2: $GzipError\n";
