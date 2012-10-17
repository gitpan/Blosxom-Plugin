package Blosxom::Plugin::Web;
use strict;
use warnings;
use parent 'Blosxom::Plugin';

__PACKAGE__->load_components( 'DataSection' );

sub request {
    my $class = shift;
    $class->instance->{request} ||= do {
        require Blosxom::Plugin::Web::Request;
        Blosxom::Plugin::Web::Request->new;
    };
}

sub response {
    my $class = shift;
    $class->instance->{response} ||= do {
        require Blosxom::Plugin::Web::Response;
        Blosxom::Plugin::Web::Response->new;
    };
}

BEGIN {
    *req = \&request;
    *res = \&response;
}

1;

__END__

=head1 NAME

Blosxom::Plugin::Web - Core set of Blosxom::Plugin modules

=head1 SYNOPSIS

  # In your plugins
  use parent 'Blosxom::Plugin::Web';

=head1 DESCRIPTION

This class just loads various components that make up the L<Blosxom::Plugin>
core features. You almost certainly want these.

The core components currently are:

=over 4

=item L<Blosxom::Plugin::DataSection>

=back

=head2 METHODS

This class inherits all methods from L<Blosxom::Plugin>
and implements the following new ones.

=over 4

=item $class->response, $class->res

Returns a L<Blosxom::Plugin::Web::Response> object.

=item $class->request, $class->req

Returns a L<Blosxom::Plugin::Web::Request> object.

=item $class->util

Deprecated.

=item $class->get_data_section

=item $class->merge_get_data_section_into

See L<Blosxom::Plugin::DataSection>.

=item $rendered = $class->render

Deprecated.

=item $template = $class->get_template 

Deprecated.

=back

=head1 SEE ALSO

L<Blosxom::Plugin>

=head1 AUTHOR

Ryo Anazawa <anazawa@cpan.org>

=head1 LICENSE

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut
