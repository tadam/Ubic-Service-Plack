package Ubic::Service::PSGI;

use strict;
use warnings;

use base qw(Ubic::Service::Plack);

# ABSTRACT: deprecated module, see Ubic::Service::Plack instead

=head1 DESCRIPTION

This package got renamed into L<Ubic::Service::Plack> and will be removed soon.

=cut

sub new {
    my $class = shift;
    warn "Ubic::Service::PSGI is deprecated, use Ubic::Service::Plack instead";
    $class->SUPER::new(@_);
}


=for Pod::Coverage defaults

=cut

sub defaults {
    return (
        env => 'deployment',
    );
}

1;
