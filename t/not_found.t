use strict;
use FindBin qw/$Bin/;
use lib "$Bin/lib";
use Test::More tests => 4;

{
    package blosxom;
    our $static_entries = 0;
    our $output;
}

my $plugin = 'not_found';
require_ok "$Bin/plugins/$plugin";
can_ok $plugin, qw( start last );
ok $plugin->start;
$plugin->last;
is $blosxom::output, "404\nNot\nFound\n";
