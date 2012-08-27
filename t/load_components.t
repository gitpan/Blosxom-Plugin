use strict;
use warnings;
use Test::More tests => 1;

# Stolen from Amon2

$INC{ "My/Component/$_.pm" }++ for 1..3;

my @got;

package My::Component;

sub init {
    my ( $class, $c, $config ) = @_;
    push @got, [ $class, $c, $config ];
}

package My::Component::1;
use parent -norequire, 'My::Component';

package My::Component::2;
use parent -norequire, 'My::Component';

package My::Component::3;
use parent -norequire, 'My::Component';

package MyPlugin;
use parent 'Blosxom::Plugin';

__PACKAGE__->load_components(
    '+My::Component::1',
    '+My::Component::2' => +{ opt => 2 },
    '+My::Component::3',
);

package main;

is_deeply \@got, [
    [ 'My::Component::1', 'MyPlugin', undef        ],
    [ 'My::Component::2', 'MyPlugin', { opt => 2 } ],
    [ 'My::Component::3', 'MyPlugin', undef        ],
];
