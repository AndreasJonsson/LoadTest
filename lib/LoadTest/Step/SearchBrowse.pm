package LoadTest::Step::SearchBrowse;

use namespace::autoclean;
use Moose;
use Carp;
use WWW::Mechanize;
use Data::Dumper;

extends 'LoadTest::Step';

has 'page' => (
    is => 'rw',
    isa => 'Int'
    );


sub BUILD {
    my $self = shift;

    $self->page( $self->config->{configData}->{searchbrowse}->{page}  );
}

sub runStep {
    my $self = shift;

    return $self->mech->follow_link( 'text' => $self->page );
}

__PACKAGE__->meta->make_immutable;

1;
