#! perl -w 
use warnings;

open IN, "<", "./design.dot.library/library.results/sort.defined.jun.information.bed";
open OUT, ">", "./design.dot.library/library.results/modifi.sort.defined.jun.information.bed";

$last_chrom = "";
$last_sta="";
$last_end="";
$n=0;
while (<IN>){
  my @in = split /\s+/, $_;
  if ($last_chrom eq ""){
    $last_chrom=$in[0];
    $last_sta=$in[1];
    $last_end=$in[2];
    $n++;
  }
  elsif($in[0] eq $last_chrom and $in[1] eq $last_sta and $in[2] eq $last_end){
    $n++;
  }
  elsif($in[0] eq $last_chrom and $in[1] eq $last_sta and $in[2] ne $last_end){
    print OUT "$last_chrom\t$last_sta\t$last_end\tjunc\t.\t$n\n";
    $last_end=$in[2];
    $n=1;
  }
  elsif($in[0] eq $last_chrom and $in[1] ne $last_sta and $in[2] eq $last_end){
    print OUT "$last_chrom\t$last_sta\t$last_end\tjunc\t.\t$n\n";
    $last_sta=$in[1];
    $n=1;
  }
  elsif($in[0] eq $last_chrom and $in[1] ne $last_sta and $in[2] ne $last_end){
    print OUT "$last_chrom\t$last_sta\t$last_end\tjunc\t.\t$n\n";
    $last_sta=$in[1];
    $last_end=$in[2];
    $n=1;
  }
  elsif($in[0] ne $last_chrom and $last_chrom ne ""){
    print OUT "$last_chrom\t$last_sta\t$last_end\tjunc\t.\t$n\n";
    $last_chrom=$in[0];
    $last_sta=$in[1];
    $last_end=$in[2];
    $n=1;
  }
}

print OUT "$last_chrom\t$last_sta\t$last_end\tjunc\t.\t$n\n";

close IN;
close OUT;



 
