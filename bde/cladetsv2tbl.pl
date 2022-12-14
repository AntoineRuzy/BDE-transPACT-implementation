#!/bin/env perl

use strict;
use warnings;


my %kscount = ();
my %clustks = ();
open my $cfh, '<', '647KS_annotation.clades.tsv' or die $!;
my $n = 0;
while(<$cfh>){
    chomp;
    my ($query, $clade) = split(/\t/, $_);
    $query =~ s/^q_//;
    my @q = split(/\|/, $query);
    my $ks = $q[-1];
    $ks =~ s/-$//;
    $ks = 'KS5' if($ks eq 'KS55'); # 9-methylstreptimidone_KS55
    my $clust = join('|', @q[0..$#q-1]);

    $kscount{$ks} += 1;
    $clustks{$clust}{$ks} = $clade;
    $n += 1;
}
close $cfh;

#foreach my $ks (sort keys %kscount){
#    print join("\t", $ks, $kscount{$ks})."\n";
#}

## Reg = 1..38
## b = 1..4
my @order = ();
foreach my $n (1..38){
    push @order, 'KS'.$n;
}
foreach my $n (1..4){
    push @order, 'KS'.$n.'b';
}
print "\t".join("\t", @order)."\n";
foreach my $clust (sort keys %clustks){
    print "$clust";
    foreach my $ks (@order){
	if(exists $clustks{$clust}{$ks}){
	    print "\t".$clustks{$clust}{$ks};
	}else{
	    print "\tNA";
	}
    }
    print "\n";
}
