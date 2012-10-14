use strict;
use Blosxom::Plugin::Web::Response;
use Test::More tests => 15;

{
    package blosxom;
    our $header = {};
    our $output = 'foo';
}

my $response = Blosxom::Plugin::Web::Response->new;
isa_ok $response, 'Blosxom::Plugin::Web::Response';
can_ok $response, qw(
    body header status content_type cookie redirect location
    content_length content_encoding
);

is $response->body, 'foo';
$response->body( 'bar' );
is $response->body, 'bar';

isa_ok $response->header, 'Blosxom::Header';
is $response->content_type, 'text/html';

is $response->status, undef;
$response->status( 200 );
ok $response->status == 200;

$response->redirect( 'http://www.blosxom.com/' );
is $response->header->{Location}, 'http://www.blosxom.com/';
is $response->header->status, 302;

$response->redirect( 'http://www.blosxom.com/', 301 );
is $response->header->status, 301;

$response->location( 'http://www.cpan.org/' );
is $response->location, 'http://www.cpan.org/';

$response->content_length( 123 );
is $response->content_length, 123;

$response->content_encoding( 'gzip' );
is $response->content_encoding, 'gzip';

$response->cookie( ID => 123456 );
is $response->cookie( 'ID' )->value, 123456;
