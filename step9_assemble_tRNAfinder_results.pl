# January 10th 2012
# This script is to assemble tRNAfinder predicted results of different chromosomes into 1 file

#! C:\Perl\bin -w
use strict;

print "\nInput path to the folder containing the result files:";
my $path=<STDIN>;
chomp($path);

print "\nInput name of the folder:";
my $folder=<STDIN>;
chomp($folder);

my $fileout="tRNAfinder_".$folder.".out";
open(Out,">$path\\$fileout")  || die "Cannot open file $fileout";
print Out "SeqID\tGene_begin\tGene_end\tAA\tAnticodon\tIntron_begin\tIntron_end\tIntron_length\n";
opendir(DIR,"$path\\$folder") || die "Cannot open folder $folder";
my @files=readdir(DIR);
shift(@files);shift(@files);
foreach my $file (@files)
{
	open(In,"<$path\\$folder\\$file") || die "Cannot open file $file";
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