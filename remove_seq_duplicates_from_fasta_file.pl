# October 28th 2013
# This script is to remove duplicated sequences from a fasta file
# Input: fasta file
# Output: unique sequences

#! C:\Perl\bin -w
use strict;


print "\nInput path to the file:";
my $path=<STDIN>;
chomp($path);

print "\nInput FASTA file:";
my $filein=<STDIN>;
chomp($filein);

my $fileout=substr($filein,0,-6);# remove .fasta
$fileout=$fileout."_filtered.fasta";

##########################################################################
# create hash: key=seq, value=ids
my %hash_seq_id;
open(In, "<$path\\$filein") || die "Cannot open file $filein";
open(Out, ">$path\\$fileout") || die "Cannot open file $fileout";
my $id="";
my $seq="";
while (<In>)
{
	chomp($_);
	if ($_=~/^\>/)
	{
		if ($id)
		{
			$seq=uc($seq);
			if ($hash_seq_id{$seq}){$hash_seq_id{$seq}=$hash_seq_id{$seq}."|".$id;}
			else{$hash_seq_id{$seq}=$id;}
			$id="";
			$seq="";
		}
		$id=$_;
		$id=~s/^\>//;
	}else
	{
		$_=~s/\s*//g;
		$seq=$seq.$_;
	}
}
$seq=uc($seq);
if ($hash_seq_id{$seq}){$hash_seq_id{$seq}=$hash_seq_id{$seq}."|".$id;}
else{$hash_seq_id{$seq}=$id;}

while (my ($k,$v)=each(%hash_seq_id))
{
	print Out ">$v\n$k\n";
}
close(In);
close(Out);
##########################################################################
