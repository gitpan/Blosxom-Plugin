use strict;
use Blosxom::Plugin::Response;
use Test::More tests => 11;

{
    package blosxom;
    our $header = {};
    our $output = 'foo';
}

my $plugin = 'Blosxom::Plugin::Response';
my $res = $plugin->instance;
isa_ok $res, $plugin;
can_ok $res, qw(
    body header status content_type cookies redirect location
    content_length content_encoding
);

is $res->body, 'foo';

isa_ok $res->header, 'Blosxom::Header';
is $res->content_type, 'text/html';

$res->redirect( 'http://blosxom.com' );
is $res->header->get( 'Location' ), 'http://blosxom.com';
is $res->header->status, 301;

is $res->location, 'http://blosxom.com';
$res->location( 'http://cpan.org' );
is $res->location, 'http://cpan.org';

$res->content_length( 123 );
is $res->content_length, 123;

$res->content_encoding( 'gzip' );
is $res->content_encoding, 'gzip';
