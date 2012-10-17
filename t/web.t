use strict;
use parent 'Blosxom::Plugin::Web';
use Test::More tests => 20;

package blosxom;
our $header = {};

package main;

my $class = __PACKAGE__;

can_ok $class, qw(
    load_components
    response res request req
    get_data_section merge_data_section_into
);

my $res = $class->res;
isa_ok $res, 'Blosxom::Plugin::Web::Response';

my $response = $class->response;
isa_ok $response, 'Blosxom::Plugin::Web::Response';

is $res, $response;

my $req = $class->req;
isa_ok $req, 'Blosxom::Plugin::Web::Request';

my $request = $class->request;
isa_ok $request, 'Blosxom::Plugin::Web::Request';

is $req, $request;

SKIP: {
    skip 'Plugin.pm implements end()', 13;

    my @reserved_methods = qw(
        start       template entries filter skip
        interpolate head     sort    date   story
        foot        end      last
    );

    for my $method ( @reserved_methods ) {
        ok !$class->can( $method ), "'$method' is reserved";
    }
}
