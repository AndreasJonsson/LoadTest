package LoadTest::Step;

use Moose;
use Modern::Perl;
use WWW::Mechanize;
use HTTP::Response;
use Time::HiRes qw(usleep);
use Carp;

has 'id' => (
    is => 'ro',
    isa => 'Str'
    );

has 'scenario' => (
    is => 'rw',
    isa => 'LoadTest::Scenario',
    handles => {
        'tid' => 'id',
        'mechanize' => 'mechanize',
        'stats' => 'stats',
        'config' => 'config' }
    );

has 'mech' => (
    is => 'ro',
    isa => 'WWW::Mechanize',
    );

has 'delay_distribution' => (
    is => 'ro',
    isa => 'CodeRef'
    );

sub BUILD {
    my $self = shift;
}

sub _wait {
    my $self = shift;
    my $t = $self->{delay_distribution}->();
    usleep($t);
}

sub run {
    my $self = shift;

    $self->_wait();

    $self->stats->start();
    my $resp = $self->runStep();
    $self->stats->stop();

    $self->checkResp( $resp );
}

sub checkResp {
    my $self = shift;
    my $resp = shift;
    if ($resp->code != 200) {
        carp "Response code: " . $resp->code;
    }
}

sub runStep {
    my $self = shift;
    say $self->tid . " step " . $self->id . " running";
    return HTTP::Response->new( 200 );
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
