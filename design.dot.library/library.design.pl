#! perl -w 
open IN, "<", "./design.dot.library/library.results/chrom.based.novel.junction.dot";
open OUT, ">", "./design.dot.library/library.results/chrom.based.novel.junction.dot.line";
open DD, ">", "./design.dot.library/library.results/chrom.based.novel.junction.dropped.gene.dot";

##just think 5' eq -1 and 3' eq 1, whatever gene strand.
$last_chr="";
while (<IN>){
  my @in = split /\s+/,$_;
  if ($in[0] eq $last_chr) {
    $jun_dot="$in[1];FBgn;strand";
    my @jun_loci = split /;/,$in[1];
    if (exists $hash_loci{$jun_loci[0]}){
      $n= $hash_loci{$jun_loci[0]};
      $n++;
      $hash_loci{$jun_loci[0]} =$n;
      print DD "$last_chr\t$in[2]\t$in[3]\t.\t$in[1]\n";
    }else{
       $hash_loci{$jun_loci[0]} =1;
       push @jun_exon,$jun_dot;
    }
  }
  elsif ($in[0] ne $last_chr and $last_chr ne ""){
    foreach $jun_exon (@jun_exon){
      my @compare = split /;/, $jun_exon;
      $hash{$compare[0]}="$compare[1];$compare[2];$compare[3];$compare[4]";
    }
    my @keys = keys %hash;
    my @sorted_keys = sort { $a <=> $b } @keys;
    foreach $sorted (@sorted_keys){
      push @sorted_exon_dot,"$sorted;$hash{$sorted}";
    }
    print OUT "$last_chr\t.\t@sorted_exon_dot\n";
    undef %hash;
    undef @keys;
    undef @sorted_keys;
    undef @sorted_exon_dot;
    undef @jun_exon;
    undef %hash_loci;
    $last_chr = $in[0];
    $jun_dot="$in[1];FBgn;strand";
    my @jun_loci = split /;/,$in[1];
    push @jun_exon,$jun_dot;
    $hash_loci{$jun_loci[0]} =1;
  }
  elsif ($in[0] ne $last_chr and $last_chr eq ""){
    $last_chr = $in[0];
    $jun_dot="$in[1];FBgn;strand";
    my @jun_loci = split /;/,$in[1];
    $hash_loci{$jun_loci[0]} =1;
    push @jun_exon,$jun_dot;
  }
}


 foreach $jun_exon (@jun_exon){
   my @compare = split /;/, $jun_exon;
   $hash{$compare[0]}="$compare[1];$compare[2];$compare[3];$compare[4]";
 }
 my @keys = keys %hash;
 my @sorted_keys = sort { $a <=> $b } @keys;
 foreach $sorted (@sorted_keys){
   push @sorted_exon_dot,"$sorted;$hash{$sorted}";
 }
 print OUT "$last_chr\t.\t@sorted_exon_dot\n";



close IN;
close OUT;
close DD;
                     





