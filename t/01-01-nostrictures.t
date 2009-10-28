use strict;
use warnings;

use Test::More tests => 5;
use Test::Exception;
use B::Deparse;
use FindBin;
use lib "$FindBin::Bin/01-poc-lib";

BEGIN { use_ok('Example'); }

lives_and { is Example::slow(), 5 } 'Method using strictures execute and return values';
lives_and { is Example::slow(5), 5 } 'Method using strictures dont execute validation blocks';

my $deparse = B::Deparse->new();

my $code = $deparse->coderef2text( Example->can('slow') );

unlike( $code, qr/if\s*\(\s*STRICT\s*\)\s*{/, 'Stricture constant is eliminated from code' );
unlike( $code, qr/die\s*['"]/, 'Stricture code is eliminated from code' );

