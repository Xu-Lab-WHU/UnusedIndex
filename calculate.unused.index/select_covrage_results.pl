#! perl -w 
@compare = split /:/,$ARGV[0];
foreach $compare(@compare){
  @infor = split /,/,$compare;
  $wt = $infor[0];
  $mut = $infor[1];

  system ("mkdir ./calculate.unused.index/$wt.and.$mut.statistic");
  open WE,"<", "./calculate.unused.index/coverage.results/$wt.ref_add_nov_exon_coverage_results";
  open WELT, ">", "./calculate.unused.index/$wt.and.$mut.statistic/$wt.ref_add_nov_exon_lt_5_reads";
  while (<WE>){
    my @we = split /\s+/,$_;
    if ($we[6] < 5){
      print WELT ;
    }
    else{
      $hashWE{$we[3]}=$we[6];
      $hashWE_chro{$we[3]} = $we[0];
      $hashWE_sta{$we[3]} = $we[1];
      $hashWE_end{$we[3]} = $we[2];
      $hashWE_strand{$we[3]} = $we[5];
      $hashWE_coverage{$we[3]} = $we[7];
      $hashWE_len{$we[3]}=$we[8];
      $hashWE_rate{$we[3]} = $we[9];
    }
  }
  close WE;
  close WELT;

  open WI,"<","./calculate.unused.index/coverage.results/$wt.ref_add_nov_intron_coverage_results";
  while (<WI>){
    my @wi = split /\s+/, $_;
    if (exists $hashWE{$wi[3]}){
      $hashWI{$wi[3]}=$wi[6];
      $hashWI_chro{$wi[3]} = $wi[0];
      $hashWI_sta{$wi[3]} = $wi[1];
      $hashWI_end{$wi[3]} = $wi[2];
      $hashWI_strand{$wi[3]} = $wi[5];
      $hashWI_coverage{$wi[3]} = $wi[7];
      $hashWI_len{$wi[3]}=$wi[8];
      $hashWI_rate{$wi[3]} = $wi[9];
    }
  }
  close WI;

  open MI,"<", "./calculate.unused.index/coverage.results/$mut.ref_add_nov_intron_coverage_results";
  while (<MI>){
    my @mi = split /\s+/, $_;
    if (exists $hashWE{$mi[3]}){
      $hashMI{$mi[3]}=$mi[6];
      $hashMI_chro{$mi[3]} = $mi[0];
      $hashMI_sta{$mi[3]} = $mi[1];
      $hashMI_end{$mi[3]} = $mi[2];
      $hashMI_strand{$mi[3]} = $mi[5];
      $hashMI_coverage{$mi[3]} = $mi[7];
      $hashMI_len{$mi[3]}=$mi[8];
      $hashMI_rate{$mi[3]} = $mi[9];
    }
  }
  close MI;

  open ME,"<","./calculate.unused.index/coverage.results/$mut.ref_add_nov_exon_coverage_results";
  open WES,">","./calculate.unused.index/$wt.and.$mut.statistic/$wt.ref_add_nov_exon_a_ge5_c_eq0_coverage_results";
  open WIS, ">","./calculate.unused.index/$wt.and.$mut.statistic/$wt.ref_add_nov_intron_a_ge5_c_eq0_coverage_results";
  open MIS, ">", "./calculate.unused.index/$wt.and.$mut.statistic/$mut.ref_add_nov_intron_a_ge5_c_eq0_coverage_results";
  open MES, ">", "./calculate.unused.index/$wt.and.$mut.statistic/$mut.ref_add_nov_exon_a_ge5_c_eq0_coverage_results";
  open MESS, ">", "./calculate.unused.index/$wt.and.$mut.statistic/$wt.and.$mut.ref_add_nov_a_ge5_c_eq0_statistics_results";

  open WESS,">","./calculate.unused.index/$wt.and.$mut.statistic/$wt.ref_add_nov_exon_a_ge5_c_ne0_coverage_results";
  open WISS, ">","./calculate.unused.index/$wt.and.$mut.statistic/$wt.ref_add_nov_intron_a_ge5_c_ne0_coverage_results";
  open MISS, ">", "./calculate.unused.index/$wt.and.$mut.statistic/$mut.ref_add_nov_intron_a_ge5_c_ne0_coverage_results";
  open MESSS, ">", "./calculate.unused.index/$wt.and.$mut.statistic/$mut.ref_add_nov_exon_a_ge5_c_ne0_coverage_results";
  open MESSSS, ">", "./calculate.unused.index/$wt.and.$mut.statistic/$wt.and.$mut.ref_add_nov_a_ge5_c_ne0_statistics_results";
  while (<ME>){
    my @me = split /\s+/,$_;
    if (exists $hashWE{$me[3]}){
      if ($me[6]==0){
        print WES "$hashWE_chro{$me[3]}\t$hashWE_sta{$me[3]}\t$hashWE_end{$me[3]}\t$me[3]\t.\t$hashWE_strand{$me[3]}\t$hashWE{$me[3]}\t$hashWE_coverage{$me[3]}\t$hashWE_len{$me[3]}\t$hashWE_rate{$me[3]}\n";
        print WIS "$hashWI_chro{$me[3]}\t$hashWI_sta{$me[3]}\t$hashWI_end{$me[3]}\t$me[3]\t.\t$hashWI_strand{$me[3]}\t$hashWI{$me[3]}\t$hashWI_coverage{$me[3]}\t$hashWI_len{$me[3]}\t$hashWI_rate{$me[3]}\n";
        print MIS "$hashMI_chro{$me[3]}\t$hashMI_sta{$me[3]}\t$hashMI_end{$me[3]}\t$me[3]\t.\t$hashMI_strand{$me[3]}\t$hashMI{$me[3]}\t$hashMI_coverage{$me[3]}\t$hashMI_len{$me[3]}\t$hashMI_rate{$me[3]}\n";
        print MES $_;
        $a= $hashWE{$me[3]};
        $b= $hashWI{$me[3]};
        $c= $me[6];
        $d= $hashMI{$me[3]};
        print MESS "$me[0]\t$me[3]\t$me[5]\ta=$a\tb=$b\tc=$c\td=$d\n";
      }
      else{
        print WESS "$hashWE_chro{$me[3]}\t$hashWE_sta{$me[3]}\t$hashWE_end{$me[3]}\t$me[3]\t.\t$hashWE_strand{$me[3]}\t$hashWE{$me[3]}\t$hashWE_coverage{$me[3]}\t$hashWE_len{$me[3]}\t$hashWE_rate{$me[3]}\n";
        print WISS "$hashWI_chro{$me[3]}\t$hashWI_sta{$me[3]}\t$hashWI_end{$me[3]}\t$me[3]\t.\t$hashWI_strand{$me[3]}\t$hashWI{$me[3]}\t$hashWI_coverage{$me[3]}\t$hashWI_len{$me[3]}\t$hashWI_rate{$me[3]}\n";
        print MISS "$hashMI_chro{$me[3]}\t$hashMI_sta{$me[3]}\t$hashMI_end{$me[3]}\t$me[3]\t.\t$hashMI_strand{$me[3]}\t$hashMI{$me[3]}\t$hashMI_coverage{$me[3]}\t$hashMI_len{$me[3]}\t$hashMI_rate{$me[3]}\n";
        print MESSS $_;
        $a= $hashWE{$me[3]};
        $b= $hashWI{$me[3]};
        $c= $me[6];
        $d= $hashMI{$me[3]};
        $e= ($b+2)/($a+2);
        $f= ($d*$a/$c+2)/($a+2);
        $value1 = $f/$e;
        $value2 = $f-$e;
        print MESSSS "$me[0]\t$me[3]\t$me[5]\ta=$a\tb=$b\tc=$c\td=$d\te=$e\tf=$f\t$value1\t$value2\n";
     }
   }
  }
  close ME;
  close WES;
  close WIS;
  close MIS;
  close MES;
  close MESS;
  close WESS;
  close WISS;
  close MISS;
  close MESSS;
  close MESSSS;
}
