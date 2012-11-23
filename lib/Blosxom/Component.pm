package Blosxom::Component;
use strict;
use warnings;
use Blosxom::Plugin;

1;

__END__

=head1 NAME

Blosxom::Component - Base class for Blosxom components

=head1 SYNOPSIS

  package MyComponent;
  use parent 'Blosxom::Component';

=head1 DESCRIPTION

Base class for Blosxom components.

=head2 METHODS

=over 4

=item $class->requires

Declares a list of methods that must be defined to load this component.

  __PACKAGE__->requires(qw/req1 req2/);

=item $class->mk_accessors

  __PACKAGE__->mk_accessors(qw/foo bar baz/);

=item $class->init

  sub init {
      my ( $class, $caller, $config ) = @_;
      # do something
      $class->SUPER::init( $caller );
  }

=back

=head1 SEE ALSO

L<Blosxom::Plugin>, L<Role::Tiny>

=head1 AUTHOR

Ryo Anazawa

=head1 LICENSE AND COPYRIGHT

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut

