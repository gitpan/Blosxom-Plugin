use strict;
use Test::More tests => 8;

BEGIN {
    use_ok 'Blosxom::Plugin';
    use_ok 'Blosxom::Plugin::Response';
    use_ok 'Blosxom::Plugin::Response';
    use_ok 'Blosxom::Plugin::Util';
}

can_ok 'Blosxom::Plugin', qw( load_plugin load_plugins add_method );
can_ok 'Blosxom::Plugin::Response', qw( begin instance has_instance );
can_ok 'Blosxom::Plugin::Request',  qw( begin instance has_instance );
can_ok 'Blosxom::Plugin::Util',     qw( begin instance has_instance );
