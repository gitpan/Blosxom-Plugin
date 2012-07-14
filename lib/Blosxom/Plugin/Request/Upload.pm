package Blosxom::Plugin::Request::Upload;
use strict;
use warnings;
use File::Spec::Unix;

sub new {
    my ( $class, %args ) = @_;
    my $self = bless {}, $class;
    my @keys = qw( filename fh headers tempname );
    @{ $self }{ @keys } = @args{ @keys };
    $self;
}

sub path     { shift->{tempname} }
sub filename { shift->{filename} }
sub fh       { shift->{fh}       }

sub content_type { shift->{headers}->{'Content-Type'} }

sub size {
    my $self = shift;
    return $self->{size} if exists $self->{size};
    $self->{size} = -s $self->{fh};
}

# Stolen from Plack::Request::Upload
sub basename {
    my $self = shift;
    return $self->{basename} if defined $self->{basename};
    ( my $basename = $self->{filename} ) =~ s{\\}{/}g;
    $basename = ( File::Spec::Unix->splitpath( $basename ) )[2];
    $basename =~ s{[^\w\.-]+}{_}g;
    $self->{basename} = $basename;
}

1;

__END__

=head1 NAME

Blosxom::Plugin::Request::Upload - Handles file upload requests

=head1 SYNOPSIS

  use Blosxom::Plugin::Request::Upload;
  use CGI;

  my $query = CGI->new;
  my $filename = $query->param( 'field' );

  my $upload = Blosxom::Plugin::Request::Upload->new(
      filename => "$filename",
      fh       => $filename,
      tempname => $query->tmpFileName( 'field' ),
      headers  => $query->uploadInfo( 'field' ),
  );

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

Returns the size of uploaded file.

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

This momdule was forked from L<Plack::Request::Upload>.

=head1 SEE ALSO

L<Blosxom::Plugin>, L<Plack::Request::Upload>

=head1 AUTHOR

Ryo Anazawa

=head1 LICENSE AND COPYRIGHT

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. See L<perlatistic>.

=cut
