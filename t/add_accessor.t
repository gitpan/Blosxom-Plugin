use strict;
use warnings;
use Test::More tests => 1;

$INC{'MyComponent.pm'}++;

package MyComponent;

sub init {
    my ( $class, $c ) = @_;
    $c->add_accessor( 'foo' );
    return;
}

package main;
use parent 'Blosxom::Plugin';
__PACKAGE__->load_components( '+MyComponent' );

my $class = 'main';

$class->foo( 'bar' );

ok $class->foo, 'bar';
