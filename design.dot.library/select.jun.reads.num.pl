#! perl -w 
use warnings;

open IN, "<","./design.dot.library/library.results/modifi.sort.defined.jun.information.bed";
open OUT, ">", "./design.dot.library/library.results/select.modifi.sort.defined.jun.information.bed";


$reads_number=$ARGV[0];
while (<IN>){
  my @in = split /\s+/, $_;
  if ($in[5]>=$reads_number){
    print OUT "$_";
  }
  else{
    next;
  }
}

close IN;
close OUT;   
