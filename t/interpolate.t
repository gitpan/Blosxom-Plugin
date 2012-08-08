use strict;
use warnings;
use Test::More tests => 2;

package blosxom;

our $blog_title = "My Weblog";

our $interpolate = sub {
    package blosxom;
    my $template = shift;
    $template =~ s/(\$\w+(?:::)?\w*)/"defined $1 ? $1 : ''"/gee;
    $template;
};

package interpolate;
use base 'Blosxom::Plugin';

sub start { 1 }

sub head {
    my $class = shift;
    my $interpolated = $class->interpolate( 'This is $blog_title' );
}

package main;

my $plugin = 'interpolate';
ok $plugin->start;
is $plugin->head, 'This is My Weblog';
