package Blosxom::Plugin::Response;
use strict;
use warnings;
use Blosxom::Header;

sub begin {
    my ( $class, $c, $conf ) = @_;
    $c->add_method( $_ => \&instance ) for qw( response res );
}

my $instance;

sub instance {
    my $class = shift;
    return $class if ref $class;
    return $instance if defined $instance;
    $instance = bless {};
}

sub has_instance { $instance }

sub header {
    my $self = shift;
    $self->{header} ||= Blosxom::Header->instance;
}

sub status       { shift->header->status( @_ ) }
sub content_type { shift->header->type( @_ )   }
sub cookies      { shift->header->cookie( @_ ) }

sub content_length {
    my $header = shift->header;
    return $header->set( Content_Length => shift ) if @_;
    $header->get( 'Content-Length' );
}

sub content_encoding {
    my $header = shift->header;
    return $header->set( Content_Encoding => shift ) if @_;
    $header->get( 'Content-Encoding' );
}

sub location {
    my $header = shift->header;
    return $header->set( Location => shift ) if @_;
    $header->get( 'Location' );
}

sub redirect {
    my $header = shift->header;
    $header->set( Location => shift );
    $header->status( shift || 301 );
}

sub body {
    my $self = shift;
    return $blosxom::output = shift if @_;
    $blosxom::output;
}

1;

__END__

=head1 NAME

Blosxom::Plugin::Response - Object represents CGI response

=head1 SYNOPSIS

  use Blosxom::Plugin::Response;

  my $response = Blosxom::Plugin::Response->instance;

  my $header = $response->header; # Blosxom::Header object
  my $body = $response->body; # <!DOCTYPE html> ...

  $response->status( 304 );

=head1 DESCRIPTION

Object represents CGI response.

=head2 METHODS

=over 4

=item Blosxom::Plugin::Response->begin

Exports C<instance()> into context class as C<response()>.
C<res()> is an alias.

=item $response = Blosxom::Plugin::Response->instance

Returns a current Blosxom::Plugin::Response object instance or create a new
one.

=item $response = Blosxom::Plugin::Response->has_instance

Returns a reference to any existing instance or C<undef> if none is defined.

=item $response->header

Returns a L<Blosxom::Header> object instance.

=item $response->status

=item $response->content_type

=item $response->cookies

=item $response->content_length

=item $response->content_encoding

=item $response->location

=item $response->redirect

=back

=head1 SEE ALSO

L<Blosxom::Plugin>, L<Plack::Response>, L<Class::Singleton>

=head1 AUTHOR

Ryo Anazawa

=head1 LICENSE AND COPYRIGHT

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. See L<perlartistic>.

=cut


