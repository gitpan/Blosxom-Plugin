use strict;
use warnings;
use Test::More tests => 4;

package blosxom;

our $path_info = '/foo/bar.html';
our $flavour   = 'html';
our $template  = sub { join '|', @_ };

package get_template;
use base 'Blosxom::Plugin';

sub start { 1 }

sub default {
    my $class = shift;
    my $template = $class->get_template;
}

sub component {
    my $class = shift;
    my $template = $class->get_template( 'component' );
}

sub args {
    my $class = shift;
    my $template = $class->get_template(
        component => 'args',
        flavour   => 'rss',
        path      => '/foo/bar/baz',
    );
}

package main;

my $plugin = 'get_template';
ok $plugin->start;
is $plugin->default,   '/foo/bar.html|get_template|html';
is $plugin->component, '/foo/bar.html|component|html';
is $plugin->args,      '/foo/bar/baz|args|rss';
