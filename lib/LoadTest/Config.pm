package LoadTest::Config;

use namespace::autoclean;
use Moose;
use YAML::Syck;

has 'configFile' => (
    is => 'ro',
    isa => 'FileHandle'
);

has 'configData' => (
    is => 'rw',
    isa => 'HashRef'
    );

sub BUILD {
    my $self = shift;

    my %data = LoadFile($self->{configFile});

    $self->configData(\%data);
    $self->configFile->close();
}

__PACKAGE__->meta->make_immutable;

1;

