package Blosxom::Plugin::DataSection;
use strict;
use warnings;
use Carp qw/croak/;
use Data::Section::Simple;

my @exports = qw( data_section get_data_section merge_data_section_into );

sub init {
    my ( $class, $c ) = @_;
    $c->add_method( $_ => \&{"_$_"} ) for @exports;
    return;
}

sub _data_section {
    my $class = shift;
    $class->instance->{data_section} ||= do {
        my $reader = Data::Section::Simple->new( $class );
        $reader->get_data_section;
    };
}

sub _get_data_section { shift->data_section->{$_[0]} }

sub _merge_data_section_into {
    my ( $class, $merge_into ) = @_;

    croak 'Must provide a HASH reference' if ref $merge_into ne 'HASH';

    while ( my ($basename, $template) = each %{ $class->data_section } ) {
        my ( $chunk, $flavour ) = $basename =~ /(.*)\.([^.]*)/;
        $merge_into->{ $flavour }{ $chunk } = $template;
    }

    return;
}

1;

__END__

=head1 NAME

Blosxom::Plugin::DataSection - Read data from __DATA__

=head1 SYNOPSIS

  package my_plugin;
  use strict;
  use warnings;
  use parent 'Blosxom::Plguin';

  __PACKAGE__->load_components( 'DataSection' );

  sub start {
      my $class = shift;

      # merge __DATA__ into Blosxom default templates
      $class->merge_data_section_into( \%blosxom::template );

      return 1;
  }

  sub head {
      my $class = shift;
      my $template = $class->get_data_section( 'my_plugin.html' );
      $template = $blosxom::interpolate->( $template );
      return;
  }

  1;

  __DATA__

  @@ my_plugin.html

  <!DOCTYPE html>
  <html>
  <head>
    <meta charset="utf-8">
    <title>My Plugin</title>
  </head>
  <body>
  <h1>Hello, world</h1>
  </body>
  </html>

=head1 DESCRIPTION

This module extracts data from C<__DATA__> section of the plugin,
and also merges them into Blosxom default templates.

=head1 SEE ALSO

L<Blosxom::Plugin>, L<Data::Section::Simple>

=head1 AUTHOR

Ryo Anazawa <anazawa@cpan.org>

=head1 LICENSE

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut
