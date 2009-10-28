use strict;
use warnings;

package Package::Strictures::Registry;

# ABSTRACT: Data Storage name-space for stricture parameters.

use Moose;
use namespace::autoclean;
use MooseX::ClassAttribute;
use Carp ();

class_has '_registry_store' => (
  isa      => 'HashRef[ HashRef ]',
  init_arg => undef,
  is       => 'bare',
  default  => sub { +{} },
  traits   => [qw( Hash )],
  handles  => {
    _has_package => 'exists',
    _set_package => 'set',
    _get_package => 'get',
  },
);

class_has '_advertisments' => (
  isa      => 'HashRef[ HashRef ]',
  init_arg => undef,
  is       => 'bare',
  default  => sub { +{} },
  traits   => [qw( Hash )],
  handles  => {
    _has_advert => 'exists',
    _set_advert => 'set',
    _get_advert => 'get',
  },
);

sub advertise_value {
  my ( $self, $package, $name ) = @_;
  if ( not $self->_has_advert($package) ) {
    $self->_set_advert( $package, {} );
  }
  if ( not exists $self->_get_advert($package)->{$name} ) {
    $self->_get_advert($package)->{$name} = \$name;
  }
  else {
    Carp::croak("` $package :: $name` is already advertised!");
  }
  return;
}

sub has_value {
  my ( $self, $package, $name ) = @_;
  return unless ( $self->_has_package($package) );
  return exists $self->_get_package($package)->{$name};
}

sub get_value {
  my ( $self, $package, $name ) = @_;
  if ( not $self->has_value($package, $name ) ) {
    Carp::croak("Error: package `$package` is not in the registry");
  }
  return $self->_get_package($package)->{$name};
}

sub set_value {
  my ( $self, $package, $name, $value ) = @_;
  if ( not $self->_has_package( $package ) ){
    $self->_set_package( $package, {} );
  }
  $self->_get_package( $package )->{$name} = $value;
  return;
}

no Moose;

__PACKAGE__->meta->make_immutable;
1;

