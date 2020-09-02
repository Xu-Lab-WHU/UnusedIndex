use warnings;
$bam = $ARGV[0];
@sample_bam = split /,/,$bam;
$sample_name = $ARGV[1];
@sample = split /,/,$sample_name;
$n=@sample_bam;
$number = 0 ;
$compare = $ARGV[2];    ##########################compare wt and mut. e.g. larva_rep1,mut1:larva_rep1,mut2:larva_rep2,mut1:larva_rep2,mut2.###############

##########################calculae the dot region coverage#################################

while ($number < $n){
  system ("./calculate.unused.index/bedtools2-2.20.1/bin/coverageBed -abam $sample_bam[$number] -b ./design.dot.library/library.results/ref.add.nov.CountFE.dot.line.exon.bed -split > ./calculate.unused.index/coverage.results/$sample[$number].ref_add_nov_exon_coverage_results");

  system ("./calculate.unused.index/bedtools2-2.20.1/bin/coverageBed -abam $sample_bam[$number] -b ./design.dot.library/library.results/ref.add.nov.CountFE.dot.line.intron.bed -split > ./calculate.unused.index/coverage.results/$sample[$number].ref_add_nov_intron_coverage_results");
  $number++;
}

##########################selsect the coverage results#####################################

system ("perl ./calculate.unused.index/select_covrage_results.pl $compare");


