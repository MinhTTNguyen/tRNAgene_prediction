# 9 March 2011
# This program is to make it easy to copy and paste the gene position in the GBrowse

#! C:\Perl\bin -w
use strict;

print "\nInput path leading to predicted result file (after compared):";
my $path=<STDIN>;
chomp($path);

print "\nInput name of the file:";
my $filein=<STDIN>;
chomp($filein);

my $fileout=substr($filein,0,-4);
$fileout=$fileout."_gbrowse.txt";

open(In,"<$path\\$filein") || die "cannot open filein";
open(Out,">$path\\$fileout") || die "cannot open fileout";
while(<In>)
{
	my $line=$_;
	chomp($line);
	#chromosome_1	4947568	4947651	Arg	CCT	4947604	4947615	tRNAscan-SE	SPLITSX	ARAGORN
	if ($line=~/(^chr\_\d*\_\d*)\t(\d*)\t(\d*)/)#clone_An08
	{
		my $chromosome=$1;
		my $gene_begin=$2;
		my $gene_end=$3;
		my $temp=$chromosome."\t".$gene_begin."\t".$gene_end;
		$line=~s/^$temp//;
		my $gene_position="";
		my $strand="";
		if ($gene_begin<$gene_end)
		{
			$gene_position=$chromosome.":".$gene_begin."..".$gene_end;
			$strand="+";
		}else
		{
			$gene_position=$chromosome.":".$gene_end."..".$gene_begin;
			$strand="-";
		}
		$line=$gene_position."\t".$strand.$line;
		print Out "$line\n";
	}else{print "Expression is not as described!\n$line";exit;}
}
close(In);
close(Out);