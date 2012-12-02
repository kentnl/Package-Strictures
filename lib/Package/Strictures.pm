use strict;
use warnings;

package Package::Strictures;
BEGIN {
  $Package::Strictures::AUTHORITY = 'cpan:KENTNL';
}
{
  $Package::Strictures::VERSION = '0.01001319';
}

use Package::Strictures::Registry;
use Carp ();

# ABSTRACT: Facilitate toggling validation code at users request, without extra performance penalties.



sub import {
  my ( $self, %params ) = @_;
  if ( not %params ) {
    Carp::carp( __PACKAGE__ . ' called with no parameters, skipping magic' );
    return;
  }
  if ( ( not exists $params{-for} ) && ( not exists $params{-from} ) ) {
    Carp::croak( 'no -for or -from parameter to ' . __PACKAGE__ );
  }
  if ( exists $params{-for} ) {
    $self->_setup_for( $params{-for} );
    return;
  }
  if ( exists $params{-from} ) {
    $self->_setup_from( $params{-from} );
    return;
  }
  Carp::croak('Ugh!?');
}

sub _setup_for {
  my ( $self, $params ) = @_;
  my $reftype = ref $params;
  if ( $reftype ne 'HASH' ) {
    Carp::croak("-for presently only takes HASH, got `$reftype`");
  }
  for my $package ( keys %{$params} ) {
    $self->_setup_for_package( $params->{$package}, $package );
  }
  return;
}

sub _setup_from {
  my ( $self, $from ) = @_;
  my $reftype = ref $from;
  if ($reftype) {
    Carp::croak("-from can only take a scalar, not a ref, got `$reftype`");
  }
  if ( $from =~ qr{\.ini$} ) {
    $self->_setup_from_ini($from);
    return;
  }
  Carp::croak('Only know how to load setup from .ini files at present');
  return;
}

sub _setup_from_ini {
  my ( $self, $from ) = @_;
  require Config::INI::Reader;
  my ($conf) = Config::INI::Reader->read_file($from);
  if ( exists $conf->{'_'} ) {
    Carp::carp("Strictures not addressed at a package found in `$from`");
  }
  $self->_setup_for($conf);
  return;
}

sub _setup_for_package {
  my ( $self, $params, $package ) = @_;
  my $reftype = ref $params;
  if ( $reftype ne 'HASH' ) {
    Carp::croak("-for => { Some::Name => X } presently only takes HASH, got `$reftype` on package `$package` ");
  }
  for my $value ( keys %{$params} ) {
    Package::Strictures::Registry->set_value( $package, $value, $params->{$value} );
  }
  return;
}

1;

__END__

=pod

=head1 NAME

Package::Strictures - Facilitate toggling validation code at users request, without extra performance penalties.

=head1 VERSION

version 0.01001319

=head1 SYNOPSIS

=head2 IMPLEMENTING MODULES

  package Foo::Bar::Baz;

  use Package::Strictures::Register -setup => {
      -strictures => {
          STRICT => {
            default => ''
          },
      },
  };

  if( STRICT ) {
    /* Elimintated Code */
  }

See L<Package::Strictures::Register> for more detail.

=head2 CONSUMING USERS

  use Package::Strictures -for => {
    'Foo::Bar::Baz' => {
      'STRICT' => 1,
    },
  };

  use Foo::Bar::Baz;

  /* Previously eliminated code now runs.

=head1 DESCRIPTION

Often, I find myself in a bind, where I have code I want to do things properly, so it will detect
of its own accord ( at run time ) misuses of varying data-structures or methods, but the very same
tools that would be used to analyse and assure that things are going correctly, result in substantial
performance penalties.

This module, and the infrastructure I hope builds on top of it, may hopefully provide an 'in' that lets me have the best of both worlds,
fast on the production server, and concise when trying to debug it ( that is, not having to manually desk-check the whole execution cycle
through various functions and modules just to find which level things are going wrong at ).

In an ideal world, code would be both fast and concise, however, that is a future fantasy, and this here instead aims to produce 80% of the same
benefits, but now, instead of never.

=head1 MINOR WARNING

This code is pretty fresh. Its been done to death with T.D.D., and does everything I want it to, but there's always bugs.

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Kent Fredric.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
