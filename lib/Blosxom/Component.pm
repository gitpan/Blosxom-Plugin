package Blosxom::Component;
use strict;
use warnings;

my %attribute_of;

sub mk_accessors {
    my $class = shift;
    while ( @_ ) {
        my $field = shift;
        my $default = ref $_[0] eq 'CODE' ? shift : undef;
        $attribute_of{ $class }{ $field } = $default;
    }
}

sub init {
    my ( $class, $caller ) = @_;

    my $namespace = do { no strict 'refs'; \%{"$class\::"} };
    while ( my ($method, $glob) = each %{$namespace} ) {
        if ( defined *{$glob}{CODE} and $method ne 'init' ) {
            $caller->add_method( $method => *{$glob}{CODE} );
        }
    }

    if ( my $attributes = $attribute_of{$class} ) {
        while ( my ($field, $default) = each %{$attributes} ) {
            $caller->add_attribute( $field => $default );
        }
    }

    return;
}

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

