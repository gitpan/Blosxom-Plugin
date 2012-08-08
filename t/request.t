use strict;
use Blosxom::Plugin::Request;
use Test::More tests => 20;

{
    package blosxom;
    our $path_info        = '/foo/bar.html';
    our $path_info_mo     = 'Jul';
    our $path_info_mo_num = '07';
    our $path_info_da     = '10';
    our $path_info_yr     = '2012';
    our $url = 'http://localhost/blosxom.cgi';
}

local $ENV{QUERY_STRING}    = 'game=chess&game=checkers&weather=dull';
local $ENV{HTTP_COOKIE}     = 'foo=123; bar=qwerty; baz=wibble; qux=a1';
local $ENV{REQUEST_METHOD}  = 'GET';
local $ENV{CONTENT_TYPE}    = 'utf-8';
local $ENV{HTTP_REFERER}    = 'http://www.blosxom.com/';
local $ENV{HTTP_USER_AGENT} = 'Chrome';

my $plugin = 'Blosxom::Plugin::Request';
my $request = $plugin->instance;
isa_ok $request, $plugin;
can_ok $request, qw(
    method cookie content_type referer user_agent address
    remote_host param path_info protocol user upload base
    is_secure header date
);

is $request->method,       'GET';
is $request->content_type, 'utf-8';
is $request->referer,      'http://www.blosxom.com/';
is $request->user_agent,   'Chrome';
is $request->address,      '127.0.0.1';
is $request->remote_host,  'localhost';
is $request->protocol,     'HTTP/1.0';
is $request->user,         undef;
is $request->base,         'http://localhost/blosxom.cgi';

is $request->cookie( 'foo' ), 123;
is_deeply [ sort $request->cookie ], [qw/bar baz foo qux/];

is $request->param( 'game' ), 'chess';
is_deeply [ sort $request->param('game') ], [ 'checkers', 'chess' ];
is_deeply [ sort $request->param ], [ 'game', 'weather' ];

is $request->path_info, '/foo/bar.html';
is_deeply $request->date, {
    month => '07',
    day   => '10',
    year  => '2012',
};

local $ENV{HTTPS} = 'on';
ok $request->is_secure;

local $ENV{HTTP_ACCEPT_LANGUAGE} = 'da, en-gb;q=0.8, en;q=0.7';
is $request->header( 'Accept-Language' ), 'da, en-gb;q=0.8, en;q=0.7';
