#! perl -w

use warnings;
$sam_file = $ARGV[0];
$sample_name= $ARGV[1];
@sam = split /,/, $sam_file;
@sample = split /,/, $sample_name;
$n = @sam;
$number = 0 ;
while ($number<=$n-1){
  open IN, "<", "$sam[$number]";
  open OUT, ">", "./design.dot.library/library.results/$sample[$number].junction_reads.sam";
  $number++;  

  while (<IN>){
    if (/^@/){
      next;
    }
    else{
      my @in = split /\s+/,$_;
      if ($in[5]=~/N/){
        print OUT ;
      }
      else{
        next; 
      }
    }
  }
  close IN;
  close OUT;
}
