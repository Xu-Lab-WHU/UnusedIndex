use warnings;
$gtf = $ARGV[0]; 
$samfile = $ARGV[1];                      ####### split by comma #######
$sample_name = $ARGV[2];                  ####### split by comma #######
$cut = $ARGV[3];                          ####### defaut is 15. ########                                                     
$reads_number = $ARGV[4];                 ####### defaut is 20. ########
$tolerable = $ARGV[5];                    ####### defaut is 2. #########
$region_len = $ARGV[6];                   ####### defaut is 40. ########


###########################################################################################
########################## produce the reference library ##################################
###########################################################################################

####get exon from flybase annotation. e.g. dmel-all-r6.10.gtf.
system ("perl ./design.dot.library/get.annotaion.exon.pl $gtf");

###sort annotation.exon.gtf with chrom,sta,end.
system ("sort -k1,1 -k4,4 -k5,5 ./design.dot.library/library.results/annotation.exon.gtf > ./design.dot.library/library.results/sort.base.chrom.annotation.exon.gtf");


###design annotation exon dot line from sort_base_chrom_annotation.exon.gtf. Also, we define  5' eq -1 and 3' eq 1, whatever gene strand.
system ("perl ./design.dot.library/design.annotation.exon.dot.line.pl");
system ("rm -r ./design.dot.library/library.results/dropped_exon_dot ./design.dot.library/library.results/sort.base.chrom.annotation.exon.gtf");


###select first and end exon_dot from annotation.exon.gtf.
system ("perl ./design.dot.library/select.first.and.end.exon.dot.pl"); 
system ("sort ./design.dot.library/library.results/annotation.FirandEnd.exon.dot > ./design.dot.library/library.results/sort.annotation.FirandEnd.exon.dot");
system ("rm -r ./design.dot.library/library.results/annotation.exon.gtf ./design.dot.library/library.results/annotation.FirandEnd.exon.dot");

###count First and End dot number from annotation_exon_dot_line with sort.annotation.FirandEnd.exon.dot.
system ("perl ./design.dot.library/count.FirandEnd.pl");
system ("rm -r ./design.dot.library/library.results/sort.annotation.FirandEnd.exon.dot");


#########################################################################################
##################### prepare the novel dot infromation #################################
#########################################################################################

###find junction reads from SAM file.
system ("perl ./design.dot.library/find.junction.reads.pl $samfile $sample_name");

###when define the exon, the junction reads' cigar number "N" must largger than $cut (here $cut == 15, < 15nt is cut).
@sample = split /,/,$sample_name;
foreach $sample (@sample){
  system ("perl ./design.dot.library/change.to.jun.information.form.pl ./design.dot.library/library.results/$sample.junction_reads.sam $sample $cut");
}

foreach $sample (@sample){
  system ("rm -r ./design.dot.library/library.results/$sample.junction_reads.sam");
}

###cat juntion reads infromation files.
foreach $sample (@sample){
  open IN, "<", "./design.dot.library/library.results/$sample.defined.jun.information.bed";
  open OUT, ">>", "./design.dot.library/library.results/defined.jun.information.bed";
  while (<IN>){
    print OUT $_;
  }
  system ("rm -r ./design.dot.library/library.results/$sample.defined.jun.information.bed");
  close IN;
  close OUT;
}


###sort by chrom.
system ("sort -k1,1 ./design.dot.library/library.results/defined.jun.information.bed > ./design.dot.library/library.results/sort.defined.jun.information.bed");
system ("rm -r ./design.dot.library/library.results/defined.jun.information.bed");


###modification by statastic the same junction.
system ("perl ./design.dot.library/statastic.same.jun.infor.pl");
system ("rm -r ./design.dot.library/library.results/sort.defined.jun.information.bed");


###select the juction based on the support reads number $reads_number.(here $reads_number  must larger than 20.)
system ("perl ./design.dot.library/select.jun.reads.num.pl $reads_number");
system ("rm -r ./design.dot.library/library.results/modifi.sort.defined.jun.information.bed");



##########################################################################################################
##################add novel dot to reference library  without gene information############################
##########################################################################################################

###when find the novel dot,we need except the overlap exon influnce. (e.g. the 356891;-1;0 and 356891;1;0 exists, so we need except one.)
###the changes nearby the correct location can be tolerable. the $tolerable number must < 5, here $tolerable =2nt.
system ("perl ./design.dot.library/find.novel.juntion.dot.pl $tolerable");
system ("rm -r ./design.dot.library/library.results/annotation.exon.dot.line ./design.dot.library/library.results/select.modifi.sort.defined.jun.information.bed");

###design library
system ("perl ./design.dot.library/library.design.pl");
system ("rm -r ./design.dot.library/library.results/chrom.based.novel.junction.dropped.gene.dot ./design.dot.library/library.results/chrom.based.novel.junction.dot");

###add novel line to reference line.
system ("perl ./design.dot.library/add.novel.to.reference.pl");
system ("rm -r ./design.dot.library/library.results/chrom.based.novel.junction.dot.line ./design.dot.library/library.results/chrom.based.annotation.CountFE.dot.line");
###define the library useful region by $region_len. Here $region_len is 40.
system ("perl ./design.dot.library/define.the.library.region.pl $region_len");

###split the region
system ("perl ./design.dot.library/split.exon.intron.region.pl");


