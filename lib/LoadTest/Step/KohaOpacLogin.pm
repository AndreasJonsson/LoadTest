package LoadTest::Step::KohaOpacLogin;

use namespace::autoclean;
use Moose;
use WWW::Mechanize;

extends 'LoadTest::Step';

sub runStep {
    my $self = shift;

    
}

__PACKAGE__->meta->make_immutable;

1;

