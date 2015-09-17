package Flickr::API::Utils;

use warnings;
use strict;

=head1 NAME

Flickr::API::Utils - Provides helpfull functions for dealing with the Flickr API.

=head1 VERSION

Version 0.04

=cut

our $VERSION = '0.04';

=head1 SYNOPSIS

This module provides functions that may be used to "clean up" the response from a Flickr::API call, test results and so on.


Usage example:

    use Flickr::Utils;

    my $toolbox = Flickr::Utils->new();

    my $prettystruct = $toolbox->clean($response_from_flickr_api_call);

=head1 FUNCTIONS

=head2 new

=cut

sub new {
  my $class = shift;

  my $s = {};

  return bless $s, $class;
}

=head2 clean

Takes a structure generated by a Flickr::API call and cleans it up for your Perl code to enjoy.

The response from that class is a hash created by a XML parser which is rather difficult to parse.

This module gets that response and creates a rather more "perlish" structure with the same information.

This cleaning up is done on a fully automated manner so it may still not be what you want. Some rather more usefull modules are Flickr::API::Photos, Flickr::API::People, etc which use this as a first pass at getting a decent response.

=cut

sub clean {
  my $s = shift;
  my $response = shift;
  my $result = shift;
  
  _recurseParse($response->{tree}, $result);
}

=head2 test_return

Checks to see if the response of the Flickr API was successfull or not.

If it was successfull fill in the return->success field in the object that was passed on to us, otherwise fill in this field and the other two relevant ones: result->error_code and result->error_message.

=cut

sub test_return {
  my $s = shift;
  my $response = shift;
  my $result = shift;
  
  if (!$response) {
    $result->{success} = 0;
    $result->{error_message} = "Didn't get any data to verify";
    return 0;
  }
  
  $result->{success} = $response->{success};
  
  if (!$result->{success}) {
    $result->{error_code} = $response->{error_code};
    $result->{error_message} = $response->{error_message};
  }

  return $result->{success};
}

=head2 auto_parse

Parses a piece of the XML structure (an ARRAY) that the Flickr::API returns according to some rules laid out by the user.

=cut

sub auto_parse {
  my $s = shift;
  my $xml = shift;
  my $rules = shift;

  my $result;
 
  foreach my $item (@$xml) {
    next if (($item->{type} eq 'data') and ($item->{content} =~ /^\s*$/ ));
    if (exists($rules->{$item->{name}})) {
      if ($rules->{$item->{name}} eq 'attributes') {
        $result->{$item->{name}} = {};
        $s->get_attributes($item, $result->{$item->{name}});
      }
      elsif ($rules->{$item->{name}} eq 'simple_content') {
        $result->{$item->{name}} = $s->get_simple_content($item);
      }
      elsif ($rules->{$item->{name}} eq 'attributes&simple_content') {
        $result->{$item->{name}} = {};
        $s->get_attributes($item, $result->{$item->{name}});
        $result->{$item->{name}}{value} = $s->get_simple_content($item);
      }
      elsif ($rules->{$item->{name}}{complex} eq 'array') {
        $result->{$item->{name}} = [];
        foreach my $arrayitem (@{$item->{children}}) {
          my $parse_result = $s->auto_parse([$arrayitem], $rules->{$item->{name}});
          if ($parse_result) {
            push @{$result->{$item->{name}}}, $parse_result;
          }
        }
      }
      elsif ($rules->{$item->{name}}{complex} eq 'flatten_array') {
        $result = {};
        $s->get_attributes($item, $result);
        foreach my $arrayitem (@{$item->{children}}) {
          my $parse_result = $s->auto_parse([$arrayitem], $rules->{$item->{name}});
          if ($parse_result) {
            %$result = (%$result, %$parse_result);
          }
        }
      }
    }
    else {
      print STDERR "How odd, I don't know anything about an '".$item->{name}."'element... Ignoring it.\n";
    }
  }
  
  return $result;
}

=head2 get_attributes

Gets the attributes for a given node of the XML tree.

=cut

sub get_attributes {
  my $s = shift;
  my $xml = shift;
  my $result = shift;


  foreach my $attr (keys %{$xml->{attributes}}) {
    $result->{$attr} = $xml->{attributes}{$attr};
  }
}

=head2 get_simple_content

Gets the content for a given node of the XML tree. It is assumed that this node has a single element with content.

=cut

sub get_simple_content {
  my $s = shift;
  my $xml = shift;

  return $xml->{children}[0]{content};
}




########################
# Helper functions
########################
sub _recurseParse {
  my $data = shift;
  my $result = shift;
  
  #return unless (exists($data->{type}) and ($data->{type} eq 'tag'));
  if (exists($data->{type})) {
    if ($data->{type} eq 'tag') {
      foreach my $elem (keys(%{$data->{attributes}})) {
        $result->{$data->{name}}{$elem} = $data->{attributes}{$elem};
      }
  
      foreach my $child (@{$data->{children}}) {
        _recurseParse($child, $result);
      }
    }
    elsif ($data->{type} eq 'data') {
      if (exists($data->{content}) and 
          defined($data->{content}) and
          ($data->{content} !~ /^\s*$/)) {
        $result->{content} = $data->{content};
      }
    }
    else {
      return;
    }
  }
}


=head1 AUTHOR

Nuno Nunes, C<< <nfmnunes@cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-flickr-user@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Flickr-Utils>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2005 Nuno Nunes, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Flickr::API::Clean
