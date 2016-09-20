=begin
Name: Talha Ehtasham
CISC 436 Bioinformatics
Homework 1
=cut

use strict;
use warnings;

my $length = 500;
my $matrix;

$matrix[0][0] = 9867; $matrix[0][1] = 2; $matrix[0][2] = 9; $matrix[0][3] = 10;

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
	for (my $i = 0; $i < $length; $i++) {
		my $evolve = &randcalc;
		
		my $test = substr($str, $i, 1);
	}
}

sub readpam
{
	my $filename = 'pam1.txt';
	open(my $pam, $filename) or die "ERROR";
	
	while (my $row = <$pam>) {
		my $chars = substr($row, 0, 5);
		#chomp $row;
		print "$chars\n";
		sleep(1);
	}
}
sub randcalc
{
	my $random = rand()*10000;
	$random;
}

my $sequence = &rand_seq;
&readpam;
&mutate_seq($sequence);