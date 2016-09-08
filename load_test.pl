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
use LoadTest::Step::KohaOpacLogin;
use LoadTest::Step::Search;
use LoadTest::Step::SearchBrowse;
use LoadTest::Step::SearchSelectTitle;
use LoadTest::Step::MainPage;
use LoadTest::Step::IntraMainPage;
use LoadTest::Step::IntraLogin;
use LoadTest::Step::IntraGotoSearch;
use LoadTest::Step::IntraSearch;
use LoadTest::Step::IntraCirculationPage;
use LoadTest::Step::ZebraSearch;

open(my $configFh, "<", "config.yaml");

my $config = LoadTest::Config->new('configFile' => $configFh);

open(my $fh, ">", $config->configData->{logfile});

my $stats = LoadTest::Statistics->new('fh' => $fh, 'id' => 'stat1');

my @scenarios = ();

foreach my $scenarioConf (@{$config->configData->{scenarios}}) {
    foreach (my $i = 0; $i < $scenarioConf->{instances}; $i++) {
        my $scenario = LoadTest::Scenario->new({'id' => $scenarioConf->{id} . $i,
                                                'mech' =>  WWW::Mechanize->new(),
                                                'scenarioConf' => $scenarioConf,
                                                'config' => $config,
                                                'stats' => $stats });
        my $steps = [];
        foreach my $stepConfig (@{$scenarioConf->{steps}}) {
            my $step;
            eval "\$step = LoadTest::Step::$stepConfig->{classname}->new({ 'id' => \$stepConfig->{id}," .
                                                                          "'scenario' => \$scenario,"   .
                                                                          "'delay_distribution' => exponential(\$stepConfig->{lambda}) })";

            warn $@ if $@;

            push @$steps, $step;
        }
        $scenario->steps( $steps );
        push @scenarios, $scenario;
    }
}

foreach my $s (@scenarios) {
    $s->run();
}


foreach my $s (@scenarios) {
    $s->join();
}


#my $mech = WWW::Mechanize->new();

#say Dumper($mech);

#$mech->get('https://arkdes.kreablo.se');
