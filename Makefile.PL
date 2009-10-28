
use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  DISTNAME  => 'Package-Strictures',
  NAME      => 'Package::Strictures',
  AUTHOR    => "Kent\ Fredric\ \<kentnl\@cpan\.org\>",
  ABSTRACT  => "Facilitate\ toggling\ validation\ code\ at\ users\ request\,\ without\ extra\ performance\ penalties\.",
  VERSION   => '0.01000007',
  EXE_FILES => [ qw() ],
  (eval { ExtUtils::MakeMaker->VERSION(6.31) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM    => {
    "Test::Exception" => '0.27',
    "B::Deparse" => '0',
    "FindBin" => '0',
    "Carp" => '0',
    "Test::More" => '0',
    "Config::INI::Reader" => '0.014',
    "MooseX::ClassAttribute" => '0.10',
    "Moose" => '0.92',
  },
  test => {TESTS => 't/*.t'}
);

