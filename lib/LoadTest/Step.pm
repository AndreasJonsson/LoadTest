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

package LoadTest::Step;

use Moose;
use Modern::Perl;
use WWW::Mechanize;
use HTTP::Response;
use Time::HiRes qw(usleep);
use Carp;
use Data::Dumper;
use Number::Format;

has 'id' => (
    is => 'ro',
    isa => 'Str'
    );

has 'scenario' => (
    is => 'rw',
    isa => 'LoadTest::Scenario',
    handles => {
        'tid' => 'id',
        'mech' => 'mech',
        'stats' => 'stats',
        'config' => 'config' }
    );

has 'delay_distribution' => (
    is => 'ro',
    isa => 'CodeRef'
    );

has 'opac_uri' => (
    is => 'rw',
    isa => 'Str'
    );

has 'intra_uri' => (
    is => 'rw',
    isa => 'Str'
    );

sub BUILD {
    my $self = shift;

    $self->opac_uri($self->config->{configData}->{opac_uri});
    $self->intra_uri($self->config->{configData}->{intra_uri});

    $self->{nf} = new Number::Format();
}

sub _wait {
    my $self = shift;
    my $t = $self->{delay_distribution}->();

    print STDERR "Waiting " . $self->id . " " . $self->{nf}->format_number($t/1e6) . "s\n";

    usleep($t);
}

sub run {
    my $self = shift;

    $self->_wait();

    $self->stats->start($self->scenario->id, $self->id);
    my $resp = $self->runStep();
    $self->stats->stop($self->scenario->id, $self->id);

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

sub form_by_action {
    my $self = shift;
    my $action = shift;

    my $action_re = quotemeta($action) . '$';
    my $n = 1;

    for my $f ($self->mech->forms) {
        my $form = $self->mech->form_number( $n );
        if ($form->action =~ /$action_re/) {
            return $n;
        }
        $n++
    }

    return undef;
}


__PACKAGE__->meta->make_immutable;

no Moose;

1;
