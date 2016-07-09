
package LoadTest::Scenario;

use Moose;
use Modern::Perl;
use threads;
use strict;

has 'id' => (
    is => 'ro',
    isa => 'Str'
    );

has 'steps' => (
    is => 'ro',
    isa => 'ArrayRef[LoadTest::Step]'
    );

has 'stats' => (
    is => 'ro',
    isa => 'LoadTest::Statistics'
    );

sub BUILD {
    my $self = shift;

    my $th = threads->create('init', $self);

    $self->{mech} = WWW::Mechanize->new();

    $self->{th} = $th;
}

sub init {
    my $self = shift;
}

sub join {
    my $self = shift;
    return $self->{th}->join();
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
