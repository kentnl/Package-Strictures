
use strict;
use warnings;

use Module::Build;

my $build = Module::Build->new(
  module_name   => 'Package::Strictures',
  license       => 'perl',
  dist_abstract => "Facilitate\ toggling\ validation\ code\ at\ users\ request\,\ without\ extra\ performance\ penalties\.",
  dist_name     => "Package\-Strictures",
  dist_author   => [
"Kent\ Fredric\ \<kentnl\@cpan\.org\>",
  ],
  requires      => {
    "Test::Exception" => '0.27',
    "namespace::autoclean" => '0.9',
    "B::Deparse" => '0',
    "FindBin" => '0',
    "Carp" => '0',
    "Test::More" => '0',
    "Config::INI::Reader" => '0.014',
    "MooseX::ClassAttribute" => '0.10',
    "Moose" => '0.92',
  },
  script_files => [ qw() ],
);

$build->create_build_script;
