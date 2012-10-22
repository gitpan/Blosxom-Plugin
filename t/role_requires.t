use strict;
use warnings;
use Test::More tests => 2;

$INC{'MyComponent.pm'}++;

package MyComponent; {

    my @requires = qw( req1 req2 );

    sub init {
        my ( $class, $c ) = @_;

        if ( grep !$c->has_method($_), @requires ) {
            die "Can't apply $class to $c";
        }

        $c->add_method( bar => \&_bar );
        $c->add_method( baz => \&_baz );

        return;
    }

    sub _bar { 'MyComponent bar' }
    sub _baz { 'MyComponent baz' }
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

