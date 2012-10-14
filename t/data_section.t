use strict;
use warnings;
use FindBin;
use Test::More tests => 3;

{
    package blosxom;
    our %template;
}

my $plugin = 'data_section';

require_ok "$FindBin::Bin/plugins/$plugin";
ok $plugin->start;

my $expected = "hello, world\n";
is $plugin->get_data_section( 'data_section.html' ), $expected;
