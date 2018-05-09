# January 10th 2012
# This script is to assemble tRNAfinder predicted results of different chromosomes into 1 file

#! /usr/bin/perl -w
use strict;

my $folder="/home/mnguyen/Research/Aniger_ATCC_13496/tRNAfinder/ATCC13496_chrs_tbl";
my $fileout="/home/mnguyen/Research/Aniger_ATCC_13496/tRNAfinder/ATCC13496_chrs_tbl.out";

open(Out,">$fileout")  || die "Cannot open file $fileout";
print Out "SeqID\tGene_begin\tGene_end\tAA\tAnticodon\tIntron_begin\tIntron_end\tIntron_length\n";

opendir(DIR,"$folder") || die "Cannot open folder $folder";
my @files=readdir(DIR);

foreach my $file (@files)
{
	if (($file eq ".") or ($file eq "..")){next;}
	open(In,"<$folder/$file") || die "Cannot open file $file";
	while (<In>)
	{
		my $line=$_;
		$line=~s/\s*//g;
		if ($line)
		{
			unless ($_=~/^SeqID/){print Out "$_";}
		}
	}
	close(In);
}
closedir(DIR);