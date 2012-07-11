package Blosxom::Plugin::Foo;
use strict;
use warnings;

sub begin {
    my ( $class, $c, $conf ) = @_;
    $c->add_method( foo => \&foo );
}

sub foo {
    my $class = shift;
    $class->response->header->set( Foo => 'bar' );
}

1;
