package Blosxom::Plugin::Web;
use strict;
use warnings;
use parent 'Blosxom::Plugin';

__PACKAGE__->mk_accessors(
    request => sub {
        require Blosxom::Plugin::Web::Request;
        Blosxom::Plugin::Web::Request->new;
    },
);

*req = \&request;

__PACKAGE__->load_components( 'DataSection' );

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

=item $class->request, $class->req

Returns a L<Blosxom::Plugin::Web::Request> object.

=item $class->get_data_section, $class->merge_data_section_into

See L<Blosxom::Plugin::DataSection>.

=back

=head1 SEE ALSO

L<Blosxom::Plugin>

=head1 AUTHOR

Ryo Anazawa <anazawa@cpan.org>

=head1 LICENSE

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut
