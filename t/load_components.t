use strict;
use warnings;
use Test::More tests => 1;

# Stolen from Amon2

$INC{ "My/Component/$_.pm" }++ for 1..3;

my @got;

package My::Component;
sub begin { push @got, [ @_ ] }

package My::Component::1;
use parent -norequire, 'My::Component';

package My::Component::2;
use parent -norequire, 'My::Component';

package My::Component::3;
use parent -norequire, 'My::Component';

package MyPlugin;
use parent 'Blosxom::Plugin';

__PACKAGE__->load_components(qw/
    +My::Component::1
    +My::Component::2
    +My::Component::3
/);

package main;

is_deeply \@got, [
    [ 'My::Component::1', 'MyPlugin' ],
    [ 'My::Component::2', 'MyPlugin' ],
    [ 'My::Component::3', 'MyPlugin' ],
];
