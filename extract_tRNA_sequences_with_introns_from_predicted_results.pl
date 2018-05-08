# October 28th 2013
# This script is to extract tRNA sequences from tRNA gene prediction results
# Input: tRNA gene prediction results in tabular format
# Output: tRNA sequences (introns were removed)

# Modified to get tRNA gene sequences (without introns) for A. niger NRRL3 and the script could be executed on Unix system
# input format
# chr_3_2	994301	994230	Ala	AGC	0	0	tRNAscan-SE	SPLITSX	tRNAfinder	
# chr_4_2	973278	973146	Ala	TGC	973234	973182	tRNAscan-SE	SPLITSX		

# Modified so that extracted sequences contain introns


#! /usr/perl/bin -w
use strict;


my $path="/home/mnguyen/Research/Aniger_NRRL3_genome_paper/NRRL3_tRNAs/NRRL3";
my $file_genome="NRRL3_genome.fa";
my $filein="NRRL3_tRNA_gene_intron_location.txt"; # contains tRNA gene and intron locations
my $fileout=substr($filein,0,-4);
$fileout=$fileout."with_intron_ID_seq_same_line.txt";

##########################################################################
# create a hash containing genome sequences
my %fasta;
open(Genome, "<$path/$file_genome") || die "Cannot open file $file_genome";
my $chr_id="";
my $chr_seq="";
while (<Genome>)
{
	$_=~s/\s*$//;
	if ($_=~/^\>/)
	{
		if ($chr_id)
		{
			$chr_seq=uc($chr_seq);
			$fasta{$chr_id}=$chr_seq;
			$chr_id="";
			$chr_seq="";
		}
		$chr_id=$_;
		$chr_id=~s/^\>//;
	}else
	{
		$_=~s/\s*//g;
		$chr_seq=$chr_seq.$_;
	}
}
$chr_seq=uc($chr_seq);
$fasta{$chr_id}=$chr_seq;
close(Genome);
##########################################################################



##########################################################################
# read predicted tRNA gene information and print out the tRNA gene sequences
open(In,"<$path/$filein") || die "Cannot open file $filein";
open(Out,">$path/$fileout") || die "Cannot open file $fileout";
while (<In>)
{
	$_=~s/\s*$//;
	if ($_!~/^\#/)#clone_An11	2350512	2350583	Gln	CTG	0	0	tRNAscan-SE	SPLITSX	tRNAfinder
	{
		my @cols=split(/\t/,$_);
		my $id=$cols[0];
		my $begin=$cols[1];
		my $end=$cols[2];
		my $aa=$cols[3];
		my $anti=$cols[4];
		my $intron_begin=$cols[5];
		my $intron_end=$cols[6];
		my $tRNAseq="";
		
		if ($begin>$end)
		{
			my $length=$begin-$end+1;
			my $new_end=$end-1;
			my $temp=$fasta{$id};
			$tRNAseq=substr($temp,$new_end,$length);
			$tRNAseq=&Comp_Rev($tRNAseq);
		}else
		{
				my $length=$end-$begin+1;
				my $temp=$fasta{$id};
				my $new_begin=$begin-1;
				$tRNAseq=substr($temp,$new_begin,$length);
		}
		my $seq_id=">".$aa."_".$anti."_".$id."_".$begin."_".$end."_".$intron_begin."_".$intron_end;
		print Out "$seq_id\t$tRNAseq\n";
	}
}
close(In);
close(Out);
##########################################################################

##########################################################################
sub Comp_Rev
{
	my $seq2="";
	my $seq1=$_[0];
	my $len=length($seq1);
	my %hash=("A"=>"T","T"=>"A","C"=>"G","G"=>"C");
	for (my $i=0;$i<$len;$i++)
	{
		my $sub=substr($seq1,$i,1);
		$sub=uc($sub);
		$seq2=$seq2.$hash{$sub};
	}
	my $seq3=reverse($seq2);
	return($seq3);
}
##########################################################################