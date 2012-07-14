package Blosxom::Plugin;
use 5.008_009;
use strict;
use warnings;
use Carp qw/croak/;

our $VERSION = '0.00005';

__PACKAGE__->load_plugins( qw/Util Response Request/ );

sub load_plugins {
    my $context_class = shift;
    while ( @_ ) {
        my $plugin = shift;
        my $config = shift if ref $_[0] eq 'HASH';
        $context_class->load_plugin( $plugin, $config );
    }
}

sub load_plugin {
    my $context_class = shift;
    my $plugin = join '::', __PACKAGE__, shift;
    my $config = shift if ref $_[0] eq 'HASH';
    ( my $file = $plugin ) =~ s{::}{/}g;
    require "$file.pm";
    $plugin->begin( $context_class, $config );
}

sub add_method {
    my ( $class, $method, $code ) = @_;
    $method = "$class\::$method";
    no strict 'refs';
    *$method = $code;
}

1;

__END__

=head1 NAME

Blosxom::Plugin - Base class of Blosxom plugins

=head1 SYNOPSIS

  package foo;
  use strict;
  use warnings;
  use parent 'Blosxom::Plugin';

  __PACKAGE__->load_plugin( 'DataSection' );

  sub start { !$blosxom::static_entries }

  sub last {
      my $class = shift;
      $class->response->status( 304 );
      my $path_info = $class->request->path_info;
      my $month = $class->util->num2month( 7 ) # Jul;
      my $template = $class->data_section->get( 'foo.html' );
  }

  1;

  __DATA__

  @@ foo.html

  <!DOCTYPE html>
  <html>
  <head>
    <meta charset="utf-8">
    <title>Foo</title>
  </head>
  <body>
  <h1>hello, world</h1>
  </body>
  </html>


=head1 DESCRIPTION

Base class of Blosxom plugins.

=head2 METHODS

=over 4

=item response, res

Returns a L<Blosxom::Plugin::Response> object.

=item request, req

Returns a L<Blosxom::Plugin::Request> object.

=item util

Returns a L<Blosxom::Plugin::Util> object.

=item load_plugin( $plugin )

=item load_plugins( @plugins )

=item add_method( $method => $coderef )

=back

=head1 DEPENDENCIES

L<Blosxom 2.0.0|http://blosxom.sourceforge.net/> or higher.

=head1 SEE ALSO

L<Amon2>

=head1 ACKNOWLEDGEMENT

Blosxom was originally written by Rael Dohnfest.
L<The Blosxom Development Team|http://sourceforge.net/projects/blosxom/>
succeeded to the maintenance.

=head1 BUGS AND LIMITATIONS

This module is beta state. API may change without notice.

=head1 AUTHOR

Ryo Anazawa <anazawa@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2012 Ryo Anzawa. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=cut
