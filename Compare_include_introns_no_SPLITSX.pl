# June 16th 2011
# Compare results from 4 tools
# Only idential results (same gene positions, same type, same anticodon and introns) are reported

#! /usr/bin/perl -w
use strict;

my $filein_tRNAscanSE="/home/mnguyen/Research/Aniger_ATCC_13496/tRNAscanSE/ATCC13496.reconstructed.tRNAscanSE.tbl";
my $filein_ARAGORN="/home/mnguyen/Research/Aniger_ATCC_13496/ARAGORN/Aniger_ATCC_13496_ARAGORN.tbl";
my $filein_tRNAfinder="/home/mnguyen/Research/Aniger_ATCC_13496/tRNAfinder/ATCC13496_chrs_tbl.out";
my $fileout="/home/mnguyen/Research/Aniger_ATCC_13496/ATCC13496_chrs_tRNAscanSE_ARAGORN_tRNAfinder.txt";

open (tRNAscan, "<$filein_tRNAscanSE") || die "Cannot open file tRNAscan";
open (ARAGORN, "<$filein_ARAGORN") || die "Cannot open file ARAGORN";
open (tRNAfinder, "<$filein_tRNAfinder") || die "Cannot open file tRNAfinder";
open (Out,">$fileout") || die "Cannot open compared file";

my %hash; 

while (<tRNAscan>)
{
	chomp($_);
	if ($_=~/^\#/){next;}
	if ($_=~/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
	{
		my $id=$1;
		my $gene_begin=$2;
		my $gene_end=$3;
		my $aa=$4;
		my $anticodon=$5;
		my $intron_begin=$6;
		my $intron_end=$7;
		
		$id=~s/\s*//g;
		$gene_begin=~s/\s*//g;;
		$gene_end=~s/\s*//g;;
		$aa=~s/\s*//g;;
		$anticodon=~s/\s*//g;;
		$intron_begin=~s/\s*//g;
		$intron_end=~s/\s*//g;
		
		my $key=$id."\t".$gene_begin."\t".$gene_end."\t".$aa."\t".$anticodon."\t".$intron_begin."\t".$intron_end;
		my $value="tRNAscan-SE";
		
		$hash{$key}=$value;
	}else {print "line in tRNAscanSE result is not as described\n$_";exit;}
}

while (<ARAGORN>)
{
	chomp $_;
	if ($_=~/^\#/){next;}
	if ($_=~/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/)
	{
		my $id=$1;
		my $gene_begin=$2;
		my $gene_end=$3;
		my $aa=$4;
		my $anticodon=$5;
		my $intron_begin=$6;
		my $intron_end=$7;
		
		$id=~s/\s*//g;
		$gene_begin=~s/\s*//g;;
		$gene_end=~s/\s*//g;;
		$aa=~s/\s*//g;;
		$anticodon=~s/\s*//g;;
		$intron_begin=~s/\s*//g;
		$intron_end=~s/\s*//g;
		
		my $key=$id."\t".$gene_begin."\t".$gene_end."\t".$aa."\t".$anticodon."\t".$intron_begin."\t".$intron_end;
		my $value="ARAGORN";
		
		if ($hash{$key}) {$hash{$key}=$hash{$key}."\t".$value;}
		else {$hash{$key}=$value;}
	}
	else {print "line in ARAGORN result is not as described\n$_";exit;}
}

while (<tRNAfinder>)
{
	chomp $_;
	if ($_=~/^\#/){next;}
	if ($_=~/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t.*/)#SeqID	Gene_begin	Gene_end	AA	Anticodon	Intron_begin	Intron_end	Intron_length
	{
		my $id=$1;
		my $gene_begin=$2;
		my $gene_end=$3;
		my $aa=$4;
		my $anticodon=$5;
		my $intron_begin=$6;
		my $intron_end=$7;
		
		$id=~s/\s*//g;
		$gene_begin=~s/\s*//g;;
		$gene_end=~s/\s*//g;;
		$aa=~s/\s*//g;;
		$anticodon=~s/\s*//g;;
		$intron_begin=~s/\s*//g;
		$intron_end=~s/\s*//g;
		
		my $key=$id."\t".$gene_begin."\t".$gene_end."\t".$aa."\t".$anticodon."\t".$intron_begin."\t".$intron_end;
		my $value="tRNAfinder";
		
		if ($hash{$key}) {$hash{$key}=$hash{$key}."\t".$value;}
		else {$hash{$key}=$value;}
	}
	else {print "line in tRNAfinder result is not as described\n$_";exit;}
}

while (my ($k,$v)=each %hash)
{
	print Out "$k\t$v\n";
}
close(tRNAscan);
close(ARAGORN);
close(tRNAfinder);
close(Out);
