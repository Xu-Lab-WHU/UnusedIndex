#! perl -w 

open IN, "<", "./design.dot.library/library.results/annotation.exon.dot.line";
#open HA, ">", "hash_line";
while (<IN>){
  chomp($_);
  my @line = split /\./, $_;
  my @line1 = split /\s+/, $line[0];
  $hash_line{$line1[0]}=$line[1];
}

##check hash;
#while (($k,$v)=each %hash_line){
 # print HA "$k\t$v\n";
#}
#close HA;

close IN;

open FE, "<", "./design.dot.library/library.results/sort.annotation.FirandEnd.exon.dot";
open OUT, ">", "./design.dot.library/library.results/chrom.based.annotation.CountFE.dot.line";
#open OUTT, ">", "temp";
$last_chrom="";
while (<FE>){
  chomp($_);
  my @firend = split /\s+/, $_;
  $firend[1] =~ s/"//;
  $firend[1] =~ s/"//;
  $firend[1] =~ s/;//;
##@firend is no problem.
#print OUTT "@firend\n";
  if ($firend[0] ne $last_chrom and $last_chrom eq ""){
    $last_chrom = $firend[0];
    @dot = $hash_line{$firend[0]};
    my @fAe = split /;/, $firend[5];
    $fAe_mach="$fAe[0];$fAe[1]";
    $last_n=0;
    $n=1;
    $mach = "$fAe_mach;$last_n";
    $str = "$fAe_mach;$n";
    foreach $dot_line (@dot){
      $dot_line=~s/$mach/$str/;
    }
    $hash{$fAe_mach} =$n;
  }
  
  elsif ($firend[0] eq $last_chrom and $last_chrom ne ""){
    my @fAe = split /;/, $firend[5];
    $fAe_mach="$fAe[0];$fAe[1]";
    if (exists $hash{$fAe_mach}){
      $last_n = $hash{$fAe_mach};
      $n = $last_n +1;
      $mach = "$fAe_mach;$last_n";
      $str = "$fAe_mach;$n";
      foreach $dot_line (@dot){
        $dot_line=~s/$mach/$str/;
      }
      $hash{$fAe_mach} = $n;
    }
    else{
      $last_n=0;
      $n=1;
      $hash{$fAe_mach} = $n;
      $mach = "$fAe_mach;$last_n";
      $str = "$fAe_mach;$n";
      foreach $dot_line (@dot){
        $dot_line=~s/$mach/$str/;
      }
    }
  }
  
  elsif($firend[0] ne $last_chrom and $last_chrom  ne "") {
    print OUT "$last_chrom\t.\t@dot\n";
    undef @dot;
    undef %hash;
    $last_chrom  = $firend[0];
    @dot = $hash_line{$firend[0]};
    my @fAe = split /;/, $firend[5];
    $fAe_mach="$fAe[0];$fAe[1]";
    $last_n=0;
    $n=1;
    $mach = "$fAe_mach;$last_n";
    $str = "$fAe_mach;$n";
    foreach $dot_line (@dot){
        $dot_line=~s/$mach/$str/;
    }
    $hash{$fAe_mach}=$n;
  }
}

print OUT "$last_chrom\t.\t@dot\n";

close FE;
close OUT;
#close OUTT;


