use strict;
use warnings;
use Test::Exception;
use Test::More tests => 3;

$INC{'MyComponent.pm'}++;

package MyComponent;
use Blosxom::Plugin;

__PACKAGE__->requires(qw/req1 req2/);

sub bar { 'MyComponent bar' }
sub baz { 'MyComponent baz' }

package my_plugin;
use parent 'Blosxom::Plugin';

__PACKAGE__->load_components( '+MyComponent' );

sub req1 {}
sub req2 {}
sub foo { 'my_plugin foo' }
sub baz { 'my_plugin baz' }

package another_plugin;
use parent 'Blosxom::Plugin';

package main;

my $plugin = 'my_plugin';

is $plugin->bar, 'MyComponent bar';
is $plugin->baz, 'my_plugin baz';

throws_ok { another_plugin->load_components('+MyComponent') }
    qr/^Can't apply 'MyComponent' to 'another_plugin'/;
