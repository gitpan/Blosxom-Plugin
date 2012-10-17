package Blosxom::Plugin;
use 5.008_009;
use strict;
use warnings;
use Carp qw/croak/;

our $VERSION = '0.01001';

my %instance_of;

sub instance {
    my $class = shift; 
    $instance_of{ $class } ||= bless {}, $class;
}

sub end {
    my $class = shift;
    delete $instance_of{ $class };
    return;
}

sub load_components {
    my $class  = shift;
    my $prefix = __PACKAGE__;

    my ( $component, %has_conflict, %code_of );

    local *add_method = sub {
        my ( $class, $method, $code ) = @_;
        return if defined &{ "$class\::$method" };
        push @{ $has_conflict{$method} ||= [] }, $component;
        $code_of{ $method } = $code;
        return;
    };

    while ( @_ ) {
        $component = do {
            my $class = shift;

            unless ( $class =~ s/^\+// or $class =~ /^$prefix/ ) {
                $class = "$prefix\::$class";
            }

            ( my $file = $class ) =~ s{::}{/}g;
            require "$file.pm";

            $class;
        };

        my $config = ref $_[0] eq 'HASH' ? shift : undef;

        $component->init( $class, $config );
    }

    if ( %code_of ) {
        no strict 'refs';
        while ( my ($method, $components) = each %has_conflict ) {
            delete $has_conflict{ $method } if @{ $components } == 1;
            *{ "$class\::$method" } = $code_of{ $method };
        }
    }

    if ( %has_conflict ) {
        croak join "\n", map {
            "Due to a method name conflict between components " .
            "'" . join( ' and ', sort @{ $has_conflict{$_} } ) . "', " .
            "the method '$_' must be implemented by '$class'";
        } keys %has_conflict;
    }

    return;
}

sub has_method {
    my ( $class, $method ) = @_;
    defined &{ "$class\::$method" };
}

1;

__END__

=head1 NAME

Blosxom::Plugin - Base class for Blosxom plugins

=head1 SYNOPSIS

  package my_plugin;
  use strict;
  use warnings;
  use parent 'Blosxom::Plugin';

  __PACKAGE__->load_components( 'DataSection' );

  sub start {
      my $class = shift;

      my $template = $class->get_data_section( 'my_plugin.html' );
      # <!DOCTYPE html>
      # ...

      # merge __DATA__ into Blosxom default templates
      $class->merge_data_section_into( \%blosxom::template );

      return 1;
  }

  1;

  __DATA__

  @@ my_plugin.html

  <!DOCTYPE html>
  <html>
  <head>
    <meta charset="utf-8">
    <title>My Plugin</title>
  </head>
  <body>
  <h1>Hello, world</h1>
  </body>
  </html>

=head1 DESCRIPTION

Base class for Blosxom plugins.
Inspired by Blosxom 3 which was abandoned to be released.

=head2 BACKGROUND

Blosxom globalizes a lot of variables.
This module assigns them to appropriate namespaces
like 'Request', 'Response' or 'Config'.
In addition, it's intended that Blosxom::Plugin::* namespace will abstract
routines from Blosxom plugins.

=head2 METHODS

=over 4

=item $class->load_components( @comps )

=item $class->load_components( $comp => \%config, ... )

Loads the given components into the current module.
Components can be parameterized by the consumers.
If a module begins with a C<+> character,
it is taken to be a fully qualified class name,
otherwise C<Blosxom::Plugin> is prepended to it.

  package my_plugin;
  use parent 'Blosxom::Plugin';
  __PACKAGE__->load_components( '+MyComponent' => \%config );

This method calls C<init()> method of each component.
C<init()> is called as follows:

  MyComponent->init( 'my_plugin', \%config )

=item $class->add_method( $method => $coderef )

This method takes a method name and a subroutine reference,
and adds the method to the class.
Available while loading components.

  package MyComponent;

  sub init {
      my ( $class, $context, $config ) = @_;
      $context->add_method( foo => sub { ... } );
  }

If a method is already defined on the class, that method will not be composed
in from the component.
If multiple components are applied in a single call, then if any of their
provided methods clash, an exception is raised unless the class provides
the method.

=item $bool = $class->has_method( $method )

Returns a Boolean value telling whether or not the class defines the named
method. It does not include methods inherited from parent classes.

  my $requires = 'bar';

  sub init {
      my ( $class, $context ) = @_;
      unless ( $context->has_method($requires) ) {
          die "Cannot apply '$class' to '$context'";
      }
  }

=back

=head1 DEPENDENCIES

L<Blosxom 2.0.0|http://blosxom.sourceforge.net/> or higher.

=head1 SEE ALSO

L<Blosxom::Plugin::Web>,
L<Amon2>,
L<Moose::Manual::Roles>,
L<MooseX::Role::Parameterized::Tutorial>

=head1 ACKNOWLEDGEMENT

Blosxom was originally written by Rael Dohnfest.
L<The Blosxom Development Team|http://sourceforge.net/projects/blosxom/>
succeeded to the maintenance.

=head1 BUGS AND LIMITATIONS

This module is beta state. API may change without notice.

=head1 AUTHOR

Ryo Anazawa <anazawa@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2012 Ryo Anzawa. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=cut
