package LoadTest::Step::IntraMainPage;

use namespace::autoclean;
use Moose;
use Carp;
use WWW::Mechanize;
use Data::Dumper;

extends 'LoadTest::Step';

sub BUILD {
    my $self = shift;
}

sub runStep {
    my $self = shift;

    return $self->mech->get( $self->intra_uri . '/cgi-bin/koha/mainpage.pl' );
}

__PACKAGE__->meta->make_immutable;

1;
