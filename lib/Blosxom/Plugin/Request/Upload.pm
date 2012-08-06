package Blosxom::Plugin::Request::Upload;
use strict;
use warnings;
use File::Spec::Unix;

sub new {
    my ( $class, %args ) = @_;
    my $self = bless {}, $class;
    my @keys = qw( filename fh header tempname );
    @{ $self }{ @keys } = delete @args{ @keys };
    $self;
}

sub path     { shift->{tempname} }
sub filename { shift->{filename} }
sub fh       { shift->{fh}       }

sub content_type { shift->{header}->{'Content-Type'} }

sub size {
    my $self = shift;
    return $self->{size} if exists $self->{size};
    $self->{size} = -s $self->{fh};
}

# Stolen from Plack::Request::Upload
sub basename {
    my $self = shift;

    unless ( exists $self->{basename} ) {
        ( my $basename = $self->{filename} ) =~ s{\\}{/}g;
        $basename = ( File::Spec::Unix->splitpath($basename) )[2];
        $basename =~ s{[^\w\.-]+}{_}g;
        return $self->{basename} = $basename;
    }

    $self->{basename};
}

1;

__END__

=head1 NAME

Blosxom::Plugin::Request::Upload - Handles file upload requests

=head1 SYNOPSIS

  # $request is Blosxom::Plugin::Request
  my $upload = $request->upload( 'field' );

  $upload->size;
  $upload->path;
  $upload->content_type:
  $upload->fh;
  $upload->basename;

=head1 DESCRIPTION

Handles file upload requests.

=head2 METHODS

=over 4

=item $upload->size

Returns the size of uploaded file in bytes.

=item $upload->fh

Returns a read-only L<IO::File> handle on the temporary file.

=item $upload->path

Returns the path to the temporary file where uploaded file is saved.

=item $upload->content_type

Returns the content type of the uploaded file.

=item $upload->filename

Returns the original filename in the client.

=item $upload->basename

Returns basename for C<filename>.

=back

=head1 HISTORY

This module was forked from L<Plack::Request::Upload>.

=head1 SEE ALSO

L<Blosxom::Plugin::Request>, L<Plack::Request::Upload>

=head1 AUTHOR

Ryo Anazawa

=head1 LICENSE AND COPYRIGHT

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. See L<perlatistic>.

=cut
