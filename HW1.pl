=begin
Name: Talha Ehtasham
CISC 436 Bioinformatics
Homework 1
=cut

$length = 500;

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
	
}

$sequence = &rand_seq;
printf "$sequence";