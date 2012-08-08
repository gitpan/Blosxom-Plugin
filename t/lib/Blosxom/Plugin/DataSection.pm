package Blosxom::Plugin::DataSection;
use strict;
use warnings;
use Data::Section::Simple;

sub begin {
    my ( $class, $c, $conf ) = @_;
    $c->add_method( data_section => \&instance );
}

my $instance;

sub instance { $instance ||= bless {} }

sub has_instance { $instance }

sub get {
    my $self   = shift;
    my $name   = shift;
    my $caller = caller;

    unless ( exists $self->{$caller} ) {
        my $reader = Data::Section::Simple->new( $caller );
        $self->{$caller} = $reader->get_data_section;
    }

    $self->{$caller}->{$name};
}

1;
