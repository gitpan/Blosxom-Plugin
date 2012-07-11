package Blosxom::Plugin::DataSection;
use strict;
use warnings;
use Data::Section::Simple;

sub begin {
    my ( $class, $c, $conf ) = @_;
    my $data_section = $class->new( $c );
    $c->add_method( data_section => sub { $data_section } );
}

sub new {
    my ( $class, $plugin ) = @_;
    my $reader = Data::Section::Simple->new( $plugin );
    my $self = $reader->get_data_section;
    bless $self, $class;
}

sub get { shift->{ $_[0] } }

1;
