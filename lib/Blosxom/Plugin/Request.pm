package Blosxom::Plugin::Request;
use strict;
use warnings;
use Blosxom::Plugin::Request::Upload;
use CGI;

sub begin {
    my ( $class, $c ) = @_;
    $c->add_method( $_ => \&instance ) for qw( request req );
}

my $instance;

sub instance {
    my $class = shift;

    return $class if ref $class;
    return $instance if defined $instance;

    my %self = (
        query => CGI->new,
        flavour => $blosxom::flavour,
        path_info => {
            full   => $blosxom::path_info,
            yr     => $blosxom::path_info_yr,
            mo_num => $blosxom::path_info_mo_num,
            mo     => $blosxom::path_info_mo,
            da     => $blosxom::path_info_da,
        },
    );

    $instance = bless \%self;
}

sub has_instance { $instance }

sub method          { shift->{query}->request_method  }
sub content_type    { shift->{query}->content_type    }
sub referer         { shift->{query}->referer         }
sub remote_host     { shift->{query}->remote_host     }
sub address         { shift->{query}->remote_addr     }
sub user_agent      { shift->{query}->user_agent      }
sub server_protocol { shift->{query}->server_protocol }
sub user            { shift->{query}->remote_user     }

sub cookies {
    my ( $self, $name ) = @_;
    $self->{query}->cookie( $name );
}

sub param {
    my ( $self, $key ) = @_;
    $self->{query}->param( $key || () );
}

sub uploads {
    my $self  = shift;
    my $field = shift;
    my $query = $self->{query};

    if ( my $uploads = $self->{uploads}{$field} ) {
        return wantarray ? @{ $uploads } : $uploads->[0];
    } 

    my @uploads;
    for my $filename ( $query->param( $field ) ) {
        push @uploads, Blosxom::Plugin::Request::Upload->new(
            filename => "$filename",
            fh       => $filename,
            tempname => $query->tmpFileName( $filename ),
            headers  => $query->uploadInfo( $filename ),
        );
    }

    $self->{uploads}{$field} = \@uploads;

    wantarray ? @uploads : $uploads[0];
}

sub path_info { shift->{path_info} }
sub flavour   { shift->{flavour}   }

1;

__END__

=head1 NAME

Blosxom::Plugin::Request - Object represents CGI request

=head1 SYNOPSIS

  use Blosxom::Plugin::Request;

  my $request = Blosxom::Plugin::Request->instance;

  my $method = $request->method; # GET
  my $path_info_mo_num = $request->path_info->{mo_num}; # 07
  my $flavour = $request->flavour; # rss
  my $page = $request->param( 'page' ); # 12
  my $id = $request->cookies( 'ID' ); # 123456

=head1 DESCRIPTION

Object represents CGI request.

=head2 METHODS

=over 4

=item Blosxom::Plugin::Request->begin

Exports C<instance()> into context class as C<request()>.
C<req()> is an alias.

=item $request = Blosxom::Plugin::Request->instance

Returns a current Blosxom::Header object instance or create a new one.

=item $request = Blosxom::Plugin::Request->has_instance

Returns a reference to any existing instance or C<undef> if none is defined.

=item $request->path_info

=item $request->flavour

=item $request->cookies

=item $request->param

=item $request->method

=item $request->content_type

=item $request->referer

=item $request->remote_host

=item $request->user_agent

=item $request->address

=item $request->user

=item $request->server_protocol

=item $request->uploads

=back

=head1 SEE ALSO

L<Blosxom::Plugin>, L<Plack::Request>, L<Class::Singleton>

=head1 AUTHOR

Ryo Anazawa

=head1 LICENSE AND COPYRIGHT

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. See L<perlartistic>.

=cut
