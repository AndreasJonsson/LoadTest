package LoadTest::Step::SearchSelectTitle;

use namespace::autoclean;
use Moose;
use Carp;
use WWW::Mechanize;
use Data::Dumper;

extends 'LoadTest::Step';

has 'titlenumber' => (
    is => 'rw',
    isa => 'Int'
    );


sub BUILD {
    my $self = shift;

    $self->titlenumber( $self->config->{configData}->{searchselecttitle}->{titlenumber}  );
}

sub runStep {
    my $self = shift;

    return $self->mech->follow_link( class => 'title', 'n' => $self->titlenumber );
}

__PACKAGE__->meta->make_immutable;

1;
