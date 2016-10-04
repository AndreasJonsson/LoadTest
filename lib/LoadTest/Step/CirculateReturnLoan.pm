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

package LoadTest::Step::CirculateReturnLoan;

use namespace::autoclean;
use Moose;
use Carp;
use WWW::Mechanize;
use Data::Dumper;

extends 'LoadTest::Step';

has 'barcode' => (
    is => 'rw',
    isa => 'Str'
    );

sub BUILD {
    my $self = shift;

    $self->tid =~ /(\d+)$/;
    my $id = $1;


    $self->barcode( $self->config->{configData}->{circulation}->{barcodes}->[$id]  );
}

sub runStep {
    my $self = shift;

    my $form_n = $self->form_by_action('/returns.pl');

    die "No circulation form!" unless defined($form_n);

    return $self->mech->submit_form( 'form_number' => $form_n, 'fields' => { 'barcode' => $self->barcode } );
}

__PACKAGE__->meta->make_immutable;

1;
