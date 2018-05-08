# January 4th 2012
# Create a folder consists of fasta files, each of which contain a sequence
# Input: a fasta file containing multiple sequences

#! C:\Perl\bin -w
use strict;

print "\nInput path:";
my $path=<STDIN>;
chomp($path);

print "\nInput fasta file:";
my $filein=<STDIN>;
chomp($filein);

print "\nInput folder name:";
my $folder=<STDIN>;
chomp($folder);

mkdir ("$path\\$folder");

open(In,"<$path\\$filein") || die "Cannot open file $filein";
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
		
		open(Out,">$path\\$folder\\$fileout") || die "Cannot open file $fileout";
		$flag++;
		print Out "$_\n";
		
	}
	else{print Out "$_\n";}
}
close(In);
close(Out);
