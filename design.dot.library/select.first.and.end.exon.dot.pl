#! perl -w

open IN, "<", "./design.dot.library/library.results/annotation.exon.gtf";
open OUT, ">", "./design.dot.library/library.results/annotation.FirandEnd.exon.dot";

$last_chr ="";
$last_gene ="";
$last_strand ="";
$last_transID ="";
$last_sta ="";
$last_end ="";
while (<IN>){
 my @in = split /\s+/, $_;
 if ($in[13] eq $last_transID){
   $sta = "$in[3];-1;0";
   $end = "$in[4];1;0";
   $last_sta = $sta;
   $last_end = $end;   
 }
 elsif($in[13] ne $last_transID and $last_transID ne "") {
   $sta = "$in[3];-1;0";
   $end = "$in[4];1;0";
   if ($last_strand eq "+" and $in[6] eq "+"){
     print OUT "$last_chr\t$last_gene\t$last_strand\t.\t$last_transID\t$last_end\n";
     print OUT "$in[0]\t$in[9]\t$in[6]\t.\t$in[13]\t$sta\n";
     $last_chr = $in[0];
     $last_gene = $in[9];
     $last_strand = $in[6];
     $last_transID = $in[13];
     $last_sta = $sta;
     $last_end = $end;
   }
   elsif($last_strand eq "+" and $in[6] eq "-"){
     print OUT "$last_chr\t$last_gene\t$last_strand\t.\t$last_transID\t$last_end\n";
     print OUT "$in[0]\t$in[9]\t$in[6]\t.\t$in[13]\t$end\n";
     $last_chr = $in[0];
     $last_gene = $in[9];
     $last_strand = $in[6];
     $last_transID = $in[13];
     $last_sta = $sta;
     $last_end = $end;
   }
   elsif($last_strand eq "-" and $in[6] eq "+"){
     print OUT "$last_chr\t$last_gene\t$last_strand\t.\t$last_transID\t$last_sta\n";
     print OUT "$in[0]\t$in[9]\t$in[6]\t.\t$in[13]\t$sta\n";
     $last_chr = $in[0];
     $last_gene = $in[9];
     $last_strand = $in[6];
     $last_transID = $in[13];
     $last_sta = $sta;
     $last_end = $end;
   }
   elsif($last_strand eq "-" and $in[6] eq "-"){
     print OUT "$last_chr\t$last_gene\t$last_strand\t.\t$last_transID\t$last_sta\n";
     print OUT "$in[0]\t$in[9]\t$in[6]\t.\t$in[13]\t$end\n";
     $last_chr = $in[0];
     $last_gene = $in[9];
     $last_strand = $in[6];
     $last_transID = $in[13];
     $last_sta = $sta;
     $last_end = $end;
   }    
 }
 elsif ($in[13] ne $last_transID and $last_transID eq ""){
   $sta = "$in[3];-1;0";
   $end = "$in[4];1;0";
   if ($in[6] eq "+"){
     print OUT "$in[0]\t$in[9]\t$in[6]\t.\t$in[13]\t$sta\n";
     $last_chr = $in[0];
     $last_gene = $in[9];
     $last_strand = $in[6];
     $last_transID = $in[13];
     $last_sta = $sta;
     $last_end = $end;
   }
   elsif($in[6] eq "-"){
     print OUT "$in[0]\t$in[9]\t$in[6]\t.\t$in[13]\t$end\n";
     $last_chr = $in[0];
     $last_gene = $in[9];
     $last_strand = $in[6];
     $last_transID = $in[13];
     $last_sta = $sta;
     $last_end = $end;
   }
 }
}

if ($last_strand eq "+"){
  print OUT "$last_chr\t$last_gene\t$last_strand\t.\t$last_transID\t$last_end\n";
}
elsif($last_strand eq "-"){
  print OUT "$last_chr\t$last_gene\t$last_strand\t.\t$last_transID\t$last_sta\n";
}

close IN;
close OUT;
