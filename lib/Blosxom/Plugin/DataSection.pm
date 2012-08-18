package Blosxom::Plugin::DataSection;
use strict;
use warnings;
use Data::Section::Simple;

sub begin {
    my $class  = shift;
    my $c      = shift;
    my $reader = Data::Section::Simple->new( $c );
    my $data   = $reader->get_data_section;

    while ( my ($basename, $template) = each %{ $data } ) {
        if ( my ($component, $flavour) = $basename =~ /(.*)\.([^.]*)/ ) {
            $blosxom::template{$flavour}{$component} = $template;
        }
    }

    $c->add_method( data_section => sub { $data } );

    return;
}

1;

__END__

=head1 NAME

Blosxom::Plugin::DataSection - Read data from __DATA__

=head1 SYNOPSIS

  my $template = $class->data_section->{'foo.html'};

=head1 DESCRIPTION

This module extracts data from L<__DATA__> section of the plugin
and merges them into Blosxom default templates.

=head1 SEE ALSO

L<Blosxom::Plugin>

=head1 AUTHOR

Ryo Anazawa <anazawa@cpan.org>

=head1 LICENSE

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut
