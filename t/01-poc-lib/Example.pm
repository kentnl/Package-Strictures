package    # NO CPAN
  Example;

use strict;
use warnings;

use Package::Strictures::Register -setup => {
  -strictures => {
    'STRICT' => {
      default => '',
      type    => 'Bool',
      'ENV'   => 'EXAMPLE_STRICT',
    }
  },
  -groups => {
    '@all' => {
      members => [qw( STRICT )],
      ENV     => 'EXAMPLE_STRICT_ALL',
    }
  }
};

use namespace::autoclean;

sub slow {
  my $result = 5;

  if (STRICT) {

    # Simulate some slow validation.
    #
    sleep 1;

    if (@_) {
      die "slow() takes no parameters";
    }
  }
  return $result;
}

1;

