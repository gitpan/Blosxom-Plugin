use strict;
use warnings;
use Test::More tests => 3;

$INC{'MyComponent.pm'}++;

package MyComponent;

sub init {
    my ( $class, $c ) = @_;

    #unless ( $c->has_method('bar') ) {
    unless ( $c->can('bar') ) {
        $c->add_method( bar => sub { 'MyComponent bar' } );
    }

    #unless ( $c->has_method('baz') ) {
    unless ( $c->can('baz') ) {
        $c->add_method( baz => sub { 'MyComponent baz' } );
    }

    return;
}

package my_plugin;
use parent 'Blosxom::Plugin';

__PACKAGE__->load_components( '+MyComponent' );

sub foo { 'my_plugin foo' }
sub baz { 'my_plugin baz' }

package main;

my $plugin = 'my_plugin';
is $plugin->foo, 'my_plugin foo';
is $plugin->bar, 'MyComponent bar';
is $plugin->baz, 'my_plugin baz';
