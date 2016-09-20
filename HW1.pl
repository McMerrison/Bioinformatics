=begin
Name: Talha Ehtasham
CISC 436 Bioinformatics
Homework 1
=cut

#use strict;
use warnings;

my $length = 500;
my @matrix;



sub rand_seq
{
	my @chars = ("A", "R", "N", "D", "C", "Q", "E", "G", "H", "I", "L", "K", "M", "F", "P", "S", "T", "W", "Y", "V");
	my $seq;
	for ($a = 0; $a < $length; $a++) {
		$seq .= $chars[rand @chars];
	}
	$seq;
}

sub mutate_seq
{
	my $str = $_[0];
	for (my $p = 0; $p < $length; $p++) {
		my $evolve = &randcalc;
		
		my $test = substr($str, $p, 1);
	}
}

sub readpam
{
	my $i = 0;
	my $j = 0;
	my $filename = 'pam1.txt';
	open(my $pam, $filename) or die "ERROR";
	
	while (my $row = <$pam>) {
		my @tokens = split /\s{1,}/, $row;
		foreach my $token(@tokens) {
			
			$matrix[$i][$j] = $token;
			#print "$token ";
			$j++;
		}
		print "\n";
		#print "$j";
		$i++;
		$j = 0;
		
	}
}
sub randcalc
{
	my $random = rand()*10000;
	$random;
}

sub printmatrix
{
	for($row = 0; $row < 20; $row++) {
		for($col = 0; $col < 20; $col++) {
			print "$matrix[$row][$col] ";
		}
		print "\n";
	}
}

my $sequence = &rand_seq;
&readpam;
&printmatrix;
&mutate_seq($sequence);