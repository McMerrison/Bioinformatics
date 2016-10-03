=begin
Name: Talha Ehtasham
CISC 436 Bioinformatics
Homework 1
=cut

#use strict;
use warnings;

my $filename = "hw1_sequence.txt";

my $startcodon = "ATG";
my @stopcodons = ("TAA", "TAG", "TGA");

#Used to find and store three longest ORFs
my @ORFs = ("", "", "");
my @ORFlengths = (0, 0, 0);
my @ORFstartpos = (0, 0, 0);


=begin
Read sequence text file
Store description and DNA sequence
=cut
sub readseq
{
	open(my $f, $filename) or die "Could not open file $filename\n";
	while (my $line = <$f>) {
		$line =~ s/\R//g;
		$Sequence .= $line;
	}
}

=begin
Search for ORFs, store in global variables
If a longer one is found, replace existing
Continue until end of sequence
=cut
sub searchORFs
{
	#Index in overall sequence
	$i = 0;
	#Index counter after start codon is found
	$n = 0;
	#Temp length tracker for each protien sequence
	$lenseq = 0;
	#Scan sequence
	while ($i < $len-3) {
		#If start codon is found
		if (substr($Sequence, $i, 3) eq $startcodon) {
			$n = $i+3;
			#Scan sub-sequence
			while ($n < $len-3) {
				#If one of the stop codons is found
				if (grep {substr($Sequence, $n, 3) eq $_} @stopcodons) {
					#Length of this sequence will be difference between n and i
					$lenseq = $n - $i + 3;
					#Check this length against each length stored in array to find if there is a smaller length
					#Insert/replace into correpsonding index of ORF array, update length
					if ($lenseq > $ORFlengths[0]) {
						$ORFs[0] = substr($Sequence, $i, $lenseq);
						$ORFlengths[0] = $lenseq;
						$ORFstartpos[0] = $i;
					} elsif ($lenseq > $ORFlengths[1]) {
						$ORFs[1] = substr($Sequence, $i, $lenseq);
						$ORFlengths[1] = $lenseq;
						$ORFstartpos[1] = $i;
					} elsif ($lenseq > $ORFlengths[2]) {
						$ORFs[2] = substr($Sequence, $i, $lenseq);
						$ORFlengths[2] = $lenseq;
						$ORFstartpos[2] = $i;
					} else {
						#All lengths are greater, do nothing
					}
					last;
				}
				$n++;
			}
		}
		$i++;
	}
}

=begin
MAIN Program
Read input file

=cut

&readseq;
$len = length $Sequence;
#print "$Sequence\n Total Length: $len\n\n";
&searchORFs;
print "Longest ORFs:\n";
print "Starting Position: $ORFstartpos[0]\n$ORFs[0]\n\n";
print "Starting Position: $ORFstartpos[1]\n$ORFs[1]\n\n";
print "Starting Position: $ORFstartpos[2]\n$ORFs[2]\n";