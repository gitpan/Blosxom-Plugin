use strict;
use Blosxom::Plugin::Util;
use Test::More tests => 5;

{
    package blosxom;

    our %month2num = (
        nil => '00',
        Jan => '01', Feb => '02', Mar => '03', Apr => '04',
        May => '05', Jun => '06', Jul => '07', Aug => '08',
        Sep => '09', Oct => '10', Nov => '11', Dec => '12',
    );

    our @num2month = sort {
        $month2num{ $a } <=> $month2num{ $b }
    } keys %month2num;
}

my $plugin = 'Blosxom::Plugin::Util';
my $util = $plugin->instance;
isa_ok $util, $plugin;
can_ok $util, qw( month2num num2month encode_html );

is $util->month2num( 'Jul' ), '07';
is $util->num2month( 7 ), 'Jul';
is $util->encode_html( q{<>&"'} ), '&lt;&gt;&amp;&quot;&apos;';
