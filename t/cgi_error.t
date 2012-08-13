use strict;
use warnings;
use Blosxom::Plugin::Response;
use Test::More tests => 1;

{
    package blosxom;
    our $header = {};
}

local $CGI::POST_MAX = 2;
local $ENV{CONTENT_LENGTH} = 4;

my $response = Blosxom::Plugin::Response->instance;
is $response->status, 413;
