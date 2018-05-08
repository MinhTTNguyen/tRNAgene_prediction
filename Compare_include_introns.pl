# June 16th 2011
# Compare results from 4 tools
# Only idential results (same gene positions, same type, same anticodon and introns) are reported

#! C:\Perl\bin\perl -w 
use strict;

print "\nInput path:";
my $path=<STDIN>;
chomp($path);

print "\nInput the tRNAscanSE file:";
my $filein_tRNAscanSE=<STDIN>;
chomp($filein_tRNAscanSE);

print "\nInput the SPLITSX file:";
my $filein_SPLITSX=<STDIN>;
chomp($filein_SPLITSX);

print "\nInput the ARAGORN file:";
my $filein_ARAGORN=<STDIN>;
chomp($filein_ARAGORN);

print "\nInput the tRNAfinder file:";
my $filein_tRNAfinder=<STDIN>;
chomp($filein_tRNAfinder);

print "\nOutput file:";
my $fileout=<STDIN>;
chomp($fileout);

open (tRNAscan, "<$path\\$filein_tRNAscanSE") || die "Cannot open file tRNAscan";
open (SPLITSX, "<$path\\$filein_SPLITSX") || die "Cannot open file SPLITSX";
open (ARAGORN, "<$path\\$filein_ARAGORN") || die "Cannot open file ARAGORN";
open (tRNAfinder, "<$path\\$filein_tRNAfinder") || die "Cannot open file tRNAfinder";
open (Out,">$path\\$fileout") || die "Cannot open compared file";

my %hash; 

while (<tRNAscan>)
{
	chomp($_);
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
	}
	else {print "Regular expression 1 fails\n$_";exit;}
}
while (<SPLITSX>)
{
	chomp $_;
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
		my $value="SPLITSX";
		
		if ($hash{$key}) {$hash{$key}=$hash{$key}."\t".$value;}
		else {$hash{$key}=$value;}
	}
	else {print "Regular expression 2 fails\n$_";exit;}
}

while (<ARAGORN>)
{
	chomp $_;
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
		#print "$key";exit;
		my $value="ARAGORN";
		
		if ($hash{$key}) {$hash{$key}=$hash{$key}."\t".$value;}
		else {$hash{$key}=$value;}
	}
	else {print "Regular expression 3 fails\n$_";exit;}
}

while (<tRNAfinder>)
{
	chomp $_;
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
		#print "$key";exit;
		my $value="tRNAfinder";
		
		if ($hash{$key}) {$hash{$key}=$hash{$key}."\t".$value;}
		else {$hash{$key}=$value;}
	}
	else {print "Regular expression 4 fails\n$_";exit;}
}

while (my ($k,$v)=each %hash)
{
	print Out "$k\t$v\n";
}
close(tRNAscan);
close(SPLITSX);
close(ARAGORN);
close(tRNAfinder);
close(Out);
