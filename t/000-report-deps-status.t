#!/usr/local/bin/perl

use 5.008003;

use strict;
use warnings FATAL => 'all';
#use diagnostics;

BEGIN {
    use FindBin;
    chdir "$FindBin::RealBin/..";
}

use Config ();

use Data::Dump; # XXX
#use Carp qw();

$|=1;
################################################################################

use Test::More;

BEGIN {
    for (qw/Module::Info Parse::CPAN::Meta/) {
        unless (eval "use $_; 1") {
            plan skip_all => "$_ required";
            exit;
        }
    }
}

my $meta = -e 'META.json' ? 'META.json'
         : -e 'META.yml'  ? 'META.yml'
         :                  '';

unless ($meta) {
    plan skip_all => "No META file found";
    exit;
}

my $distmeta = Parse::CPAN::Meta->load_file($meta);
my $prereqs  = $distmeta->{prereqs};

my @reqs;
for my $phase (keys %$prereqs) {
    for my $req (keys %{$prereqs->{$phase}{requires}}) {
        my $ver_req = $prereqs->{$phase}{requires}{$req} || 'any';

        my $mod      = Module::Info->new_from_module($req);
        my $ver_inst = ($mod ? $mod->version : '');
        $ver_inst = 'undef' unless defined $ver_inst;

        push @reqs, [ $req, $phase, $ver_req, $ver_inst ];
    }
}

@reqs = sort { lc $a->[0] cmp lc $b->[0] } @reqs;

diag <<EOP;

Module prereq report

perl: $Config::Config{version}
arch: $Config::Config{archname}
os  : $Config::Config{osname} $Config::Config{osvers}

Data obtained from $meta

EOP

my $format = join " ", qw/%-30s  %-10s %-10s %-10s/, "\n";
diag sprintf $format,  qw/Module Phase Need  Got/;

diag sprintf $format, @$_
  for @reqs;

pass;

done_testing;
