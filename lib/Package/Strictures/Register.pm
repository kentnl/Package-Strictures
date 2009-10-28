use strict;
use warnings;

package Package::Strictures::Register;

use Sub::Install ();
use Carp         ();

# ABSTRACT: Create compile-time constants that can be tweaked by users with Package::Strictures.

sub import {
  my ( $self, %params ) = @_;

  unless (%params) {
    Carp::carp( __PACKAGE__ . " called with no parameters, skipping magic" );
    return;
  }
  my (@caller) = caller();
  my $package = $caller[0];
  $package = $params{-for} if exists $params{-for};

  my %config;

  if ( not exists $params{-setup} ) {
    Carp::croak("Can't setup strictures for package '$package', need -setup ");
  }

  %config = %{$params{-setup}};

  $config{-strictures} = {} unless exists $config{-strictures};

  my $reftype = ref $config{-strictures};

  if ( not $reftype eq 'HASH' ) {
    Carp::croak( qq/Can't handle anything except a HASH ( Got $reftype )/
        . qq/ for param -setup => { -strictures =>  } in -setup for $package/ );
  }
  my $subs = $self->create_coderefs( $config{-strictures}, $package );

}

sub create_coderefs {
  my ( $self, $strictures, $target ) = @_;
  for my $subname ( keys %{$strictures} ) {
    my $code = sub() { 0 };
    {
      no strict 'refs';
      *{$target . '::' . $subname } = $code;
    }

  }
}


1;

