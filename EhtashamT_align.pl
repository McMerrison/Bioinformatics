=begin
Name: Talha Ehtasham
CISC 436 Bioinformatics
Homework 1
=cut

#use strict;
use List::Util 'max';
#use warnings;

#Scoring
$identity = 4;
$transition = -2;
$transversion = -3;
$gap = -8;
$score;
#Flag to print DP matrix
$DPflag = 0;

#Sequence names, contents, and lengths
$seq1name;
$seq1;
$len1;
$seq2name;
$seq2;
$len2;

#Strings for final alignment display
$alignment1;
$alignment2;

@Purines = ("A", "G");
@Pyrimidines = ("T", "C");

#Matrix for holding numbers
@DPmatrix;
#Matrix for holding directional letters (for backtracking)
@DPmatrixL;

=begin
Read sequence text file
Format will be 4 rows:

>name1
sequence1
>name2
sequence2

Set both sequences to scalar
=cut
sub readseq
{
	open(my $f, $filename) or die "Could not open file $filename\n";
	$row = <$f>;
	chomp $row;
	$seq1name = $row;
	$row = <$f>;
	chomp $row;
	$seq1 = $row;
	$row = <$f>;
	chomp $row;
	$seq2name = $row;
	$row = <$f>;
	chomp $row;
	$seq2 = $row;
}

=begin
Print DP matrix
=cut
sub printmatrix
{
	@matrix = @{$_[0]};
	print "Dynamic Programming Matrix: \n";
	for (my $i = 0; $i < $len2-50; $i++) {
		for (my $j = 0; $j < $len1-50; $j++) {
			print "$matrix[$i][$j]   ";
		}
		print "\n";
	}
}
=begin
Construct matrix
Start by filling in first row/first column values as multiples of gap
Next, go through each cell and get top, left, and diagnoal value
For each of the three, modify based on scoring system
Select the highest valueand fill in the cell
=cut
sub construct_matrix
{
	$DPmatrix[$_][0] = $_*$gap for 0..$len2;
	$DPmatrix[0][$_] = $_*$gap for 0..$len1;
	$DPmatrixL[$_][0] = '-' for 0..$len2;
	$DPmatrixL[0][$_] = '-' for 0..$len1;
	for (my $i = 1; $i < $len2; $i++) {
		for (my $j = 1; $j < $len1; $j++) {
		
			#Checks if this cell's row and column letter match, use for diagonal value
			my $match = $seq1m[$j-1] eq $seq2m[$i-1];
			if ($match) {
				$trans = $identity;
			} else {
				#Check if this is a transition or transversion
				if (grep {$seq1m[$j-1] eq $_} @Purines) {
					if (grep {$seq2m[$i-1] eq $_} @Pyrimidines) {
						$trans = $transversion;
					}
					else {
						$trans = $transition;
					}
				}
				elsif (grep {$seq2m[$i-1] eq $_} @Purines) {
					if (grep {$seq1m[$j-1] eq $_} @Pyrimidines) {
						$trans = $transversion;
					}
					else {
						$trans = $transition;
					}
				}
				else {
					$trans = $transition;
				}
			}
			$diag = $DPmatrix[$i-1][$j-1] + $trans;
			#Get the three score values, this is where scoring system is used
			my @scores = (
				$DPmatrix[$i-1][$j] + $gap,  #Top value
				$DPmatrix[$i][$j-1] + $gap,  #Left
				$diag
			);
			
			#Get highest value
			#Set corresponding "letter" designating which cell was selected
			$max = max @scores;
			$DPmatrix[$i][$j] = $max;
			if ($max == $scores[0]) {
				$DPmatrixL[$i][$j] = 't';
			}
			elsif ($max == $scores[1]) {
				$DPmatrixL[$i][$j] = 'l';
			}
			else {
				$DPmatrixL[$i][$j] = 'd';
			}
		}
	}
}

=begin
Trace from last row last column cell
Move towards first row first column cell
Check the direction the cell points to
Move trackers accoridngly until we reach the top left cell
At each move, generate the alignments (this will be backwards, reverse at the end)
=cut
sub track 
{
	#tracker 1 is the row, tracker 2 is the column
	$tracker1 = $len2;
	$tracker2 = $len1;
	while ($tracker1 >= 0 && $tracker2 >= 0) {
		$direction = $DPmatrixL[$tracker1][$tracker2];
		#Go up, add gap to original seq, normal letter to subject seq
		if ($direction eq 't') {
			$score += $DPmatrix[$tracker1][$tracker2];
			$DPmatrixL[$tracker1][$tracker2] = 'o';
			$alignment1 .= '-';
			$alignment2 .= substr($seq2, $tracker1, 1);
			$tracker1--;
		}
		#Go left, add gap to subject seq, normal letter to query seq
		elsif ($direction eq 'l') {
			$score += $DPmatrix[$tracker1][$tracker2];
			$DPmatrixL[$tracker1][$tracker2] = 'o';
			$alignment1 .= substr($seq1, $tracker2, 1);
			$alignment2 .= '-';
			$tracker2--;
		}
		#Go diagonal, add matching letter to both alignments
		else {
			$score += $DPmatrix[$tracker1][$tracker2];
			$DPmatrixL[$tracker1][$tracker2] = 'o';
			$alignment1 .= substr($seq1, $tracker2, 1);
			$alignment2 .= substr($seq2, $tracker1, 1);
			$tracker1--;
			$tracker2--;
		}
	}
	$alignment1 = reverse $alignment1;
	$alignment2 = reverse $alignment2;
}



=begin
MAIN Program
Read the number of arguments
If one, it is only the text filefield
If more, make sure second one is the -o 1 flag
=cut
$numargs = $#ARGV + 1;
#If -o 1 flag is set, filename will be the third argument
if ($ARGV[0] eq "-o") {
	$filename =$ARGV[2];
	$DPflag = 1;
}
#Otherwise, it is the first
else {
	$filename =$ARGV[0];
}
#Print some information
print "$filename\n";
&readseq;
$len1 = length($seq1)+1;
$len2 = length($seq2)+1;
@seq1m = $seq1 =~ /./g;
@seq2m = $seq2 =~ /./g;
print "$seq1name $seq1...length: $len1\n";
print "$seq2name $seq2...length: $len2\n\n";

#Build the matrix
&construct_matrix;

#Backtrack
&track;

#Print matrices if flag is set
if ($DPflag == 1) {
	&printmatrix(\@DPmatrix);
	&printmatrix(\@DPmatrixL);
}

#Show alignment and score
print "Alignment: \n";
print "$alignment1\n";
print "$alignment2\n";
print "Score: \n";
print "$score\n";


