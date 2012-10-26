package Blosxom::Component;
use strict;
use warnings;

sub init {
    my ( $class, $caller ) = @_;
    my $stash = do { no strict 'refs'; \%{"$class\::"} };
    while ( my ($method_name, $glob) = each %{$stash} ) {
        next unless defined *{$glob}{CODE};
        next if $method_name =~ /^_/ or $method_name eq 'init';
        $caller->add_method( $method_name => *{$glob}{CODE} );
    }
}

1;
