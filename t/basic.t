use strict;
use FindBin;
use lib "$FindBin::Bin/lib";
use Test::More tests => 3;

package blosxom;

our $header = {};
our $static_entries = 0;

package foo;
use base 'Blosxom::Plugin';

__PACKAGE__->load_plugin( 'Foo' );

sub start { !$blosxom::static_entries }

sub last {
    # I'm not sure whether $c represents 'class' or 'context'.
    # context class? Anyway, I don't care about the difference
    my $c = shift;
    $c->response->status( 304 ) if $c->request->method eq 'GET';
    $c->foo;
}

package baz;
use base qw/Blosxom::Plugin/;

__PACKAGE__->load_plugins(
    'Foo',
    'Bar' => {
        foo => 'qux',
        bar => 'baz',
        baz => 'qux',
    },
);

sub start { !$blosxom::static_entries }

sub last {
    my $c = shift;
    $c->response->header->set( Baz => $c->bar->{foo} );
}

package main;

my @plugins = qw( foo baz );
local $ENV{REQUEST_METHOD} = 'GET';

for my $plugin ( @plugins ) {
    ok $plugin->start();
}

for my $plugin ( @plugins ) {
    $plugin->last();
}

is_deeply $blosxom::header, {
    -foo => 'bar',
    #-bar => 'baz',
    -baz => 'qux',
    -status => '304 Not Modified',
};
