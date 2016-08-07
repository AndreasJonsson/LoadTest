#!/usr/bin/env perl

use Modern::Perl;
use strict;
use WWW::Mechanize;
use Data::Dumper::Concise;

use LoadTest::Statistics;
use LoadTest::Scenario;
use LoadTest::Step;
use LoadTest::Delay;
use LoadTest::Config;

open(my $fh, ">", "logfile.log");

open(my $configFh, "<", "config.yaml");

my $config = LoadTest::Config->new('configFile' => $configFh);

my $stats = LoadTest::Statistics->new('fh' => $fh, 'id' => 'stat1');
my $scenario1 = LoadTest::Scenario->new('id' => 'test1',
                                        'config' => $config,
                                        'steps' => [LoadTest::Step->new('id' => 'Test step',
                                                                        'delay_distribution' => exponential(2e-7) )
                                        ],
                                        'stats' => $stats);

my $scenario2 = LoadTest::Scenario->new('id' => 'test2',
                                        'config' => $config,
                                        'steps' => [LoadTest::Step->new('id' => 'Test step',
                                                                        'delay_distribution' => exponential(2e-7) )
                                        ],
                                        'stats' => $stats);

$scenario1->join();
$scenario2->join();


#my $mech = WWW::Mechanize->new();

#say Dumper($mech);

#$mech->get('https://arkdes.kreablo.se');
