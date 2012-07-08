package Blosxom::Plugin;
use 5.008_009;
use strict;
use warnings;
use Blosxom::Header;

our $VERSION = '0.00001';

sub response { Blosxom::Header->instance }

1;

__END__

=head1 NAME

Blosxom::Plugin - Base class of Blosxom plugins

=head1 SYNOPSIS

  package foo;
  use strict;
  use warnings;
  use base 'Blosxom::Plugin';

  sub start { !$blosxom::static_entries }

  sub last {
      my $class = shift;
      $class->response->status( 304 );
  }

  1;

=head1 DESCRIPTION

Base class of Blosxom plugins.

=head2 METHODS

=over 4

=item $class->response

Returns a L<Blosxom::Header> object instance.

=item $class->request

Not implemented yet.

=item $class->config

Not implemented yet.

=back

=head1 DEPENDENCIES

L<Blosxom 2.0.0|http://blosxom.sourceforge.net/> or higher.

=head1 SEE ALSO

L<Blosxom::Header>

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
