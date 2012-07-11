package Blosxom::Plugin::Request;
use strict;
use warnings;
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
        cgi => CGI->new,
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

sub method       { shift->{cgi}->request_method }
sub content_type { shift->{cgi}->content_type   }
sub referer      { shift->{cgi}->referer        }
sub remote_host  { shift->{cgi}->remote_host    }
sub address      { shift->{cgi}->remote_addr    }
sub user_agent   { shift->{cgi}->user_agent     }

sub cookies {
    my ( $self, $name ) = @_;
    $self->{cgi}->cookie( $name );
}

sub param {
    my ( $self, $key ) = @_;
    $self->{cgi}->param( $key || () );
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

=back

=head1 SEE ALSO

L<Blosxom::Plugin>, L<Plack::Request>, L<Class::Singleton>

=head1 AUTHOR

Ryo Anazawa

=head1 LICENSE AND COPYRIGHT

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. See L<perlartistic>.

=cut
