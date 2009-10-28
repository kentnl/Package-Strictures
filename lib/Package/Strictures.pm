use strict;
use warnings;

package Package::Strictures;

# ABSTRACT: Facilitate toggling validation code at users request, without extra performance penalties.


=head1 DESCRIPTION

Often, I find myself in a bind, where I have code I want to do things properly, so it will detect
of its own accord ( at runtime ) misuses of varying data-structures or methods, but the very same
tools that would be used to analysse and assure that things are going correctly, result in substantial
performance penalties.

This module, and the infrastructure I hope builds on top of it, may hopefully provide an 'in' that lets me have the best of both worlds,
fast on the production server, and concise when trying to debug it ( that is, not having to manually desk-check the whole execution cycle
through various functions and modules just to find which level things are going wrong at ).

In an ideal world, code would be both fast and concise, however, that is a future fantasy, and this here instead aims to produce 80% of the same
beneifts, but now, instead of never.

=head1 SYNOPSIS

=head2 IMPLEMENTING MODULES

  package Foo::Bar::Baz;

  use Package::Strictures::Register -setup => {
      -strictures => {
          STRICT => {
            default => ''¸
          },
      },
  };

  if( STRICT ) {
    /* Elimintated Code */
  }

=head2 CONSUMING USERS

  use Package::Strictures -for => {
    'Foo::Bar::Baz' => {
      'STRICT' => 1,
    },
  };

  use Foo::Bar::Baz;

  /* Previously eliminated code now runs.


=cut


1;

