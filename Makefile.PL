use inc::Module::Install;

all_from 'lib/Blosxom/Plugin.pm';

repository 'https://github.com/anazawa/p5-Blosxom-Plugin';

requires 'Blosxom::Header' => '0.05007';
requires 'CGI';

test_requires 'Test::More' => '0.98';
test_requires 'Test::Pod';
test_requires 'Data::Section::Simple';

WriteAll;
