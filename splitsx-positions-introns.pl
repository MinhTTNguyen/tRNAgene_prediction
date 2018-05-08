# June 6th 2012
# This program is to extract information from SPLITSX result file (SPLITSX_Spoth1_assembly_chromosomes) and reporting in tabular format
# SeqID	No_tRNA	Gene_begin	Gene_end	AA	Anticodon	Intron_begin	Intron_end
# Use for all genomes, all types of sequence IDs

#! C:\Perl\bin\perl -w
use strict;

print "\nInput common path:";
my $path=<STDIN>;
chomp($path);

print "\nInput folder containing output files from SPLITSX:";
my $folder_in=<STDIN>;
chomp($folder_in);

print "\nInput folder containing output files from SPLITSX (column format):";
my $folder_out=<STDIN>;
chomp($folder_out);
mkdir "$path\\$folder_out";

opendir(DIR,"$path\\$folder_in") || die "Cannot open folder $folder_in";
my @files=readdir(DIR);
closedir(DIR);
shift(@files);shift(@files);

foreach my $filein (@files)
{
	my $fileout=substr($filein,0,-4);
	$fileout=$fileout."_column.out";

	open(In,"<$path\\$folder_in\\$filein") || die "Cannot open In file";
	open (Out,">$path\\$folder_out\\$fileout") || die "Cannot open Out file";
	print Out "SeqID\tNo_tRNA\tGene_begin\tGene_end\tAA\tAnticodon\tIntron_begin\tIntron_end\tScore\n";

	my $id ="";
	my $flag_id=0;
	my $gene_no=0;
	my $gene_begin=0;
	my $gene_end=0;
	my $type=0;
	my $anticodon=0;
	my $intron_begin=0;
	my $intron_end=0;
	my $score=0;

	while (<In>)
	{
		my $line=$_;
		chomp($line);
		if ($line=~/Genome\s*loci\:/) #chr_1_1.trna1  Genome loci: 411241-411312
		{
			if ($line=~/^(.+)\.trna(\d*)\s*Genome\s*loci\:\s*(\d*)\-(\d*)/)
			{
				if ($flag_id)
				{
					if (($intron_begin>0) && ($intron_end>0))
					{
						if ($gene_begin>$gene_end)
						{
							#my $temp_intron_begin=$intron_begin;
							#$intron_begin = $gene_end + $intron_end - 1;
							#$intron_end = $gene_end + $temp_intron_begin - 1;
							$intron_begin=$gene_begin-$intron_begin+1;
							$intron_end=$gene_begin-$intron_end+1;
							
						}else
						{
							$intron_begin = $gene_begin + $intron_begin - 1;
							$intron_end = $gene_begin + $intron_end -1;
						}
					}
					print Out "$id\t$gene_no\t$gene_begin\t$gene_end\t$type\t$anticodon\t$intron_begin\t$intron_end\t$score\n";
					$id ="";
					$gene_no=0;
					$gene_begin=0;
					$gene_end=0;
					$type=0;
					$anticodon=0;
					$intron_begin=0;
					$intron_end=0;
					$score=0;
				}
				else {$flag_id=1;}
				$id =$1;
				$gene_no=$2;
				$gene_begin=$3;
				$gene_end=$4;
			}
			elsif ($line=~/^(.+)\.trna(\d*)\s*Genome\s*loci\:\s*complement\((\d*)\-(\d*)\)/)
			{
				if ($flag_id)
				{
					if (($intron_begin>0) && ($intron_end>0))
					{
						if ($gene_begin>$gene_end)
						{
							#my $temp_intron_begin=$intron_begin;
							#$intron_begin = $gene_end + $intron_end - 1;
							#$intron_end = $gene_end + $temp_intron_begin - 1;
							$intron_begin=$gene_begin-$intron_begin+1;
							$intron_end=$gene_begin-$intron_end+1;
						}else
						{
							$intron_begin = $gene_begin + $intron_begin - 1;
							$intron_end = $gene_begin + $intron_end -1;
						}
					}
					print Out "$id\t$gene_no\t$gene_begin\t$gene_end\t$type\t$anticodon\t$intron_begin\t$intron_end\t$score\n";
					$id ="";
					$gene_no=0;
					$gene_begin=0;
					$gene_end=0;
					$type=0;
					$anticodon=0;
					$intron_begin=0;
					$intron_end=0;
					$score=0;
				}
				else {$flag_id=1;}
				$id =$1;
				$gene_no=$2;
				$gene_begin=$4;
				$gene_end=$3;
			}
			else {print "Regular expression of gi fails!!\n$line\n";exit;}
		}elsif ($line=~/^Type/)
		{
			if ($line=~/^Type\:\s*(\w*)\s*Anticodon\:\s*(.*)\s*Score\:\s*(\d*\.\d*)/)
			{
				$type=$1;
				$anticodon=$2;
				$score=$3;
			}else {print "Regular expression of Type fails!!\n";exit;}
		}elsif ($line=~/^Seq/)
		{
			if ($line=~/^Seq\:\s*(\w*)/)
			{
				my $seq=$1;
				my $start_position=0;
				my $seq_1=$seq;
				if ($seq_1=~/[atgc]/)
				{
					#print "intron";exit;
					my $first_nu=substr($seq,0,1);
					while ($first_nu=~/[ATGC]/)
					{
						$start_position++;
						$seq=substr($seq,1);
						$first_nu=substr($seq,0,1);
					}
					$intron_begin=$start_position+1;
					while ($first_nu=~/[atgc]/)
					{
						$start_position++;
						$seq=substr($seq,1);
						$first_nu=substr($seq,0,1);
					}
					$intron_end=$start_position;
				}else {$intron_begin=0;$intron_end=0;}
			
			}
			else{print "Regular expression of Seq fails!!\n";exit;}
		}
	}
	if (($intron_begin>0) && ($intron_end>0))
	{
		if ($gene_begin>$gene_end)
		{
			#my $temp_intron_begin=$intron_begin;
			#$intron_begin = $gene_end + $intron_end - 1;
			#$intron_end = $gene_end + $temp_intron_begin - 1;
			$intron_begin=$gene_begin-$intron_begin+1;
			$intron_end=$gene_begin-$intron_end+1;
							
		}else
		{
			$intron_begin=$gene_begin+$intron_begin-1;
			$intron_end=$gene_begin + $intron_end -1;
		}
	}
	print Out "$id\t$gene_no\t$gene_begin\t$gene_end\t$type\t$anticodon\t$intron_begin\t$intron_end\t$score\n";
	close (In);
	close (Out);
}