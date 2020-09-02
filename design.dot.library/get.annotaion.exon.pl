#! perl -w 
####### get annotaion exon ##############
use warnings;
$gtf = $ARGV[0];

open IN, "<", "$gtf";
open OUT, ">", "./design.dot.library/library.results/annotation.exon.gtf";

while (<IN>){
  my @in = split /\s+/, $_;
  if ($in[2] eq "exon"){
    print OUT;
  }
  else {
    next;
  }
}

close IN;
close OUT;
  
