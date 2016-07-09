#!/usr/bin/env perl

use Modern::Perl;
use strict;
use WWW::Mechanize;
use Data::Dumper::Concise;

use LoadTest::Statistics;
use LoadTest::Scenario;

open(my $fh, ">", "logfile.log");

my $stats = LoadTest::Statistics->new('fh' => $fh);
my $scenario = LoadTest::Scenario->new('id' => 'test',
                                       'steps' => [],
                                       'stats' => $stats);


#my $mech = WWW::Mechanize->new();

#say Dumper($mech);

#$mech->get('https://arkdes.kreablo.se');

