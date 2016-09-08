package LoadTest::Step::IntraLogin;

use namespace::autoclean;
use Moose;
use Carp;
use WWW::Mechanize;
use Data::Dumper;

extends 'LoadTest::Step';

has 'userid' => (
    is => 'rw',
    isa => 'Str'
    );

has 'password' => (
    is => 'rw',
    isa => 'Str'
    );

sub BUILD {
    my $self = shift;

    $self->userid  ($self->config->{configData}->{intra_login}->{userid}  );
    $self->password($self->config->{configData}->{intra_login}->{password});
}

sub runStep {
    my $self = shift;

    my $resp = $self->mech->submit_form( 'form_id' => 'loginform',
                                         'fields' => {
                                             'userid' => $self->userid,
                                             'password' => $self->password
                                         } );

    my $circulationLink = $self->mech->find_link( 'class' => 'icon_general icon_circulation' );

    if (!defined($circulationLink)) {
        croak "Login failed!";
    }

    return $resp;
}

__PACKAGE__->meta->make_immutable;

1;

