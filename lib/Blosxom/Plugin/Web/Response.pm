package Blosxom::Plugin::Web::Response;
use strict;
use warnings;
use Blosxom::Header; # FIXME
use Carp qw/croak/;
use CGI qw/cgi_error/;

sub new {
    my $class = shift;

    my %self = (
        header => Blosxom::Header->instance,
    );

    if ( my $status = cgi_error() ) {
        $self{header}{Status} = $status;
    }

    bless \%self, $class;
}

sub header { shift->{header} }

sub status       { shift->{header}->status( @_ )       }
sub content_type { shift->{header}->content_type( @_ ) }

sub cookie {
    my $self   = shift;
    my $header = $self->{header};

    if ( @_ ) {
        if ( @_ == 1 ) {
            return $header->get_cookie( shift );
        }
        elsif ( @_ % 2 == 0 ) {
            while ( my ($name, $value) = splice @_, 0, 2 ) {
                $header->set_cookie( $name => $value );
            }
        }
        else {
            croak( 'Odd number of elements passed to cookies()' );
        }
    }

    return;
}

sub content_length {
    my $self = shift;
    return $self->{header}->{Content_Length} = shift if @_;
    $self->{header}->{Content_Length};
}

sub content_encoding {
    my $self = shift;
    return $self->{header}->{Content_Encoding} = shift if @_;
    $self->{header}->{Content_Encoding};
}

sub location {
    my $self = shift;
    return $self->{header}->{Location} = shift if @_;
    $self->{header}->{Location};
}

sub redirect {
    my $self = shift;
    $self->{header}->{Location} = shift;
    $self->{header}->status( shift || 302 );
}

# FIXME
sub body {
    my $self = shift;
    return $blosxom::output = shift if @_;
    $blosxom::output;
}

# FIXME
sub DESTROY {
    my $self = shift;
    undef $blosxom::output;
    undef $Blosxom::Header::INSTANCE;
    return;
}

1;

__END__

=head1 NAME

Blosxom::Plugin::Web::Response - Object representing CGI response

=head1 SYNOPSIS

  use Blosxom::Plugin::Web::Response;

  my $response = Blosxom::Plugin::Web::Response->new;

  my $header = $response->header; # Blosxom::Header object
  my $body = $response->body; # <!DOCTYPE html> ...

  $response->status( 304 );

=head1 DESCRIPTION

Object representing CGI response.

=head2 METHODS

=over 4

=item $response = Blosxom::Plugin::Web::Response->new

Creates a Blosxom::Plugin::Web::Response object.

=item $response->header

Returns a L<Blosxom::Header> object instance.

=item $response->status

A shortcut for C<< $response->header->status >>.

=item $response->content_type

A shortcut for C<< $response->header->content_type >>.

=item $response->cookie

  $response->cookie( ID => 123456 ); # set
  my $id = $resposne->cookie( 'ID' ); # get

=item $response->content_length

A decimal number indicating the size in bytes of the message content.

  $response->content_length( 123 );

=item $response->content_encoding

The Content-Encoding header field is used as a modifier to the media type.
When present, its value indicates what additional encoding mechanism has been
applied to the resource.

  $response->content_encoding( 'gzip' );

=item $response->location

Gets and sets the Location header.

=item $response->redirect

Sets redirect URL with an optional status code, which defaults to 302.

  $response->redirect( $url );
  $response->redirect( $url, 301 );

=item $response->body

Gets and sets HTTP response body.

  $response->body( 'Hello World' );

=back

=head1 SEE ALSO

L<Blosxom::Plugin>, L<Plack::Response>, L<Class::Singleton>

=head1 AUTHOR

Ryo Anazawa

=head1 LICENSE AND COPYRIGHT

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. See L<perlartistic>.

=cut


