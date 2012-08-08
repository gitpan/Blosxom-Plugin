package Blosxom::Plugin::Request;
use strict;
use warnings;
use Blosxom::Plugin::Request::Upload;
use CGI;

sub begin {
    my ( $class, $c ) = @_;
    my $method = \&instance;
    $c->add_method( $_ => $method ) for qw( request req );
}

my $instance;

sub instance {
    my $class = shift;

    return $class    if ref $class;
    return $instance if defined $instance;

    my %self = (
        query     => CGI->new,
        path_info => $blosxom::path_info,
        flavour   => $blosxom::flavour,
        base      => $blosxom::url,
        date => {
            day   => $blosxom::path_info_da,
            month => $blosxom::path_info_mo_num,
            year  => $blosxom::path_info_yr,
        },
    );

    $instance = bless \%self;
}

sub has_instance { $instance }

sub path_info { shift->{path_info} }
sub date      { shift->{date}      }
sub flavour   { shift->{flavour}   }
sub base      { shift->{base}      }

sub header    { shift->{query}->http( @_ )   }
sub is_secure { scalar shift->{query}->https }

sub method       { shift->{query}->request_method   }
sub content_type { shift->{query}->content_type     }
sub referer      { shift->{query}->referer          }
sub remote_host  { shift->{query}->remote_host      }
sub address      { shift->{query}->remote_addr      }
sub user_agent   { shift->{query}->user_agent( @_ ) }
sub protocol     { shift->{query}->server_protocol  }
sub user         { shift->{query}->remote_user      }

sub cookie {
    my $self  = shift;
    my $query = $self->{query};

    if ( @_ == 1 ) {
        my $name = shift;
        return $query->cookie( $name );
    }

    $query->cookie;
}

sub param {
    my $self  = shift;
    my $query = $self->{query};

    if ( @_ == 1 ) {
        my $field = shift;
        return $query->param( $field );
    }
    
    $query->param;
}

sub upload {
    my $self  = shift;
    my $query = $self->{query};

    unless ( exists $self->{upload} ) {
        my %upload;
        for my $field ( $query->param ) {
            my @uploads;
            for my $fh ( $query->upload($field) ) {
                push @uploads, Blosxom::Plugin::Request::Upload->new(
                    fh     => $fh,
                    path   => $query->tmpFileName( $fh ),
                    header => $query->uploadInfo( $fh ),
                );
            }

            $upload{ $field } = \@uploads if @uploads;
        }

        $self->{upload} = \%upload;
    }

    if ( @_ == 1 ) {
        my $field = shift;
        if ( my $uploads = $self->{upload}->{$field} ) {
            return wantarray ? @{ $uploads } : $uploads->[0];
        }
    }
    else {
        return keys %{ $self->{upload} };
    }

    return;
}

1;

__END__

=head1 NAME

Blosxom::Plugin::Request - Object representing CGI request

=head1 SYNOPSIS

  use Blosxom::Plugin::Request;

  my $request = Blosxom::Plugin::Request->instance;

  my $method = $request->method; # GET
  my $path_info = $request->path_info; # /foo/bar.html
  my $flavour = $request->flavour; # rss
  my $page = $request->param( 'page' ); # 12
  my $id = $request->cookie( 'ID' ); # 123456

=head1 DESCRIPTION

Object representing CGI request.

=head2 CLASS METHODS

=over 4

=item Blosxom::Plugin::Request->begin

Exports C<instance()> into context class as C<request()>.
C<req()> is an alias.

=item $request = Blosxom::Plugin::Request->instance

Returns a current Blosxom::Header object instance or create a new one.

=item $request = Blosxom::Plugin::Request->has_instance

Returns a reference to any existing instance or C<undef> if none is defined.

=back

=head2 INSTANCE METHODS

=over 4

=item $request->base

  $blosxom::url

=item $request->path_info

  $blosxom::path_info

=item $request->date

  $request->date->{year};  # $blosxom::path_info_yr
  $request->date->{month}; # $blosxom::path_info_mo_num
  $request->date->{day};   # $blosxom::path_info_da

=item $request->flavour

  $blosxom::flavour

=item $request->cookie

  my $id = $request->cookie( 'ID' ); # 123456

=item $request->param

  my $value = $request->param( 'foo' );
  my @values = $request->param( 'foo' );
  my @fields = $request->param;

=item $request->method

Returns the method used to access your script, usually one of C<POST>,
C<GET> or C<HEAD>.

=item $request->content_type

Returns the content_type of data submitted in a POST, generally
C<multipart/form-data> or C<application/x-www-form-urlencoded>.

=item $request->referer

Returns the URL of the page the browser was viewing prior to fetching your
script. Not available for all browsers.

=item $request->remote_host

Returns either the remote host name, or IP address if the former
is unavailable.

=item $request->user_agent

Returns the C<HTTP_USER_AGENT> variable. If you give this method a single
argument, it will attempt to pattern match on it, allowing you to do
something like:

  if ( $request->user_agent('Mozilla') ) {
      ...
  }

=item $request->address

Returns the remote host IP address, or C<127.0.0.1> if the address is
unavailable (C<REMOTE_ADDR>).

=item $request->user

Returns the authorization/verification name for user verification,
if this script is protected (C<REMOTE_USER>).

=item $request->protocol

Returns the protocol (HTTP/1.0 or HTTP/1.1) used for the current request.

=item $request->upload

Returns L<Blosxom::Plugin::Request::Upload> objects.

  my $upload = $request->upload( 'field' );
  my @uploads = $request->upload( 'field' );
  my @fields = $request->upload;

=item $request->is_secure

Returns a Boolean value telling whether connection is secure.

=item $request->header

Returns the value of the specified header.

  my $requested_language = $request->header( 'Accept-Language' );

=back

=head1 SEE ALSO

L<Blosxom::Plugin>, L<Plack::Request>, L<Class::Singleton>

=head1 AUTHOR

Ryo Anazawa

=head1 LICENSE AND COPYRIGHT

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. See L<perlartistic>.

=cut
