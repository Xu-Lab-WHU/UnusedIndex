#! perl -w
open IN,"<", "./design.dot.library/library.results/ref.add.nov.CountFE.dot.line.bed";
open EX,">", "./design.dot.library/library.results/ref.add.nov.CountFE.dot.line.exon.bed";
open INT,">", "./design.dot.library/library.results/ref.add.nov.CountFE.dot.line.intron.bed";

while(<IN>){
  my @in = split /\s+/, $_;
  my @dot = split /:/,$in[3];
  if ($dot[2] eq 1){
    $sta=$dot[1]+1;
    print EX "$in[0]\t$in[1]\t$dot[1]\t$in[3]\t$in[4]\t$in[5]\n";
    print INT "$in[0]\t$sta\t$in[2]\t$in[3]\t$in[4]\t$in[5]\n";  
  }
  elsif($dot[2] eq -1){
    $end = $dot[1]-1;
    print INT "$in[0]\t$in[1]\t$end\t$in[3]\t$in[4]\t$in[5]\n";
    print EX "$in[0]\t$dot[1]\t$in[2]\t$in[3]\t$in[4]\t$in[5]\n";
  }
}

close IN;
close EX;
close INT;

 
