use strict;
use Test::More tests => 21;

package blosxom;
our $header = {};

package plugin;
use parent 'Blosxom::Plugin::Core';

package main;

my $class = 'plugin';

can_ok $class, qw(
    load_components
    response res request req util data_section
    get_template render
);

my $util = $class->util;
isa_ok $util, 'Blosxom::Plugin::Util';

my $res = $class->res;
isa_ok $res, 'Blosxom::Plugin::Response';

my $response = $class->response;
isa_ok $response, 'Blosxom::Plugin::Response';

is $res, $response;

my $req = $class->req;
isa_ok $req, 'Blosxom::Plugin::Request';

my $request = $class->request;
isa_ok $request, 'Blosxom::Plugin::Request';

is $req, $request;

my @reserved_methods = qw(
    start       template entries filter skip
    interpolate head     sort    date   story
    foot        end      last
);

for my $method ( @reserved_methods ) {
    ok !$class->can( $method ), "'$method' is reserved";
}
