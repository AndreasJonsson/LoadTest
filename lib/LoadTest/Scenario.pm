#
# Copyright 2016  Andreas Jonsson
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
