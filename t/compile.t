use strict;
use Test::More tests => 7;

BEGIN {
    use_ok 'Blosxom::Plugin';
    use_ok 'Blosxom::Plugin::Response';
    use_ok 'Blosxom::Plugin::Request';
    use_ok 'Blosxom::Plugin::Request::Upload';
    use_ok 'Blosxom::Plugin::Util';
    use_ok 'Blosxom::Plugin::Core';
    use_ok 'Blosxom::Plugin::DataSection';
}
