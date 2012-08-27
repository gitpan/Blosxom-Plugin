package Blosxom::Plugin::Core;
use strict;
use warnings;
use parent 'Blosxom::Plugin';
use Carp qw/carp/;

__PACKAGE__->load_components(
    'Util',
    'DataSection',
    'Request',
    'Response',
);

sub res { shift->response }
sub req { shift->request  }

sub get_template { carp 'Deprecated' }
sub render       { carp 'Deprecated' }

1;

__END__

=head1 NAME

Blosxom::Plugin::Core - Core set of Blosxom::Plugin modules

=head1 SYNOPSIS

  # In your plugins
  use parent 'Blosxom::Plugin::Core';

=head1 DESCRIPTION

This class just loads various components that make up the L<Blosxom::Plugin>
core features. You almost certainly want these.

The core components currently are:

=over 4

=item L<Blosxom::Plugin::Request>

=item L<Blosxom::Plugin::Response>

=item L<Blosxom::Plugin::DataSection>

=item L<Blosxom::Plugin::Util>

=back

=head2 METHODS

This class inherits all methods from L<Blosxom::Plugin>
and implements the following new ones.

=over 4

=item $class->response, $class->res

Returns a L<Blosxom::Plugin::Response> object.

=item $class->request, $class->req

Returns a L<Blosxom::Plugin::Request> object.

=item $class->util

Returns a L<Blosxom::Plugin::Util> object.

=item $class->data_section

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
