use strict;
use warnings;

package Package::Strictures::Registry;
BEGIN {
  $Package::Strictures::Registry::AUTHORITY = 'cpan:KENTNL';
}
{
  $Package::Strictures::Registry::VERSION = '0.01001319';
}

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
  if ( not $self->has_value( $package, $name ) ) {
    Carp::croak("Error: package `$package` is not in the registry");
  }
  return $self->_get_package($package)->{$name};
}


sub set_value {
  my ( $self, $package, $name, $value ) = @_;
  if ( not $self->_has_package($package) ) {
    $self->_set_package( $package, {} );
  }
  $self->_get_package($package)->{$name} = $value;
  return;
}

no Moose;

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Package::Strictures::Registry - Data Storage name-space for stricture parameters.

=head1 VERSION

version 0.01001319

=head1 METHODS

=head2 advertise_value

  Package::Strictures::Registry->advertise_value( 'Some::Package', "STRICT");

An informational data-storage for developers to see what packages that are loaded have strictures that are able to be tuned, without having to grok the source.

Note that by the time you see this value, it is already too late to try setting it.

=head2 has_value

  Package::Strictures::Registry->has_value( 'Some::Package', 'STRICT' )

Sees if somebody ( A developer ) has defined an override value for the stricture.

This will be picked up by a performing package when somebody first use/require's it.

=head2 get_value

  Package::Strictures::Registry->get_value('Some::Package' , 'STRICT' )

Returns the value stored earlier if there was one.

This is done internally by L<Package::Strictures::Register> to populate the values for the compile-time constants.

=head2 set_value

  Package::Strictures::Registry->set_value('Some::Package', 'STRICT' , 1 );

Sets a default value override for C<Some::Package> to pick up when it compiles.

Note: This B<MUST> be performed prior to compile-time, or it won't affect the module B<AT ALL>

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Kent Fredric.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
