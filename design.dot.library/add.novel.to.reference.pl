#! perl -w
open NOV,"<", "./design.dot.library/library.results/chrom.based.novel.junction.dot.line";
while (<NOV>){
  my @novel = split /\./,$_;
  $nov_chrom = $novel[0];
  @nov_dot = split /\s+/, $novel[1];
  foreach $nov_dot_infor (@nov_dot){
    if ($nov_dot_infor eq ""){
      next;
    }
    else{
      push @new_nov_dot, $nov_dot_infor;
    }
  }
  $new_novel="@new_nov_dot";     
  $hash{$nov_chrom}=$new_novel;
  undef @new_nov_dot;
}
close NOV;

#open TEMP, ">", "temp_hash";
#while (($k,$v)=each %hash){
#  print TEMP "$k\t.\t$v\n";
#}
#close TEMP;


open IN, "<", "./design.dot.library/library.results/chrom.based.annotation.CountFE.dot.line";
open OUT, ">", "./design.dot.library/library.results/ref.add.nov.CountFE.dot.line";
while (<IN>){
  my @line = split /\./,$_;
  $chrom = $line[0];
  if (exists $hash{$chrom}){
    @dot= split /\s+/, $line[1];
    foreach $dot_infor (@dot){
      if ($dot_infor eq ""){
        next;
      }
      else{
        @ref_dot = split /;/,$dot_infor;
        $ref_add_nov_hash{$ref_dot[0]}=$dot_infor;
        push @arry,$ref_dot[0];
      }
    }
    @nov_new_hash=split /\s+/,$hash{$chrom};
    foreach $dot_nov_new_hash(@nov_new_hash){
      @dot_nov_new_hash_dot = split /;/,$dot_nov_new_hash;
      $ref_add_nov_hash{$dot_nov_new_hash_dot[0]}=$dot_nov_new_hash;
      push @arry,$dot_nov_new_hash_dot[0];
    }
    @sorted_arry = sort { $a <=> $b } @arry;
    foreach $sort_arry(@sorted_arry){
      push @sort_dot , $ref_add_nov_hash{$sort_arry};
    }
    print OUT "$chrom\t.\t@sort_dot\n";
    undef @arry;
    undef @sort_dot;
    undef %ref_add_nov_hash;
  }
  else{
    print OUT "$_";
  }
} 
close IN;
close OUT;
 
