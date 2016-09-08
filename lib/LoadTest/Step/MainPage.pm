package LoadTest::Step::MainPage;

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

    return $self->mech->get( $self->opac_uri . '/cgi-bin/koha/opac-main.pl' );
}

__PACKAGE__->meta->make_immutable;

1;
