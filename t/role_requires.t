use strict;
use warnings;
use Test::More tests => 2;

$INC{'MyComponent.pm'}++;

package MyComponent; {

    my @requires = qw( req1 req2 );

    sub init {
        my ( $class, $c ) = @_;

        if ( grep !$c->can($_), @requires ) {
            die "Can't apply $class to $c";
        }

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
}

package my_plugin; {
    use parent 'Blosxom::Plugin';
    __PACKAGE__->load_components( '+MyComponent' );

    sub req1 {}
    sub req2 {}
    sub foo { 'my_plugin foo' }
    sub baz { 'my_plugin baz' }
}

package main;

my $plugin = 'my_plugin';
is $plugin->bar, 'MyComponent bar';
is $plugin->baz, 'my_plugin baz';

