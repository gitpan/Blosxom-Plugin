use strict;
use Blosxom::Plugin::Request;
use Test::More tests => 15;

{
    package blosxom;
    our $path_info        = '/foo/bar.html';
    our $path_info_mo     = 'Jul';
    our $path_info_mo_num = '07';
    our $path_info_da     = '10';
    our $path_info_yr     = '2012';
}

local $ENV{QUERY_STRING}    = 'game=chess&game=checkers&weather=dull';
local $ENV{HTTP_COOKIE}     = 'foo=123; bar=qwerty; baz=wibble; qux=a1';
local $ENV{REQUEST_METHOD}  = 'GET';
local $ENV{CONTENT_TYPE}    = 'utf-8';
local $ENV{HTTP_REFERER}    = 'http://blosxom.com';
local $ENV{HTTP_USER_AGENT} = 'Chrome';

my $plugin = 'Blosxom::Plugin::Request';
my $req = $plugin->instance;
isa_ok $req, $plugin;
can_ok $req, qw(
    method cookies content_type referer user_agent address
    remote_host cookies param path_info server_protocol user uploads
);

is $req->method,       'GET';
is $req->content_type, 'utf-8';
is $req->referer,      'http://blosxom.com';
is $req->user_agent,   'Chrome';
is $req->address,      '127.0.0.1';
is $req->remote_host,  'localhost';
is $req->server_protocol,  'HTTP/1.0';
is $req->user, undef;

is $req->cookies( 'bar' ), 'qwerty';

is $req->param( 'game' ), 'chess';
my @got = sort $req->param( 'game' );
is_deeply \@got, [ 'checkers', 'chess' ];
@got = sort $req->param;
is_deeply \@got, [ 'game', 'weather' ];

is_deeply $req->path_info, {
    full   => '/foo/bar.html',
    mo     => 'Jul',
    mo_num => '07',
    da     => '10',
    yr     => '2012',
};
