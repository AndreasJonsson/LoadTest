
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
    is => 'rw',
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

has 'mech' => (
    is => 'ro',
    isa => 'WWW::Mechanize'
    );

has 'scenarioConf' => (
    is => 'ro',
    isa => 'HashRef'
    );

sub BUILD {
    my $self = shift;

}

sub run {
    my $self = shift;

    my $th = threads->create('_run', $self);

    $self->{th} = $th;
}

sub _run {
    my $self = shift;

    my $startTime = time();

    foreach my $step (@{$self->{steps}}) {
        $step->scenario($self);
        $step->run();
        if (defined($self->scenarioConf->{timelimit}) &&
             time() - $startTime > $self->scenarioConf->{timelimit} ) {
            last;
        }
    }

    if (defined($self->scenarioConf->{timelimit})) {
        my $start = defined($self->scenarioConf->{repeat_from}) ? $self->scenarioConf->{repeat_from} : 0;
        my $i = $start;
        while ( time() - $startTime <= $self->scenarioConf->{timelimit} ) {
            my $step = $self->{steps}->[$i];
            $step->run();
            if (++$i >= scalar(@{$self->{steps}}) ) {
                $i = $start;
            }
        }
    }
}

sub join {
    my $self = shift;
    return $self->{th}->join();
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
