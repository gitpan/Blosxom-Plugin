use strict;
use base qw/Blosxom::Plugin/;
use Test::More tests => 8;

can_ok __PACKAGE__, qw( response res request req util );

my $util = __PACKAGE__->util;
isa_ok $util, 'Blosxom::Plugin::Util';

my $res = __PACKAGE__->res;
isa_ok $res, 'Blosxom::Plugin::Response';

my $response = __PACKAGE__->response;
isa_ok $response, 'Blosxom::Plugin::Response';

is $res, $response;

my $req = __PACKAGE__->req;
isa_ok $req, 'Blosxom::Plugin::Request';

my $request = __PACKAGE__->request;
isa_ok $request, 'Blosxom::Plugin::Request';

is $req, $request;
