# January 10th 2012

#! /usr/bin/perl -w
use strict;

my $folderin="/home/mnguyen/Research/Aniger_ATCC_13496/tRNAfinder/ATCC13496_chrs_findCloverleaf"; # folder containing sequences of all chrs
my $folderout="/home/mnguyen/Research/Aniger_ATCC_13496/tRNAfinder/ATCC13496_chrs_checkOverlap";
mkdir $folderout;

opendir(DIR,"$folderin") || die "Cannot open folder $folderin";
my @files=readdir(DIR);
closedir(DIR);

foreach my $filein (@files)
{
	if (($filein eq ".") or ($filein eq "..")){next;}
	my $fileout=substr($filein,0,-4);#.out
	$fileout="checkOverlap_".$fileout.".out";
	my $cmd="./checkOverlap <$folderin/$filein> $folderout/$fileout";
	system $cmd;
}
