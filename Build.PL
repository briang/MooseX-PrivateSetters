use strict;
use warnings;

require 5.008003;

use Module::Build;

my $builder = Module::Build->new(
    build_requires     => { 'Test::More'    => '0', },
    configure_requires => { 'Module::Build' => '0', },
    create_makefile_pl => 'traditional',
    create_readme      => 1,
    license            => 'perl',
    meta_merge         => {
        resources      => {
            repository => 'http://github.com/briang/MooseX-PrivateSetters'
        }
    },
    module_name        => 'MooseX::PrivateSetters',
    recommends         => {
        'Config'            => 0,
        'FindBin'           => 0,
        'Module::CoreList'  => 0,
        'Module::Info'      => 0,
        'Parse::CPAN::Meta' => 0,
    },
    requires           => {
        'perl'                  => '5.8.3',
        'Moose'                 => 0.94,
        'Moose::Exporter'       => 0.94,
        'Moose::Role'           => 0.94,
        'Moose::Util::MetaRole' => 0.94,
    },
);

$builder->create_build_script();
