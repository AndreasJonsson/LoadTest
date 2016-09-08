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

    $self->{tmpfile_fh}->print(<<EOF);
open arkdes.kreablo.se:9999
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
