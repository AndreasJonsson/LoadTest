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

