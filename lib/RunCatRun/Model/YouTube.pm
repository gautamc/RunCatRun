package RunCatRun::Model::YouTube;

use Carp;
use LWP::UserAgent;
use XML::XPath;
use XML::XPath::XMLParser;
use strict;

__PACKAGE__->config(
  dev_id => 'AI39si5jaR4gAG-hJh7hDNXTUQzW7a9lLsDUS5l1jQkt7e4-KzvfkGE3gxxOOE473h19HEkGZDOmICA6tORfG-IhEq_kOcAV-w',
  options => {},
);

use base 'Catalyst::Model';
use base qw(Class::Accessor::Fast);
__PACKAGE__->mk_accessors(qw(dev_id ua));

=head1 NAME

RunCatRun::Model::YouTube - YouTube Model Class

=head1 SYNOPSIS

See L<RunCatRun>

=head1 DESCRIPTION

YouTube Model Class.

=head1 AUTHOR


=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

sub new {
  my ( $self, $c, $arguments ) = @_;
  $self = $self->next::method(@_);

  if ( !$self->dev_id ) {
    croak 'dev_id is required';
  }
  if ( !$self->ua ) {
    $self->ua( LWP::UserAgent->new );
  }

  return $self;
}

sub get_listing {
  my ( $self, $tag ) = @_;

  my $uri =  "http://gdata.youtube.com/feeds/api/videos?q=" . $tag . "&key=" . $self->dev_id;
  my $res = $self->ua->get($uri);
  if ( !$res->is_success ) {
    print STDERR $res->status_line;
    return;
  }
  return $self->parse_xml( $res->content );
}

sub parse_xml {
  my ( $self, $xml ) = @_;
  my @data_map;
  my $feed = XML::XPath->new(xml => $xml);
  my $entry_set = $feed->find('/feed/entry');
  foreach my $entry_node_context ($entry_set->get_nodelist) {
    my %entry_map = {};
    $entry_map{'id'} = $feed->find('./id', $entry_node_context);
    $entry_map{'title'} = $feed->find('./title', $entry_node_context);
    $entry_map{'url'} = $feed->find('./link[@rel="alternate"]', $entry_node_context)->pop()->getAttribute('href');
    my $rating_node_set = $feed->find('./gd:rating', $entry_node_context);
    if( $rating_node_set->size() > 0 ) {
      $entry_map{'rating'} = $rating_node_set->pop()->getAttribute('average');
    }
    my $favecount_node_set = $feed->find('./yt:statistics', $entry_node_context);
    if( $favecount_node_set->size() > 0 ) {
      $entry_map{'fave_count'} = $favecount_node_set->pop()->getAttribute('favoriteCount');
    }
    my $image_node_set = $feed->find('./media:group/media:thumbnail', $entry_node_context);
    if( $image_node_set->size() > 0 ) {
      $entry_map{'snap'} = $image_node_set->pop()->getAttribute('url');
    }
    my $runtime_node_set = $feed->find('./media:group/yt:duration', $entry_node_context);
    if( $runtime_node_set->size() > 0 ) {
      $entry_map{'length_seconds'} = $runtime_node_set->pop()->getAttribute('seconds');
    }
    $entry_map{'author'} = $feed->find('./author/name', $entry_node_context);
    push(@data_map, \%entry_map);
  }
  return @data_map;
}

1;
