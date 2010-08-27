package RunCatRun::View::TT;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
);

=head1 NAME

RunCatRun::View::TT - TT View for RunCatRun

=head1 DESCRIPTION

TT View for RunCatRun.

=head1 SEE ALSO

L<RunCatRun>

=head1 AUTHOR

mr. blue,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
