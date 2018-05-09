# January 4th 2012
# Create a folder consists of fasta files, each of which contain a sequence
# Input: a fasta file containing multiple sequences

#! /usr/bin/perl -w
use strict;

my $filein="/home/mnguyen/Research/Aniger_ATCC_13496/tRNAfinder/ATCC13496.reconstructed.v2.fasta";
my $folderout="/home/mnguyen/Research/Aniger_ATCC_13496/tRNAfinder/ATCC13496_chrs";
mkdir $folderout;

open(In,"<$filein") || die "Cannot open file $filein";
my $flag=0;
while (<In>)
{
	chomp($_);
	if ($_=~/^\>/)
	{
		my $fileout=$_;
		$fileout=~s/\>//;
		$fileout=~s/\s//g;
		$fileout=$fileout.".fasta";
		
		if ($flag>0){close(Out);}
		
		open(Out,">$folderout/$fileout") || die "Cannot open file $fileout";
		$flag++;
		print Out "$_\n";
		
	}else{print Out "$_\n";}
}
close(In);
close(Out);
