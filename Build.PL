use strict;
use warnings;

require 5.00601;

use Module::Build;

my $builder = Module::Build->new
    ( module_name        => 'MooseX::PrivateSetters',
      license            => 'perl',
      requires           => { 'Moose' => '0.84',
                            },
      build_requires     => { 'Test::More' => '0',
                            },
      configure_requires => { 'Module::Build' => '0',
                            },
      create_makefile_pl => 'traditional',
      create_readme      => 1,
    );

$builder->create_build_script();
