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
use Module::CoreList ();

#use Data::Dump; # XXX
#use Carp qw();

use Test::More;

BEGIN {
    for (qw/Module::Info Parse::CPAN::Meta/) {
        unless (eval "use $_; 1") {
            plan skip_all => "$_ required";
            exit;
        }
    }
}

my $meta = -e 'META.json' ? 'META.json' : '';

unless ($meta) {
    plan skip_all => "No META file found";
    exit;
}

my $distmeta = Parse::CPAN::Meta->load_file($meta);
my $prereqs  = $distmeta->{prereqs};

my @reqs;
for my $phase (keys %$prereqs) {
    for my $type (keys %{$prereqs->{$phase}}) {
        for my $req (keys %{$prereqs->{$phase}{$type}}) {
            my $ver_req = $prereqs->{$phase}{$type}{$req} || 'any';

            my $mod      = Module::Info->new_from_module($req);
            my $ver_inst = ($mod ? $mod->version : '');
            $ver_inst = 'undef' unless defined $ver_inst;

            my $is_core = $Module::CoreList::version{$]}{$req} ? '  *' : '';
            $is_core = '  *' if $req eq 'Config';

            push @reqs, [ $is_core, $req, $phase, $type, $ver_req, $ver_inst ];
        }
    }
}

@reqs = sort { lc $a->[1] cmp lc $b->[1] } @reqs;

diag <<EOP;

Module prereq report

perl: $Config::Config{version}
arch: $Config::Config{archname}
os  : $Config::Config{osname} $Config::Config{osvers}

Data obtained from $meta

EOP

my @titles =           qw/Core? Module Phase Strength Need  Got/;
my $format = join " ", qw/%-5s  %-30s  %-10s %-12s    %-10s %-10s/, "\n";
diag sprintf $format, @titles;
diag sprintf $format, map { s/./-/g; $_ } @titles;

diag sprintf $format, @$_
  for @reqs;

pass;

done_testing;
