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

package LoadTest::Statistics;

use Moose;
use Modern::Perl;
use IO::Handle;
use IO::File;
use Fcntl qw(:DEFAULT :flock);
use Carp;
use Time::HiRes qw(gettimeofday);
use Math::BigInt;

has 'fh' => (
    is => 'ro',
    isa => 'FileHandle'
    );

has 'id' => (
    is => 'ro',
    isa => 'Str'
    );

use constant {
    INACTIVE => 0,
    ACTIVE   => 1
};

sub BUILD {
    my $self = shift;

    $self->{ts} = 0;
    $self->{us} = 0;

    $self->{state} = INACTIVE;
}

sub start {
    my $self = shift;
    my $scenario_id = shift;
    my $step_id = shift;

    if ($self->{state} != INACTIVE) {
        croak "start called in wrong state! (scenario_id: $scenario_id, step_id: $step_id)";
    }
    $self->{state} = ACTIVE;
    ($self->{ts}, $self->{us}) = gettimeofday;
}

sub _toBigInt {
    my ($ts, $us) = @_;
    my $t = Math::BigInt->new($ts);
    $t->bmul(1000000);
    $t->badd($us);
    return $t;
}

sub stop {
    my $self = shift;
    my $scenario_id = shift;
    my $step_id = shift;

    if ($self->{state} != ACTIVE) {
        croak "stop called in wrong state! (scenario_id: $scenario_id, step_id: $step_id)";
    }
    $self->{state} = INACTIVE;
    (my $ts, my $us) = gettimeofday;
    my $t1 = _toBigInt($self->{ts}, $self->{us});
    my $t2 = _toBigInt($ts, $us);
    my $diff = $t2->bsub($t1);
    $self->_lock();
    $self->{fh}->say($scenario_id . ' ' . $step_id . ' '. $diff);
    $self->_unlock();
}

sub _lock {
    my $self = shift;

    $self->fh->fcntl( LOCK_EX, 0 );
}

sub _unlock {
    my $self = shift;

    $self->fh->fcntl( LOCK_UN, 0 );
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
