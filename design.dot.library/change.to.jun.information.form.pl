#! perl -w
use warnings;
$input_file = $ARGV[0];
$sample_name = $ARGV[1]; 
$cut = $ARGV[2];

open IN, "<", "$input_file";
open OUT, ">", "./design.dot.library/library.results/$sample_name.defined.jun.information.bed";

while (<IN>){
  my @in = split /\s+/, $_;
  $chrom = $in[2];
  my @number = split /[A-Za-z]/,$in[5];
  my @letter = split /\d+/,$in[5];
  $n=1;
  $m=1;
  $map=0;
  $last_num=$in[3];
  foreach $num (@number){
    $hash_num{$n}=$num;
    $n++;
  }
  foreach $let (@letter){
    if ($let eq "S" or $let eq "H" or $let eq "I" or $let eq "P"){
      $m++;
      next;
    }
    elsif($let eq "M"){
      $map = $map+$hash_num{$m};
      $end = $last_num+$hash_num{$m}-1;
      $last_num =$end;
      $m++;
    }
    elsif ($let eq "D"){
      $map = $map+$hash_num{$m};
      $end = $last_num+$hash_num{$m}-1;
      $last_num =$end;
      $m++;
    }
    elsif ($let eq "N"){
      if ($hash_num{$m} < $cut){
        if (@junc_arry){
          $junc_sta=pop @junc_arry;
          $junc_end=pop @junc_arry;
          $map1=pop @junc_arry;
          print OUT "$chrom\t$junc_sta\t$junc_end\t$map1\t$map\t$in[0]\t.\t$in[5]\n";
          undef @junc_arry;
          $last_num =$end+$hash_num{$m}+1;
          $map = 0;
          $m++;
        }
        else{
          $last_num =$end+$hash_num{$m}+1;
          $map = 0;
          $m++;
        }
      }
      else{
        if (@junc_arry){
          $junc_sta=pop @junc_arry;
          $junc_end=pop @junc_arry;
          $map1=pop @junc_arry;
          print OUT "$chrom\t$junc_sta\t$junc_end\t$map1\t$map\t$in[0]\t.\t$in[5]\n"; 
          undef @junc_arry;
          $last_num =$end+$hash_num{$m}+1;
          push @junc_arry,$map;
          push @junc_arry,$last_num;
          push @junc_arry,$end;
          $map = 0;
          $m++;
        }
        else{
          $last_num =$end+$hash_num{$m}+1;
          push @junc_arry,$map;
          push @junc_arry,$last_num;
          push @junc_arry,$end;
          $map = 0;
          $m++;
        }
      }
    }
  }
  if (@junc_arry){
    $junc_sta=pop @junc_arry;
    $junc_end=pop @junc_arry;
    $map1=pop @junc_arry;
    print OUT "$chrom\t$junc_sta\t$junc_end\t$map1\t$map\t$in[0]\t.\t$in[5]\n";
    undef @junc_arry; 
  }
}

close IN;
close OUT;
