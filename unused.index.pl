#! /usr/bin/perl -w

use strict;
use warnings;
use Getopt::Long;

my $gtf;                     ###################annotation gtf file. #################################################################
my $samfile;                 ###################sam file by mapping and be split by comma. ###########################################
my $bam;                     ###################bam file and be split by comma. ######################################################
my $sample_name;             ###################sample name list which be split by comma. ############################################
my $compare;                 #######compare wt and mut. e.g. larva_rep1,mut1;larva_rep1,mut2;larva_rep2,mut1;larva_rep2,mut2.#########
my $cut = 15;                #######the minimum intron length. defaut is 15.##########################################################
my $reads_number = 20;       #######the minimum reads which suport the nonvel junction. defaut is 20. ################################
my $tolerable =2;            #######the maximum location changes nearby the correct dot. defaut is 2. ################################
my $region_len = 40;         #######the maximun library useful region. defaut is 40. #################################################
my $help;

&GetOptions(
    "a|annotation=s"     =>\ $gtf,
    "s|sam=s"            =>\ $samfile,
    "b|bam=s"            =>\ $bam,
    "n|sampleName=s"     =>\ $sample_name,
    "c|compare=s"        =>\ $compare,
    "i|intronL=i"        =>\ $cut,
    "r|suportReads=i"    =>\ $reads_number,
    "t|tolerable=i"      =>\ $tolerable,
    "rl=i"               =>\ $region_len,
    "h|help"             =>\ $help
);

&usage() if $help;
exit if $help;

if(!$samfile){
    print "    Miss InputData!!\n\tSee help doc by -h|--help.\n";
	exit(-1);
}


################### design the reference and novel dot library. ######################################
system ("perl ./design.dot.library/design.dot.library.pl $gtf $samfile $sample_name $cut $reads_number $tolerable $region_len");

################### calculate the unused index. ######################################################
system ("perl ./calculate.unused.index/calculate.unused.index.pl $bam $sample_name $compare");


################## produce index results. ###########################################################
system ("mkdir sample.unused.index.results");

my @compare_list = split /:/,$compare;
foreach my $compare_list(@compare_list){
  my @infor = split /,/,$compare_list;
  my $wt = $infor[0];
  my $mut = $infor[1];
  system ("cp ./calculate.unused.index/$wt.and.$mut.statistic/$wt.and.$mut.ref_add_nov_a_ge5_c_ne0_statistics_results ./sample.unused.index.results");
}


sub usage {
    my $usage = qq^
    >>>>>>>>>>>>>>>>>  Caculate Splice Site UnsedIndex  <<<<<<<<<<<<<<<<<
    
    Usage:
        perl $0 -a <FILE> -s <LIST> -b <LIST> -c <STRINGS> \
            -i <INT> -r <INT> -t <INT> -rl <INT>
            
    Required : 
        
        -a,--annotation   annotation gtf file.
        -s,--sam          sam file by mapping and be split by comma.
                          e.g.: 
                          wt-1.sam,wt-2.sam,RNAi-1.sam,RNAi-2.sam
        -b,--bam          bam file and be split by comma.
        -n,--sampleName   sample name list. 
        -c,--compare      compare wt and mut. 
                          e.g.: 
                          larva_rep1,mut1;larva_rep1,mut2;larva_rep2,mut1;larva_rep2,mut2
        -i,--intronL      the minimum intron length. (defaut:15)
        -r,--suportReads  the minimum reads which suport the nonvel 
                          junction. (defaut:20)
        -t,--tolerable    the maximum location changes nearby the 
                          correct dot. (defaut:2)
        -rl               the maximun library useful region.(defaut is 40)
        -h,--help
    
    Test code:
	nohup perl unused.index.pl -a test.data/dmel-all-r6.23.gtf \
          -s test.data/wt-1.sam,test.data/wt-2.sam,test.data/mut-1.sam,test.data/mut-2.sam \
          -b test.data/wt-1.bam,test.data/wt-2.bam,test.data/mut-1.bam,test.data/mut-2.bam \
          -n wt-1,wt-2,mut-1,mut-2 -c wt-1,mut-1:wt-1,mut-2:wt-2,mut-1:wt-2,mut-2 \
          -i 15 -r 20 -t 2 -rl 40 > 2019.7.31 &
    
    VERSION 1.0.0
    ^;
    print STDERR $usage,"\n";
    exit(-1);
}
__END__
######################### END #######################################################################
