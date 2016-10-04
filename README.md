
Tool for creating scenarios to load test a web service.

A scenario consist of a sequence of steps each performing some kind of request.  The time it takes to execute the scenario step is logged.  A scenario is executed in a separate thread, so multiple scenarios can run in parallell.

Usage
=====

First create a config.yaml file to describe the scenarios and various configuration parameters.  See config.yaml.example.

Implement scenario steps
========================

Override the class LoadTest::Step or any of its subclasses and implement the runStep method, wich should return a reference to an HTTP response object.

