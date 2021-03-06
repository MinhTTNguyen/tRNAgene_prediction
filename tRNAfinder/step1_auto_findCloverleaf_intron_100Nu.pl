# January 10th 2012

#! /usr/bin/perl -w
use strict;

my $folderin="/home/mnguyen/Research/Aniger_ATCC_13496/tRNAfinder/ATCC13496_chrs"; # folder containing sequences of all chrs
my $folderout="/home/mnguyen/Research/Aniger_ATCC_13496/tRNAfinder/ATCC13496_chrs_findCloverleaf";
mkdir $folderout;

opendir(DIR,"$folderin") || die "Cannot open folder $folderin";
my @files=readdir(DIR);
closedir(DIR);

foreach my $filein (@files)
{
	if (($filein eq ".") or ($filein eq "..")){next;}
	my $fileout=substr($filein,0,-6);
	$fileout="findCloverleaf_100_".$fileout.".out";
	my $cmd="./findCloverleaf_intron100Nu -f $folderin/$filein > $folderout/$fileout";
	system $cmd;
}
