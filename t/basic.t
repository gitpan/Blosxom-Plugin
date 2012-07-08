use strict;
use Test::More tests => 2;

package blosxom;

our $header = {};
our $static_entries = 0;

package foo;
use base 'Blosxom::Plugin';

sub start { !$blosxom::static_entries }

sub last {
    my $class = shift;
    $class->response->status( 304 );
}

package main;

my $plugin = 'foo';

ok $plugin->start();
$plugin->last();

is_deeply $blosxom::header, { -status => '304 Not Modified' };
