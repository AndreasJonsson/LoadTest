#!/usr/bin/env perl
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
use LoadTest::Step::CirculateSelectPatron;
use LoadTest::Step::CirculateIssueLoan;
use LoadTest::Step::CirculateReturnLoan;
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
