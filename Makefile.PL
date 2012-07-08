use inc::Module::Install;

all_from 'lib/Blosxom/Plugin.pm';

repository 'https://github.com/anazawa/p5-Blosxom-Plugin';

requires 'Blosxom::Header' => '0.05006';

test_requires 'Test::More' => '0.98';

WriteAll;
