package LoadTest::Delay;

use strict;

use Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

$VERSION     = 1.00;
@ISA         = qw(Exporter);
@EXPORT      = qw(exponential);
@EXPORT_OK   = qw();

sub exponential {
    our $lambda = shift;

    return sub { return -(log(rand) / $lambda); };
}

1;
