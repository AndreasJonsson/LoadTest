package LoadTest::Step::KohaOpacLogin;

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

    $self->userid  ($self->config->{configData}->{login}->{userid}  );
    $self->password($self->config->{configData}->{login}->{password});
}

sub runStep {
    my $self = shift;

    my $resp = $self->mech->submit_form( 'form_id' => 'auth',
                                         'fields' => {
                                             'userid' => $self->userid,
                                             'password' => $self->password
                                         } );

    my $logoutLink = $self->mech->find_link( 'id' => 'logout' );

    if (!defined($logoutLink)) {
        croak "Login failed!";
    }

    return $resp;
}

__PACKAGE__->meta->make_immutable;

1;

