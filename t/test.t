#!/usr/bin/perl

use strict;
use warnings;

use lib 'lib';

use Test::More tests => 7;

our ($perl, $plackup);
BEGIN {
    use Config;
    use File::Which;

    $perl = $Config{perlpath};
    $plackup = which('plackup');
    $ENV{'UBIC_SERVICE_PLACKUP_BIN'} = "$perl $plackup";
}

system('rm -rf tfiles') and die "Can't remove tfiles: $!";
system('mkdir tfiles') and die "Can't create tfiles: $!";

use LWP::Simple;
use Ubic::Service::Plack;

{
    my $port = 5001;

    my $service = Ubic::Service::Plack->new({
        server => 'Standalone',
        port => $port,
        app => 't/bin/test.psgi',
        app_name => 'test_psgi',
        status => sub {
            my $result = get("http://localhost:$port") || '';
            if ($result eq 'ok') {
                return 'running';
            }
            else {
                return 'broken';
            }
        },
        ubic_log => 'tfiles/ubic.log',
        stdout => 'tfiles/stdout.log',
        stderr => 'tfiles/stderr.log',
        user => $ENV{LOGNAME},
        pidfile => 'tfiles/test_psgi.pid',
    });

    $service->start;
    is($service->status, 'running', 'start works');

    $service->stop;
    is($service->status, 'not running', 'stop works');

    $service->start;
    is($service->status, 'running', 'another start works');

    $service->stop;
    is($service->status, 'not running', 'another stop works');
}

# bin tests
{
    my $service = Ubic::Service::Plack->new({
        server => 'Starman',
        app => 't/bin/test.psgi',
        server_args => {
            port => 1234,
            M => [ 'Foo', 'Bar' ],
        },
        app_name => 'test_psgi',
    });

    is_deeply(
        [ sort @{ $service->bin }],
        [ sort($perl, $plackup, '--server', 'Starman', '-M', 'Foo', '-M', 'Bar', '--port', 1234, 't/bin/test.psgi') ],
        'bin generated correctly'
    );
}

# port
{
    my $service = Ubic::Service::Plack->new({
        server => 'Starman',
        app => 't/bin/test.psgi',
        server_args => {
            port => 1234,
        },
        app_name => 'test_psgi',
    });
    is($service->port, 1234, 'port from server_args port');

    $service = Ubic::Service::Plack->new({
        server => 'Starman',
        app => 't/bin/test.psgi',
        port => 1234,
        server_args => {},
        app_name => 'test_psgi',
    });
    is($service->port, 1234, 'port from top-level port');
}
