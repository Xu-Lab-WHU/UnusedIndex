# UnusedIndex 
**VERSION 1.0.0**

Bioinformatic tool to measure the Unused Index of each Splice Site from RNA-seq

    Caculate Splice Site UnsedIndex
   
## Usage:
```
perl $0 -a <FILE> -s <LIST> -b <LIST> -c <STRINGS> -i <INT> -r <INT> -t <INT> -rl <INT>
```
### Options: 
        
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

## Example running :
```perl
perl unused.index.pl -a test.data/dmel-all-r6.23.gtf \
          -s test.data/wt-1.sam,test.data/wt-2.sam,test.data/mut-1.sam,test.data/mut-2.sam \
          -b test.data/wt-1.bam,test.data/wt-2.bam,test.data/mut-1.bam,test.data/mut-2.bam \
          -n wt-1,wt-2,mut-1,mut-2 -c wt-1,mut-1:wt-1,mut-2:wt-2,mut-1:wt-2,mut-2 \
          -i 15 -r 20 -t 2 -rl 40 > 2019.7.31 &
```
## Please Cite :
Liang Li, Zhan Ding, Ting-Lin Pang, Bei Zhang, Chen-Hui Li, An-Min Liang, Yu-Ru Wang, Yu Zhou, Yu-Jie Fan, and Yong-Zhen Xu. (2020) **Defective Minor Spliceosomes Induce SMA-associated phenotypes through Sensitive Intron-Containing Neural Genes in Drosophila.** *Nature Communication.* 11:5608, doi: 10.1038/s41467-020-19451-z.
