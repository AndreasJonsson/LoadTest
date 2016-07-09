package LoadTest::Step;

use Moose;
use Modern::Perl;
use WWW::Mechanize;

has 'mech' => (
    is => 'ro',
    isa => 'WWW::Mechanize'
    );

sub BUILD {
    my $self = shift;
}



__PACKAGE__->meta->make_immutable;

no Moose;

1;
