package LoadTest::Statistics;

use Moose;
use Modern::Perl;
use IO::Handle;
use IO::File;
use Fcntl qw(:DEFAULT :flock);
use Carp;
use Time::HiRes qw(gettimeofday);

has 'fh' => (
    is => 'ro',
    isa => 'FileHandle'
    );

has 'id' => (
    is => 'ro',
    isa => 'String'
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

    if ($self->{state} != INACTIVE) {
        croak "start called in wrong state!";
    }
    $self->{state} = ACTIVE;
    ($self->{ts}, $self->{us}) = gettimeofday;
}

sub stop {
    my $self = shift;

    if ($self->{state} != ACTIVE) {
        croak "stop called in wrong state!";
    }
    $self->{state} = INACTIVE;
    (my $ts, my $us) = gettimeofday;
    my $us_diff = $us - $self->{us};
    my $ts_diff;
    if ($us_diff < 0) {
        $ts_diff = -1;
        $us_diff = 1000000 + $us_diff;
    } else {
        $ts_diff = 0;
    }
    $ts_diff += $ts - $self->{ts};
    say $self->{fh}, $self->id . ' ' . $ts_diff;
}

sub _lock {
    my $self = shift;

    $self->fh->fcntl( LOCK_EX );
}

sub _unlock {
    my $self = shift;

    $self->fh->fcntl( LOCK_UN );
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
