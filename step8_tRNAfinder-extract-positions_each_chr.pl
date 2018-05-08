# 6th June 2012
# This program is to extract information from tRNAfinder result file and reporting in tabular format
# SeqID	Gene_begin	Gene_end	AA	Anticodon	Intron_begin	Intron_end
# tRNAfinder reports positions counted from 1
# the tRNAfinder prediction was done for each chr
# this script can be used for all genomes, all sequence IDs

#! C:\Petl\bin\perl -w
use strict;

print "\nInput common path:";
my $path=<STDIN>;
chomp($path);

print "\nInput folder containing output files from tRNAfinder:";
my $folder_in=<STDIN>;
chomp($folder_in);

print "\nInput folder containing output files from tRNAfinder (tabular format):";
my $folder_out=<STDIN>;
chomp($folder_out);

mkdir "$path\\$folder_out";

opendir(DIR,"$path\\$folder_in") ||die "Cannot open folder $folder_in";
my @files=readdir(DIR);
shift(@files);shift(@files);
closedir(DIR);

foreach my $filein (@files)
{
	my $fileout=substr($filein,0,-4);
	$fileout=$fileout."_tabular.out";

	open(In, "<$path\\$folder_in\\$filein") || die "Cannot open file In \n";
	open(Out, ">$path\\$folder_out\\$fileout") || die "Cannot open file Out \n";

	print Out "SeqID\tGene_begin\tGene_end\tAA\tAnticodon\tIntron_begin\tIntron_end\tIntron_length\n";
	while (<In>)
	{
		my $line=$_;
		chomp($line);
		#print "$line gggggggggggggggg\n";
		my $id="";
		my $gene_begin="";
		my $gene_end="";
		my $aa="";
		my $anticodon="";
		my $intron_begin="";
		my $intron_end="";
		my $intron_length="";
		#chromosome_1	join(8094..8132,8199..8258)	Phe gaa
		if ($line=~/^(.+)\s+join\((\d+)\.\.(\d+)\,(\d+)\.\.(\d+)\)\s+([\w\-]*)\s+(\w+)/)
		{
			#print "$line";exit;
			$id=$1;
			$gene_begin=$2;
			$intron_begin=$3+1;
			$intron_end=$4-1;
			$intron_length=$intron_end-$intron_begin+1;
			$gene_end=$5;
			$aa=$6;
			$anticodon=$7;
			$anticodon=uc($anticodon);
			print Out "$id\t$gene_begin\t$gene_end\t$aa\t$anticodon\t$intron_begin\t$intron_end\t$intron_length\n";
		}
		elsif ($line=~/^(.+)\s+complement\(join\((\d+)\.\.(\d+)\,(\d+)\.\.(\d+)\)\)\s+([\w\-]*)\s+(\w+)/)
		{
			# chromosome_1	complement(join(10930433..10930473,10930499..10930538))	Leu aag
			#print "$line";exit;
			$id=$1;
			$gene_end=$2;
			$intron_end=$3+1;
			$intron_begin=$4-1;
			$intron_length=$intron_begin-$intron_end+1;
			$gene_begin=$5;
			$aa=$6;
			$anticodon=$7;
			$anticodon=uc($anticodon);
			print Out "$id\t$gene_begin\t$gene_end\t$aa\t$anticodon\t$intron_begin\t$intron_end\t$intron_length\n";
		}
		elsif ($line=~/^(.+)\s+(\d+)\.\.(\d+)\s+([\w\-]*)\s+(\w+)/) #chromosome_1	664817..664888	Arg acg
		{
			#print "$line";exit;
			$id=$1;
			$gene_begin=$2;
			$intron_begin=0;
			$intron_end=0;
			$intron_length=0;
			$gene_end=$3;
			$aa=$4;
			$anticodon=$5;
			$anticodon=uc($anticodon);
			print Out "$id\t$gene_begin\t$gene_end\t$aa\t$anticodon\t$intron_begin\t$intron_end\t$intron_length\n";
		}
		elsif ($line=~/^(.+)\s+complement\((\d+)\.\.(\d+)\)\s+([\w\-]*)\s+(\w+)/) #chromosome_1	complement(10008202..10008275)	Val aac
		{
			#print "$line";exit;
			$id=$1;
			$gene_end=$2;
			$intron_begin=0;
			$intron_end=0;
			$intron_length=0;
			$gene_begin=$3;
			$aa=$4;
			$anticodon=$5;
			$anticodon=uc($anticodon);
			print Out "$id\t$gene_begin\t$gene_end\t$aa\t$anticodon\t$intron_begin\t$intron_end\t$intron_length\n";
		}
		else
		{
			$line=~s/\s*//g;
			if ($line=~/\W/){print "\nThe sequence contains some unusual nucleotides!\n$line\n";}
		}
	}
	close(In);
	close(Out);
}