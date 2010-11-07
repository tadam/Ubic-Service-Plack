package Ubic::Service::PSGI;

use strict;
use warnings;

use base qw(Ubic::Service::Plack);

=head1 NAME

Ubic::Service::PSGI - deprecated module, see Ubic::Service::Plack instead

=head1 DESCRIPTION

This package got renamed into L<Ubic::Service::Plack> and will be removed soon.

=cut


=for Pod::Coverage defaults

=cut

sub defaults {
    return (
        env => 'deployment',
    );
}

1;
