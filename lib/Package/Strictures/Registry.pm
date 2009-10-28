use strict;
use warnings;

package Package::Strictures::Registry;

# ABSTRACT: Data Storage namespace for stricture parameters.

use MooseX::Singleton;
use MooseX::Types::Moose qw( :all );


__PACKAGE__->meta->make_immutable;
1;

