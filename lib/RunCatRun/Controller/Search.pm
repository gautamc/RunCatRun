package RunCatRun::Controller::Search;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

RunCatRun::Controller::Search - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index :Path :Args(0) {
  my ( $self, $c ) = @_;
  my @videos = ();
  if ( $c->req->param('tags') ) {
    my $tube_instance = $c->model('YouTube');
    @videos = $tube_instance->get_listing($c->req->param('tags'));
  }
  $c->stash->{videos} = \@videos;
}


=head1 AUTHOR

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
