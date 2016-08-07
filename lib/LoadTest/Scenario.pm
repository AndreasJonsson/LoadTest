
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

has 'config' => (
    is => 'ro',
    isa => 'LoadTest::Config'
    );

sub BUILD {
    my $self = shift;

    my $th = threads->create('run', $self);

    $self->{mech} = WWW::Mechanize->new();

    $self->{th} = $th;
}

sub run {
    my $self = shift;

    foreach my $step (@{$self->{steps}}) {
        $step->scenario($self);
        $step->run();
    }
}

sub join {
    my $self = shift;
    return $self->{th}->join();
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
