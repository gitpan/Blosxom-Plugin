use strict;
use warnings;
use Test::More tests => 3;
use parent 'Blosxom::Plugin';

__PACKAGE__->mk_accessors( 'foo' );

my $plugin = __PACKAGE__;

$plugin->foo( 'bar' );
ok $plugin->foo, 'bar';
is_deeply $plugin->dump, { foo => 'bar' };

$plugin->end;
is_deeply $plugin->dump, undef;

sub dump { my $VAR1; eval shift->SUPER::dump }
