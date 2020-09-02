#! perl -w 
$tolerable_change = $ARGV[0];

open IN, "<", "./design.dot.library/library.results/annotation.exon.dot.line";
while (<IN>){
  chomp($_);
  my @line = split /\./, $_;
  my @line1 = split /\s+/, $line[0];
  $hash_line{$line1[0]}=$line[1];
}
close IN;

open RI, "<", "./design.dot.library/library.results/select.modifi.sort.defined.jun.information.bed";
open OUT, ">", "./design.dot.library/library.results/chrom.based.novel.junction.dot";
open DD, ">", "./design.dot.library/library.results/chrom.based.known.junction_dot";

while (<RI>){
  my @in = split /\s+/,$_;
  $m=1;
  $sta1 = $in[1];
  $end1 = $in[2];
  $sta2 = $in[1];
  $end2 = $in[2];
  $match1 = $sta1;
  $match2 = $end1;
  push @arry1,$match1;
  push @arry2,$match2;

  while ($m <= $tolerable_change){
    $sta1 = $sta1-1;
    $sta2 = $sta2+1;
    $end1 = $end1-1;
    $end2 = $end2+1;
    $match1 = $sta1;
    $match2 = $end1;
    $match3 = $sta2;
    $match4 = $end2;
    push @arry1,$match1;
    push @arry2,$match2;
    push @arry1,$match3;
    push @arry2,$match4;
    $m++;
  }
  
  $last_chrom = "";
   
  if ($in[0] ne $last_chrom and $last_chrom eq ""){
    $last_chrom = $in[0];
    $a = 0;
    $b = 0;
    if (exists $hash_line{$in[0]}){
      @dot =$hash_line{$in[0]};
      foreach $arry1 (@arry1){
        if(map{/$arry1/}@dot){
          $a=1;
          last;
        }
        else{
          next;
        }
      }
      if ($a == 1){
        print DD "$in[0]\t$in[1];1;0\t$in[3]\t$in[5]\n";
      }
      elsif ($a == 0){
        print OUT "$in[0]\t$in[1];1;0\t$in[3]\t$in[5]\n";  
      }
     
      foreach $arry2 (@arry2){
        if(map{/$arry2/}@dot){    
          $b=1;
          last;
        }
        else{
          next; 
        }
      }
      if ($b == 1){
        print DD "$in[0]\t$in[2];-1;0\t$in[3]\t$in[5]\n";
      }
      elsif ($b == 0){
        print OUT "$in[0]\t$in[2];-1;0\t$in[3]\t$in[5]\n";
      }
    }
    else{
      next;
    }
  }
  elsif ($in[0] eq $last_chrom ){
    $a = 0;
    $b = 0;
    if (exists $hash_line{$in[0]}){
      @dot = $hash_line{$in[0]};
      foreach $arry1 (@arry1){
        if(map{/$arry1/}@dot){
          $a=1;
          last;
        }
        else{
          next;
        }
      }
      if ($a == 1){
        print DD "$in[0]\t$in[1];1;0\t$in[3]\t$in[5]\n";
      }
      elsif ($a == 0){
        print OUT "$in[0]\t$in[1];1;0\t$in[3]\t$in[5]\n";
      }

      foreach $arry2 (@arry2){
        if(map{/$arry2/}@dot){
          $b=1;
          last;
        }
        else{
          next;
        }
      }
      if ($b == 1){
        print DD "$in[0]\t$in[2];-1;0\t$in[3]\t$in[5]\n";
      }
      elsif ($b == 0){
        print OUT "$in[0]\t$in[2];-1;0\t$in[3]\t$in[5]\n";
      }
    }
    else{
      next;
    }
  }

 
  elsif ($in[0] ne $last_chrom and $last_chrom ne ""){
    $last_chrom = $in[0];
    $a = 0;
    $b = 0;
    if (exists $hash_line{$in[0]}){
      @dot =$hash_line{$in[0]};
      foreach $arry1 (@arry1){
        if(map{/$arry1/}@dot){
          $a=1;
          last;
        }
        else{
          next;
        }
      }
      if ($a == 1){
        print DD "$in[0]\t$in[1];1;0\t$in[3]\t$in[5]\n";
      }
      elsif ($a == 0){
        print OUT "$in[0]\t$in[1];1;0\t$in[3]\t$in[5]\n";
      }

      foreach $arry2 (@arry2){
        if(map{/$arry2/}@dot){
          $b=1;
          last;
        }
        else{
          next;
        }
      }
      if ($b == 1){
        print DD "$in[0]\t$in[2];-1;0\t$in[3]\t$in[5]\n";
      }
      elsif ($b == 0){
        print OUT "$in[0]\t$in[2];-1;0\t$in[3]\t$in[5]\n";
      }
    }
    else{
      next;
    }
  }
undef @arry1;
undef @arry2;
}  
  

close RI;
close OUT;
close DD;


