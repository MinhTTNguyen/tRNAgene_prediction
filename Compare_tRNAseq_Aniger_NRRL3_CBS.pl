# October 28th 2013
# This script is to compare predicted tRNA sequences from Aniger NRRL3 and CBS trains
# Input: 2 fasta files containing unique tRNA sequences from NRRL3 and CBS
# Output: a fasta file containing tRNA sequences only predicted from CBS and a text file showing which genes were from NRRL3, CBS and both

#!C:\Perl\bin -w
use strict;

print "\nInput path to the files:";
my $path=<STDIN>;
chomp($path);

print "\nInput FASTA file of NRRL3:";
my $file_NRRL3=<STDIN>;
chomp($file_NRRL3);

print "\nInput FASTA file of CBS:";
my $file_CBS=<STDIN>;
chomp($file_CBS);

my $fileout_fasta="tRNA_seq_only_from_CBS.fasta";
my $fileout_compare="Compare_tRNA_NRRL3_CBS.txt";

##########################################################################
# read data from NRRL3
my %hash_seq_id;
open(NRRL3, "<$path\\$file_NRRL3") || die "Cannot open file $file_NRRL3";
my $id="";
my $seq="";
my %hash_ID_strain;
while (<NRRL3>)
{
	chomp($_);
	if ($_=~/^\>/)
	{
		if ($id)
		{
			$seq=uc($seq);
			$hash_seq_id{$seq}=$id;
			$id="";
			$seq="";
		}
		$id=$_;
		$id=~s/^\>//;
		#print "\n$id\n";exit;
		if ($id=~/\,/)
		{
			my @NRRL3_ids=split(',',$id);
			foreach my $NRRL3_id (@NRRL3_ids){$hash_ID_strain{$NRRL3_id}="NRRL3";}
		}else{$hash_ID_strain{$id}="NRRL3";}
	}else
	{
		$_=~s/\s*//g;
		$seq=$seq.$_;
	}
}
$seq=uc($seq);
$hash_seq_id{$seq}=$id;
$id="";
$seq="";
close(NRRL3);
##########################################################################

##########################################################################
# read data from CBS and compare with NRRL3
open(CBS, "<$path\\$file_CBS") || die "Cannot open file $file_CBS";
open(OUT_FASTA, ">$path\\$fileout_fasta") || die "Cannot open file $fileout_fasta";
my $CBS_id="";
my $CBS_seq="";
my $count_CBS=0;
while (<CBS>)
{
	chomp($_);
	if ($_=~/^\>/)
	{
		if ($CBS_id)
		{
			$CBS_seq=uc($CBS_seq);
			my $ids=$hash_seq_id{$CBS_seq};
			if ($ids)
			{
				if ($ids=~/\,/)
				{
					my @arr_ids=split(',',$ids);
					foreach my $e_id (@arr_ids)
					{
						$hash_ID_strain{$e_id}=$hash_ID_strain{$e_id}."\tCBS";
						$count_CBS++;
					}
				}else{$hash_ID_strain{$ids}=$hash_ID_strain{$ids}."\tCBS";$count_CBS++;}
			}else
			{
				if ($CBS_id=~/\,/)
				{
					my @arr_ids=split(',',$CBS_id);
					foreach my $e_id (@arr_ids)
					{
						$hash_ID_strain{$e_id}="CBS";$count_CBS++;
					}
				}else{$hash_ID_strain{$CBS_id}="CBS";$count_CBS++;}
				print OUT_FASTA ">$CBS_id\n$CBS_seq\n";
			}
			$CBS_id="";
			$CBS_seq="";
		}
		$CBS_id=$_;
		$CBS_id=~s/^\>//;
	}else
	{
		$_=~s/\s*//g;
		$CBS_seq=$CBS_seq.$_;
	}
}

$CBS_seq=uc($CBS_seq);
my $ids=$hash_seq_id{$CBS_seq};
if ($ids)
{
	if ($ids=~/\,/)
	{
		my @arr_ids=split(',',$ids);
		foreach my $e_id (@arr_ids)
		{
			$hash_ID_strain{$e_id}=$hash_ID_strain{$e_id}."\tCBS";$count_CBS++;
		}
	}else{$hash_ID_strain{$ids}=$hash_ID_strain{$ids}."\tCBS";$count_CBS++;}
}else
{
	if ($CBS_id=~/\,/)
	{
		my @arr_ids=split(',',$CBS_id);
		foreach my $e_id (@arr_ids)
		{
			$hash_ID_strain{$e_id}="CBS";$count_CBS++;
		}
	}else{$hash_ID_strain{$CBS_id}="CBS";$count_CBS++;}
	print OUT_FASTA ">$CBS_id\n$CBS_seq\n";
}
close(CBS);
close(OUT_FASTA);
print "\n$count_CBS\n";
##########################################################################

##########################################################################
# print text file showing which tRNA genes from which strains
open(OUT_TEXT, ">$path\\$fileout_compare") || die "Cannot open file $fileout_compare";
while (my ($k,$v)=each (%hash_ID_strain))
{
	#print OUT_TEXT "$k\t$v\n";
	if ($k=~/(.+)\_(...)\_(.+)\_(\d+)\_(\d+)\_(\d+)\_(\d+)/)#Pseudo_???_chr_4_2_972475_972348_0_0
	{
		my $aa=$1;
		my $anti=$2;
		my $chr=$3;
		my $begin=$4;
		my $end=$5;
		my $intron_begin=$6;
		my $intron_end=$7;
		print OUT_TEXT "$chr\t$begin\t$end\t$aa\t$anti\t$intron_begin\t$intron_end\t$v\n";
	}else {print "\nError: ID is not as described!\n$k\t$v\n";exit;}
}
close(OUT_TEXT);
##########################################################################