#! perl -w 

$cut_length = $ARGV[0];
open IN, "<","./design.dot.library/library.results/ref.add.nov.CountFE.dot.line";
open OUT, ">","./design.dot.library/library.results/ref.add.nov.CountFE.dot.line.bed";
#open TEM, ">","temp";

while (<IN>){
  chomp ($_);
  my @in = split /\./, $_;
  $chrom = $in[0];
  @dot= split /\s+/, $in[1];
##check @dot is no problem.
#  print TEM "@dot\n";
  $last_num ="";
  foreach $dot (@dot){
    if ($dot eq ""){
      $n=1;
      next;
    }
    else{
      $dot_hash{$n} = $dot;
      $n++;
    }
  }
 
  foreach $dot (@dot){
    if ($dot eq ""){
      next;
    }
    else{
      my @loci = split /;/, $dot;
      if ($last_num eq ""){
        $m=1;
        $last_loci = $loci[0];
        $last_ForT = $loci[1];
        $last_num = $loci[2];
        $last_gene = $loci[3];
        $last_strand = $loci[4];
        next;
      }

      elsif($last_num != 0 and $loci[2] != 0){
        $m++;
        $last_loci = $loci[0];
        $last_ForT = $loci[1];
        $last_num = $loci[2];
        $last_gene = $loci[3];
        $last_strand = $loci[4];
        next;
      }

      elsif ($last_num != 0 and $loci[2] == 0 and $loci[1] eq 1){
        $m++;
        $forward_len = $loci[0]-$last_loci;
        $last_loci = $loci[0];
        $last_ForT = $loci[1];
        $last_num = $loci[2];
        $last_gene = $loci[3];
        $last_strand = $loci[4];
        next;
      }

      elsif ($last_num != 0 and $loci[2] == 0 and $loci[1] eq -1){
        $m++;
        $forward_len = $loci[0]-$last_loci-1;
        if ($forward_len == 0 ){
          $llast_dot_num = $m-2;
          @llast = split /;/,$dot_hash{$llast_dot_num};
          $forward_len = $loci[0]-$llast[0]-1;
        }
        $last_loci = $loci[0];
        $last_ForT = $loci[1];
        $last_num = $loci[2];
        $last_gene = $loci[3];
        $last_strand = $loci[4];
        next;
      }
      
 

      elsif ($last_num == 0 and $loci[2] == 0 and $last_ForT eq -1 and $loci[1] eq 1){
        $m++;
        $backward_len = $loci[0]-$last_loci;
        if ($forward_len >= $cut_length and $backward_len >= $cut_length){
          $sta = $last_loci-$cut_length;
          $end = $last_loci+$cut_length-1;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        elsif ($forward_len <= $backward_len and $backward_len < $cut_length){
          $sta = $last_loci-$forward_len;
          $end = $last_loci+$forward_len-1;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        elsif ($backward_len <= $forward_len and $forward_len < $cut_length){
          $sta = $last_loci-$backward_len;
          $end = $last_loci+$backward_len-1;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        elsif ($forward_len >= $cut_length and $backward_len < $cut_length){
          $sta = $last_loci-$backward_len;
          $end = $last_loci+$backward_len-1;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        elsif ($forward_len < $cut_length and $backward_len >= $cut_length){
          $sta = $last_loci-$forward_len;
          $end = $last_loci+$forward_len-1;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        $forward_len = $loci[0]-$last_loci;
        $last_loci = $loci[0];
        $last_ForT = $loci[1];
        $last_num = $loci[2];
        $last_gene = $loci[3];
        $last_strand = $loci[4];
        next;
      }

      elsif ($last_num == 0 and $loci[2] == 0 and $last_ForT eq -1 and $loci[1] eq -1){
        $m++;
        $backward_len = $loci[0]-$last_loci;
        if ($forward_len >= $cut_length and $backward_len >= $cut_length){
          $sta = $last_loci-$cut_length;
          $end = $last_loci+$cut_length-1;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        elsif ($forward_len <= $backward_len and $backward_len < $cut_length){
          $sta = $last_loci-$forward_len;
          $end = $last_loci+$forward_len-1;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        elsif ($backward_len <= $forward_len and $forward_len < $cut_length){
          $sta = $last_loci-$backward_len;
          $end = $last_loci+$backward_len-1;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        elsif ($forward_len >= $cut_length and $backward_len < $cut_length){
          $sta = $last_loci-$backward_len;
          $end = $last_loci+$backward_len-1;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        elsif ($forward_len < $cut_length and $backward_len >= $cut_length){
          $sta = $last_loci-$forward_len;
          $end = $last_loci+$forward_len-1;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        $forward_len = $loci[0]-$last_loci-1;
        if ($forward_len == 0 ){
          $llast_dot_num = $m-2;
          @llast = split /;/,$dot_hash{$llast_dot_num};
          $forward_len = $loci[0]-$llast[0]-1;
        }
        $last_loci = $loci[0];
        $last_ForT = $loci[1];
        $last_num = $loci[2];
        $last_gene = $loci[3];
        $last_strand = $loci[4];
        next;
      }  

      elsif ($last_num == 0 and $loci[2] == 0 and $last_ForT eq 1 and $loci[1] eq 1){
        $m++;
        $backward_len = $loci[0]-$last_loci-1;
        if ($backward_len == 0 ){
          $next_dot_num = $m+1;
          @next = split /;/,$dot_hash{$next_dot_num};
          $backward_len = $next[0]-$last_loci-1;
        }

        if ($forward_len >= $cut_length and $backward_len >= $cut_length){
          $sta = $last_loci-$cut_length+1;
          $end = $last_loci+$cut_length;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        elsif ($forward_len <= $backward_len and $backward_len < $cut_length){
          $sta = $last_loci-$forward_len+1;
          $end = $last_loci+$forward_len;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        elsif ($backward_len <= $forward_len and $forward_len < $cut_length){
          $sta = $last_loci-$backward_len+1;
          $end = $last_loci+$backward_len;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        } 
        elsif ($forward_len >= $cut_length and $backward_len < $cut_length){
          $sta = $last_loci-$backward_len+1;
          $end = $last_loci+$backward_len;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        elsif ($forward_len < $cut_length and $backward_len >= $cut_length){
          $sta = $last_loci-$forward_len+1;
          $end = $last_loci+$forward_len;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        $forward_len = $loci[0]-$last_loci;
        $last_loci = $loci[0];
        $last_ForT = $loci[1];
        $last_num = $loci[2];
        $last_gene = $loci[3];
        $last_strand = $loci[4];
        next;
      }
    
      elsif ($last_num == 0 and $loci[2] == 0 and $last_ForT eq 1 and $loci[1] eq -1){
        $m++;
        $backward_len = $loci[0]-$last_loci-1;
        if ($backward_len == 0 ){
          $next_dot_num = $m+1;
          @next = split /;/,$dot_hash{$next_dot_num};
          $backward_len = $next[0]-$last_loci-1;
        }

        if ($forward_len >= $cut_length and $backward_len >= $cut_length){
          $sta = $last_loci-$cut_length+1;
          $end = $last_loci+$cut_length;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        elsif ($forward_len <= $backward_len and $backward_len < $cut_length){
          $sta = $last_loci-$forward_len+1;
          $end = $last_loci+$forward_len;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        elsif ($backward_len <= $forward_len and $forward_len < $cut_length){
          $sta = $last_loci-$backward_len+1;
          $end = $last_loci+$backward_len;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        elsif ($forward_len >= $cut_length and $backward_len < $cut_length){
          $sta = $last_loci-$backward_len+1;
          $end = $last_loci+$backward_len;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        elsif ($forward_len < $cut_length and $backward_len >= $cut_length){
          $sta = $last_loci-$forward_len+1;
          $end = $last_loci+$forward_len;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        $forward_len = $loci[0]-$last_loci-1;
        if ($forward_len == 0 ){
          $llast_dot_num = $m-2;
          @llast = split /;/,$dot_hash{$llast_dot_num};
          $forward_len = $loci[0]-$llast[0]-1;
        }  

        $last_loci = $loci[0];
        $last_ForT = $loci[1];
        $last_num = $loci[2];
        $last_gene = $loci[3];
        $last_strand = $loci[4];
        next;
      }


      elsif ($last_num == 0 and $loci[2] != 0 and $last_ForT eq -1){
        $m++;
        $backward_len = $loci[0]-$last_loci;
        if ($forward_len >= $cut_length and $backward_len >= $cut_length){
          $sta = $last_loci-$cut_length;
          $end = $last_loci+$cut_length-1;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        elsif ($forward_len <= $backward_len and $backward_len < $cut_length){
          $sta = $last_loci-$forward_len;
          $end = $last_loci+$forward_len-1;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        elsif ($backward_len <= $forward_len and $forward_len < $cut_length){
          $sta = $last_loci-$backward_len;
          $end = $last_loci+$backward_len-1;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        elsif ($forward_len >= $cut_length and $backward_len < $cut_length){
          $sta = $last_loci-$backward_len;
          $end = $last_loci+$backward_len-1;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        elsif ($forward_len < $cut_length and $backward_len >= $cut_length){
          $sta = $last_loci-$forward_len;
          $end = $last_loci+$forward_len-1;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        $last_loci = $loci[0];
        $last_ForT = $loci[1];
        $last_num = $loci[2];
        $last_gene = $loci[3];
        $last_strand = $loci[4];
        next;
      }

      elsif ($last_num == 0 and $loci[2] != 0 and $last_ForT eq 1){
        $m++;
        $backward_len = $loci[0]-$last_loci-1;
        if ($backward_len == 0 ){
          $next_dot_num = $m+1;
          @next = split /;/,$dot_hash{$next_dot_num};
          $backward_len = $next[0]-$last_loci-1;
        }

        if ($forward_len >= $cut_length and $backward_len >= $cut_length){
          $sta = $last_loci-$cut_length+1;
          $end = $last_loci+$cut_length;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        elsif ($forward_len <= $backward_len and $backward_len < $cut_length){
          $sta = $last_loci-$forward_len+1;
          $end = $last_loci+$forward_len;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
          elsif ($backward_len <= $forward_len and $forward_len < $cut_length){
          $sta = $last_loci-$backward_len+1;
          $end = $last_loci+$backward_len;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        elsif ($forward_len >= $cut_length and $backward_len < $cut_length){
          $sta = $last_loci-$backward_len+1;
          $end = $last_loci+$backward_len;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        elsif ($forward_len < $cut_length and $backward_len >= $cut_length){
          $sta = $last_loci-$forward_len+1;
          $end = $last_loci+$forward_len;
          print OUT "$chrom\t$sta\t$end\t$last_gene:$last_loci:$last_ForT\t.\t$last_strand\n";
        }
        $last_loci = $loci[0];
        $last_ForT = $loci[1];
        $last_num = $loci[2];
        $last_gene = $loci[3];
        $last_strand = $loci[4];
        next;
      }
    }
  }
undef %dot_hash;
}

close IN;
close OUT;
#close TEM;
