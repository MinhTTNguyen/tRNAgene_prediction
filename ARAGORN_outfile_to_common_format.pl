# June 6th 2012
# Print output file from ARAGORN in tabular format
# SeqID	tRNA#	Gene begin	Gene End	AA	Anticodon	Intron begin	Intron end
# End < Begin if complement
# Use for all genomes, all sequence IDs

#! C:\Perl\bin\perl -w
use strict;

print "\nInput common path:";
my $path=<STDIN>;
chomp($path);

print "\nInput folder containing output files from ARAGORN:";
my $folder_in=<STDIN>;
chomp($folder_in);

print "\nInput folder containing output files from ARAGORN (tabular format):";
my $folder_out=<STDIN>;
chomp($folder_out);

mkdir "$path\\$folder_out";

opendir(DIR,"$path\\$folder_in") || die "Cannot open folder $folder_in"; 
my @files = readdir(DIR);
shift(@files);shift(@files);
closedir(DIR);

foreach my $filein (@files)
{
	my $fileout=substr($filein,0,-4);
	$fileout=$fileout."_column.out";
	
	open(In,"<$path\\$folder_in\\$filein") || die "Cannot open In file";
	open (Out,">$path\\$folder_out\\$fileout") || die "Cannot open Out file";
	
	print Out "SeqID\tGene_begin\tGene_end\tAA\tAnticodon\tIntron_begin\tIntron_end\n";
	
	my $id="";
	my $No="";
	my $gene_begin="";
	my $gene_end="";
	my $aa="";
	my $anticodon="";
	my $intron_begin_tRNA="";
	my $intron_begin="";
	my $intron_end="";
	my $intron_length="";
	my $flag_gi=0;
	my $flag_No=0;
	my $previous_line="";
	my $line="";
	while (<In>)
	{
			$previous_line=$line;
			$line=$_;
			chomp($line);
			if ($line=~/^\d*\s*nucleotides\s*in\s*sequence/)
			{
					
				if ($flag_gi>0)
				{
					print Out "$id\t$gene_begin\t$gene_end\t$aa\t$anticodon\t$intron_begin\t$intron_end\n";
				}else {$flag_gi++;}
				$id=$previous_line; $No="";$gene_begin=0;$gene_end=0;$aa="";$anticodon="";
				$intron_begin_tRNA=0;
				$intron_begin=0;
				$intron_end=0;
				$intron_length=0;
				$flag_No=0;
			}
			elsif ($line=~/^(\d*)\.\s*$/)
			{
				#print "$line";exit;
				if ($flag_No>0)
				{
					print Out "$id\t$gene_begin\t$gene_end\t$aa\t$anticodon\t$intron_begin\t$intron_end\n";
				}else {$flag_No++;}
				$No="";$gene_begin=0;$gene_end=0;$aa="";$anticodon="";
				$intron_begin_tRNA=0;
				$intron_begin=0;
				$intron_end=0;
				$intron_length=0;
				$No=$1;
			}
			elsif ($line=~/^\s*tRNA\-(\w*)\((\w*)\)\s*/){$aa=$1;$anticodon=$2;$anticodon=uc($anticodon);}
			elsif ($line=~/^\s*Sequence\s*c\[(\d*)\,(\d*)\]\s*$/){$gene_begin=$2;$gene_end=$1;}
			elsif ($line=~/^\s*Sequence\s*\[(\d*)\,(\d*)\]\s*$/){$gene_begin=$1;$gene_end=$2;}
			elsif ($line=~/^Intron Length\:\s*(\d*)\s*$/){$intron_length=$1;}
			elsif ($line=~/^Intron Insertion Position\s*\((\d*)\-\d*\)\:/)
			{
				$intron_begin_tRNA=$1;
				if ($gene_begin>$gene_end)
				{
					$intron_begin=$gene_begin-$intron_begin_tRNA;
					$intron_end=$intron_begin-$intron_length+1;
				}
				else 
				{
					$intron_begin=$gene_begin+$intron_begin_tRNA;
					$intron_end=$intron_begin+ $intron_length-1;																																													
				}
			}
	}

	print Out "$id\t$gene_begin\t$gene_end\t$aa\t$anticodon\t$intron_begin\t$intron_end\n";
	close (In);
	close (Out);
}


