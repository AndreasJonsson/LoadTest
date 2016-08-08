package LoadTest::Step::KohaOpacLogin;

use namespace::autoclean;
use Moose;
use WWW::Mechanize;

extends 'LoadTest::Step';

sub runStep {
    my $self = shift;

    $self->mechanize->form_name( 'auth' );

    $self->mechanize->field( 'userid',   $self->config->{'login'}->{'userid'} );
    $self->mechanize->field( 'password', $self->config->{'login'}->{'password'} );

    return $self->mechanize->submit();
}

__PACKAGE__->meta->make_immutable;

1;

