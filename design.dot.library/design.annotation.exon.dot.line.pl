#! perl -w 
use warnings;

open IN, "<", "./design.dot.library/library.results/sort.base.chrom.annotation.exon.gtf";
open OUT, ">", "./design.dot.library/library.results/annotation.exon.dot.line";
open DD, ">", "./design.dot.library/library.results/dropped_exon_dot";

##we define  5' eq -1 and 3' eq 1, whatever gene strand is.
$last_chr="";
while (<IN>){
  s/;//g;
  s/"//g;
  s/"//g;
  my @in = split /\s+/,$_;
  if ($in[0] eq $last_chr) {
    $sta="$in[3];-1;0;$in[9];$in[6]";
    $end="$in[4];1;0;$in[9];$in[6]";

    if (map{/\b$in[3]\b/}@loci){
      print DD "$last_chr\t$in[9]\t$in[6]\t.\t$sta\n";
      if(map{/\b$in[4]\b/}@loci) {
        print DD "$last_chr\t$in[9]\t$in[6]\t.\t$end\n";
      }
      else{
        push @exon,$end;
        push @loci,$in[4];
      }
    }
    elsif(map{/\b$in[4]\b/}@loci) {
      print DD "$last_chr\t$in[9]\t$in[6]\t.\t$end\n";
      push @exon,$sta;
      push @loci,$in[3];
    }
    else{
      push @exon,$sta;
      push @exon,$end;
      push @loci,$in[3];
      push @loci,$in[4];
    }
  }
  elsif ($in[0] ne $last_chr and $last_chr ne ""){
    foreach $exon (@exon){
      my @compare = split /;/, $exon;
      $hash{$compare[0]}="$compare[1];$compare[2];$compare[3];$compare[4]";
    }
    my @keys = keys %hash;
    my @sorted_keys = sort { $a <=> $b } @keys;
    foreach $sorted (@sorted_keys){
      push @sorted_exon_dot,"$sorted;$hash{$sorted}";
    }
    print OUT "$last_chr\t.\t@sorted_exon_dot\n";
    undef @compare;
    undef %hash;
    undef @keys;
    undef @sorted_keys;
    undef @sorted_exon_dot;
    undef @exon;
    undef @loci;
    $last_chr = $in[0];
    $sta="$in[3];-1;0;$in[9];$in[6]";
    $end="$in[4];1;0;$in[9];$in[6]";
    push @exon,$sta;
    push @exon,$end;
    push @loci,$in[3];
    push @loci,$in[4];
  }
  elsif ($in[0] ne $last_chr and $last_chr eq ""){
    $last_chr = $in[0];
    $sta="$in[3];-1;0;$in[9];$in[6]";
    $end="$in[4];1;0;$in[9];$in[6]";
    push @exon,$sta;
    push @exon,$end;
    push @loci,$in[3];
    push @loci,$in[4];
  }
}


foreach $exon (@exon){
   my @compare = split /;/, $exon;
   $hash{$compare[0]}="$compare[1];$compare[2];$compare[3];$compare[4]";
 }
 my @keys = keys %hash;
 my @sorted_keys = sort { $a <=> $b } @keys;
 foreach $sorted (@sorted_keys){
   push @sorted_exon_dot,"$sorted;$hash{$sorted}";
 }
 print OUT "$last_chr\t.\t@sorted_exon_dot\n";

 undef @compare;
 undef %hash;
 undef @keys;
 undef @sorted_keys;
 undef @sorted_exon_dot;
 undef @exon;
 undef @loci;


close IN;
close OUT;
close DD;
                     





