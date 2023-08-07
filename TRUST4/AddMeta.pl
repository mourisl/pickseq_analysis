#!/usr/bin/env perl

use strict ;
use warnings ;

die "usage: a.pl meta.csv trust_airr.tsv\n" if (@ARGV == 0) ;

my %meta ;
open FP, $ARGV[0] ;
my $header = <FP> ;
while (<FP>)
{
  chomp ;
  my @cols = split /,/ ;
  $meta{$cols[0]} = $cols[5]."_".$cols[6] ;
}
close FP ;

open FP, $ARGV[1] ;
$header = <FP> ;
chomp $header ;
print $header."\tmeta\n" ;
while (<FP>)
{
  chomp ;
  my $line = $_ ;
  my @cols = split /\t/, $line ;
  my @subCols = split /_/, $cols[0] ;
  my $sampleIdCol = 5 ; 
  $sampleIdCol = 3 if ($subCols[0] eq "batch2") ;
  ++$sampleIdCol if ($cols[0] =~ /Normal_B/) ;
  my $key = $subCols[0]."_".$subCols[$sampleIdCol] ;
  
  if (!defined $meta{$key}) 
  {
    print STDERR "Missing key: $key\n" ;
    next ;
  }
  print $line."\t".$meta{$key}."\n" ;
}
close FP ;
