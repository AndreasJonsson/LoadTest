package LoadTest::Step::CirculateSelectPatron;

use namespace::autoclean;
use Moose;
use Carp;
use WWW::Mechanize;
use Data::Dumper;

extends 'LoadTest::Step';

has 'borrower_cardnumber' => (
    is => 'rw',
    isa => 'Str'
    );

sub BUILD {
    my $self = shift;

    $self->borrower_cardnumber( $self->config->{configData}->{circulation}->{borrower_cardnumber}  );
}

sub runStep {
    my $self = shift;

    my $form_n = $self->form_by_action('/circulation.pl');

    die "No circulation form!" unless defined($form_n);

    return $self->mech->submit_form( 'form_number' => $form_n, 'fields' => { 'findborrower' => $self->borrower_cardnumber } );
}

__PACKAGE__->meta->make_immutable;

1;
