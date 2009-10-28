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

  if ( not exists $params{-setup} ) {
    Carp::croak("Can't setup strictures for package '$package', need -setup ");
  }

  $self->_setup( $params{-setup}, $package );

}

sub _setup {
  my ( $self, $params, $package ) = @_;

  my $reftype = ref $params;

  if ( not $reftype eq 'HASH' ) {
    Carp::croak(qq/ -setup => can presently only support a HASH. Got '$reftype'/);
  }

  if ( ( not exists $params->{-strictures} ) && ( not exists $params->{-groups} ) ) {
    Carp::croak('Neither -setup => { -strictures }  or -setup => { -groups } provided.');
  }

  if ( exists $params->{-groups} ) {
    Carp::carp('-groups support is not yet implemented');
  }

  $params->{-strictures} = {} unless exists $params->{-strictures};
  $params->{-groups}     = {} unless exists $params->{-groups};

  $self->_setup_strictures( $params->{-strictures}, $package );

}

sub _setup_strictures {
  my ( $self, $strictures, $package ) = @_;
  my $reftype = ref $strictures;

  if ( not $reftype eq 'HASH' ) {
    Carp::croak( qq/Can't handle anything except a HASH ( Got $reftype )/
        . qq/ for param -setup => { -strictures =>  } in -setup for $package/ );
  }

  for my $subname ( keys %{$strictures} ) {

    $self->_setup_stricture( $strictures->{$subname}, $package, $subname );
  }
}

sub _setup_stricture {
  my ( $self, $prototype, $package, $name ) = @_;
  if ( not exists $prototype->{default} ) {
    Carp::croak("Prototype for `$package`::`$name` lacks a [required] ->{'default'} ");
  }

  $self->_advertise_stricture( $package, $name );
  my $value = $self->_fetch_stricture_value( $package, $name, $prototype->{default} );
  my $code = sub() { $value };
  {
    no strict 'refs';
    *{ $package . '::' . $name } = $code;
  }
}

sub _advertise_stricture {
  my ( $self, $package, $name ) = @_;

}

sub _fetch_stricture_value {
  my ( $self, $package, $name, $default ) = @_;

  return $default;
}

1;

