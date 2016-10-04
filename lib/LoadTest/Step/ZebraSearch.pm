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

package LoadTest::Step::ZebraSearch;

use namespace::autoclean;
use Moose;
use Carp;

use File::Temp;

extends 'LoadTest::Step';

has 'searchterm' => (
    is => 'rw',
    isa => 'Str'
    );


sub BUILD {
    my $self = shift;

    $self->{tmpfile_fh} = File::Temp->new( UNLINK => 1 );

    $self->searchterm( $self->config->{configData}->{search}->{searchterm}  );

    my $searchterm = $self->searchterm;

    die "Fix hardcoded hostname!"

    $self->{tmpfile_fh}->print(<<EOF);
open hostname:9999
base biblios
find "$searchterm"
show 1+20
quit
EOF
    $self->{tmpfile_fh}->close();
}

sub runStep {
    my $self = shift;

    my $tmpfilename = $self->{tmpfile_fh}->filename;

    system( "yaz-client -c ccl.properties -f $tmpfilename >/dev/null" );

    return HTTP::Response->new( 200 );
}

__PACKAGE__->meta->make_immutable;

1;
