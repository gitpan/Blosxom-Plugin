use strict;
use Test::More tests => 6;

BEGIN {
    use_ok 'Blosxom::Plugin';
    use_ok 'Blosxom::Plugin::DataSection';
    use_ok 'Blosxom::Plugin::Web';
    use_ok 'Blosxom::Plugin::Web::Response';
    use_ok 'Blosxom::Plugin::Web::Request';
    use_ok 'Blosxom::Plugin::Web::Request::Upload';
}
