package LoadTest::Step::IntraSearch;

use namespace::autoclean;
use Moose;
use Carp;
use WWW::Mechanize;
use Data::Dumper;

extends 'LoadTest::Step';

has 'searchterm' => (
    is => 'rw',
    isa => 'Str'
    );


sub BUILD {
    my $self = shift;

    $self->searchterm( $self->config->{configData}->{intrasearch}->{searchterm}  );
}

sub runStep {
    my $self = shift;

    return $self->mech->submit_form( 'with_fields' => { 'q' => $self->searchterm } );
}

__PACKAGE__->meta->make_immutable;

1;