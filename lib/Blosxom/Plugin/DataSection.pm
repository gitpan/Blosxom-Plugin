package Blosxom::Plugin::DataSection;
use strict;
use warnings;
use Data::Section::Simple;

sub init {
    my ( $class, $c ) = @_;
    $c->add_method( get_data_section => \&_get_data_section );
}

my %data_section_of;

sub _get_data_section {
    my ( $class, $name ) = @_;
    $data_section_of{ $class } ||= do {
        my $reader = Data::Section::Simple->new( $class );
        $reader->get_data_section || +{};
    };
    $data_section_of{ $class }{ $name };
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
      my $template = $class->data_section->{'my_plugin.html'};
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

This module extracts data from C<__DATA__> section of the plugin.

=head1 SEE ALSO

L<Blosxom::Plugin>, L<Data::Section::Simple>

=head1 AUTHOR

Ryo Anazawa <anazawa@cpan.org>

=head1 LICENSE

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut
