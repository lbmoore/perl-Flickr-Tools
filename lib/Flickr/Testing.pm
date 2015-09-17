package Flickr::Testing;

use strict;
use Test::MockObject;

=head1 NAME

Flickr::Testing - Private module for use with the tests.

=head1 VERSION

Version 0.04

=cut

our $VERSION = '0.04';

=head1 SYNOPSIS

This is an internal module, you don't want to use it and shouldn't depend on its existance.

=cut

=head1 FUNCTIONS

=head2 setup

Sets up the MockObject.

Don't use this or expect it to exist in the future.

=cut

sub setup {
  my $mock_api = Test::MockObject->new();
  $mock_api->fake_new('Flickr::API');
  $mock_api->mock(
    'execute_method',
    sub {
      my $s = shift;
      my $methodname = shift;
      my $params = shift;

      if ($methodname eq 'flickr.photos.getInfo') {
        my $r = {
        success => 1,
        tree => {
          'children' => [
                          {
                            'content' => ' ',
                            'type' => 'data'
                          },
                          {
                            'children' => [
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'children' => [],
                                              'type' => 'tag',
                                              'attributes' => {
                                                                'username' => 'John Doe',
                                                                'location' => '',
                                                                'realname' => 'John Doe',
                                                                'nsid' => '12345678@N00'
                                                              },
                                              'name' => 'owner'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'children' => [
                                                              {
                                                                'content' => 'Testing photo title',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag',
                                              'attributes' => {},
                                              'name' => 'title'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'children' => [
                                                              {
                                                                'content' => 'A test photo. Please disregard.',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag',
                                              'attributes' => {},
                                              'name' => 'description'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'children' => [],
                                              'type' => 'tag',
                                              'attributes' => {
                                                                'isfamily' => '0',
                                                                'ispublic' => '1',
                                                                'isfriend' => '0'
                                                              },
                                              'name' => 'visibility'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'children' => [],
                                              'type' => 'tag',
                                              'attributes' => {
                                                                'takengranularity' => '0',
                                                                'taken' => '2004-10-05 16:08:12',
                                                                'posted' => '1097663727'
                                                              },
                                              'name' => 'dates'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'children' => [],
                                              'type' => 'tag',
                                              'attributes' => {
                                                                'canaddmeta' => '0',
                                                                'cancomment' => '0'
                                                              },
                                              'name' => 'editability'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'children' => [
                                                              {
                                                                'content' => '2',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag',
                                              'attributes' => {},
                                              'name' => 'comments'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'children' => [
                                                                                {
                                                                                  'content' => 'An interesting tidbit.',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag',
                                                                'attributes' => {
                                                                                  'x' => '283',
                                                                                  'author' => '12345678@N00',
                                                                                  'id' => '612899',
                                                                                  'w' => '50',
                                                                                  'authorname' => 'John Doe',
                                                                                  'h' => '50',
                                                                                  'y' => '66'
                                                                                },
                                                                'name' => 'note'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'children' => [
                                                                                {
                                                                                  'content' => 'Another interesting tidbit.',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag',
                                                                'attributes' => {
                                                                                  'x' => '41',
                                                                                  'author' => '12345678@N00',
                                                                                  'id' => '612900',
                                                                                  'w' => '24',
                                                                                  'authorname' => 'John Doe',
                                                                                  'h' => '45',
                                                                                  'y' => '305'
                                                                                },
                                                                'name' => 'note'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'children' => [
                                                                                {
                                                                                  'content' => 'Yet another great tidbit.',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag',
                                                                'attributes' => {
                                                                                  'x' => '30',
                                                                                  'author' => '12345678@N00',
                                                                                  'id' => '612902',
                                                                                  'w' => '277',
                                                                                  'authorname' => 'John Doe',
                                                                                  'h' => '92',
                                                                                  'y' => '362'
                                                                                },
                                                                'name' => 'note'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag',
                                              'attributes' => {},
                                              'name' => 'notes'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'children' => [
                                                                                {
                                                                                  'content' => 'test1',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag',
                                                                'attributes' => {
                                                                                  'author' => '12345678@N00',
                                                                                  'id' => '2360156',
                                                                                  'raw' => 'test1'
                                                                                },
                                                                'name' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'children' => [
                                                                                {
                                                                                  'content' => 'test2',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag',
                                                                'attributes' => {
                                                                                  'author' => '12345678@N00',
                                                                                  'id' => '2360157',
                                                                                  'raw' => 'test2'
                                                                                },
                                                                'name' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'children' => [
                                                                                {
                                                                                  'content' => 'test3',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag',
                                                                'attributes' => {
                                                                                  'author' => '12345678@N00',
                                                                                  'id' => '2360158',
                                                                                  'raw' => 'test3'
                                                                                },
                                                                'name' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag',
                                              'attributes' => {},
                                              'name' => 'tags'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            }
                                          ],
                            'type' => 'tag',
                            'attributes' => {
                                              'dateuploaded' => '1097663727',
                                              'id' => '123456',
                                              'server' => '1',
                                              'secret' => 'ae146eb33f',
                                              'rotation' => '0',
                                              'isfavorite' => '0',
                                              'license' => '0'
                                            },
                            'name' => 'photo'
                          },
                          {
                            'content' => ' ',
                            'type' => 'data'
                          }
                        ],
          'type' => 'tag',
          'attributes' => {
                            'stat' => 'ok'
                          },
          'name' => 'rsp'
          }
        };
        return $r;
      }
      elsif ($methodname eq 'flickr.photos.getExif') {
        my $r = {
        success => 1,
        tree => {
          'name' => 'rsp',
          'attributes' => {
                            'stat' => 'ok'
                          },
          'children' => [
                          {
                            'content' => ' ',
                            'type' => 'data'
                          },
                          {
                            'name' => 'photo',
                            'attributes' => {
                                              'id' => '12345678',
                                              'server' => '1',
                                              'secret' => 'ae146ebeef'
                                            },
                            'children' => [
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'Make',
                                                                'tag' => '271',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => 'Canon',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'Model',
                                                                'tag' => '272',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => 'Canon EOS 10D',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'Orientation',
                                                                'tag' => '274',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '1',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'X-Resolution',
                                                                'tag' => '282',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '11796480/65536',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'Y-Resolution',
                                                                'tag' => '283',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '11796480/65536',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'Resolution Unit',
                                                                'tag' => '296',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '2',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'Software',
                                                                'tag' => '305',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => 'QuickTime 6.5.1',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'Date Time',
                                                                'tag' => '306',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '2004:10:05 19:22:58',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'YCbCr Positioning',
                                                                'tag' => '531',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '1',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'clean',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => 'Centered',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'Exif IFD',
                                                                'tag' => '34665',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '264',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'ISO Speed',
                                                                'tag' => '34855',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '100',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'Exif Version',
                                                                'tag' => '36864',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '0220',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'Date and Time (Original)',
                                                                'tag' => '36867',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '2004:10:05 16:08:12',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'Date and Time (Digitized)',
                                                                'tag' => '36868',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '2004:10:05 16:08:12',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'Components Configuration',
                                                                'tag' => '37121',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '...',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'Shutter Speed',
                                                                'tag' => '37377',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '456704/65536',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'Aperture',
                                                                'tag' => '37378',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '393216/65536',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'Exposure Bias',
                                                                'tag' => '37380',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '0/6',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'clean',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '0/6 EV',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'Focal Length',
                                                                'tag' => '37386',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '46/1',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'clean',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '46 mm',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'Maker Note',
                                                                'tag' => '37500',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '.',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'FlashPix Version',
                                                                'tag' => '40960',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '0100',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'Color Space',
                                                                'tag' => '40961',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '65535',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'clean',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => 'Uncalibrated',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'Pixel X-Dimension',
                                                                'tag' => '40962',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '1536',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'Pixel Y-Dimension',
                                                                'tag' => '40963',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '1024',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'Focal Plane X-Resolution',
                                                                'tag' => '41486',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '1572864/914',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'clean',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '1720.858',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'Focal Plane Y-Resolution',
                                                                'tag' => '41487',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '1048576/610',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'clean',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '1718.977',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'name' => 'exif',
                                              'attributes' => {
                                                                'tagspaceid' => '0',
                                                                'label' => 'Focal Plane Resolution Unit',
                                                                'tag' => '41488',
                                                                'tagspace' => 'EXIF'
                                                              },
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'raw',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => '2',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'name' => 'clean',
                                                                'attributes' => {},
                                                                'children' => [
                                                                                {
                                                                                  'content' => 'Inches',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            }
                                          ],
                            'type' => 'tag'
                          },
                          {
                            'content' => ' ',
                            'type' => 'data'
                          }
                        ],
          'type' => 'tag'
          }
        };
	return $r;
      }
      elsif ($methodname eq 'flickr.photos.getContext') {
        my $r = {
        success => 1,
        tree => {
          'attributes' => {
                            'stat' => 'ok'
                          },
          'name' => 'rsp',
          'children' => [
                          {
                            'content' => ' ',
                            'type' => 'data'
                          },
                          {
                            'attributes' => {},
                            'name' => 'count',
                            'children' => [
                                            {
                                              'content' => '154',
                                              'type' => 'data'
                                            }
                                          ],
                            'type' => 'tag'
                          },
                          {
                            'attributes' => {
                                              'id' => '851194',
                                              'title' => 'A Previous photo.',
                                              'url' => '/photos/johndoe/851194/in/photostream/',
                                              'secret' => 'eba434b33f',
                                              'thumb' => 'http://photos1.flickr.com/851194_eba434b33f_s.jpg'
                                            },
                            'name' => 'prevphoto',
                            'children' => [],
                            'type' => 'tag'
                          },
                          {
                            'content' => ' ',
                            'type' => 'data'
                          },
                          {
                            'attributes' => {
                                              'id' => '851196',
                                              'title' => 'A Next photo.',
                                              'url' => '/photos/johndoe/851196/in/photostream/',
                                              'secret' => 'acdfa9beef',
                                              'thumb' => 'http://photos1.flickr.com/851196_acdfa9beef_s.jpg'
                                            },
                            'name' => 'nextphoto',
                            'children' => [],
                            'type' => 'tag'
                          },
                          {
                            'content' => ' ',
                            'type' => 'data'
                          }
                        ],
          'type' => 'tag'
	  }
	};
	return $r;
      }
      elsif ($methodname eq 'flickr.photos.getSizes') {
        my $r = {
        success => 1,
        tree => {
          'children' => [
                          {
                            'content' => ' ',
                            'type' => 'data'
                          },
                          {
                            'children' => [
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'children' => [],
                                              'attributes' => {
                                                                'source' => 'http://photos1.flickr.com/851195_ae146eb33f_s.jpg',
                                                                'height' => '75',
                                                                'label' => 'Square',
                                                                'width' => '75',
                                                                'url' => 'http://www.flickr.com/photo_zoom.gne?id=851195&amp;size=sq'
                                                              },
                                              'name' => 'size',
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'children' => [],
                                              'attributes' => {
                                                                'source' => 'http://photos1.flickr.com/851195_ae146eb33f_t.jpg',
                                                                'height' => '100',
                                                                'label' => 'Thumbnail',
                                                                'width' => '67',
                                                                'url' => 'http://www.flickr.com/photo_zoom.gne?id=851195&amp;size=t'
                                                              },
                                              'name' => 'size',
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'children' => [],
                                              'attributes' => {
                                                                'source' => 'http://photos1.flickr.com/851195_ae146eb33f_m.jpg',
                                                                'height' => '240',
                                                                'label' => 'Small',
                                                                'width' => '160',
                                                                'url' => 'http://www.flickr.com/photo_zoom.gne?id=851195&amp;size=s'
                                                              },
                                              'name' => 'size',
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'children' => [],
                                              'attributes' => {
                                                                'source' => 'http://photos1.flickr.com/851195_ae146eb33f.jpg',
                                                                'height' => '500',
                                                                'label' => 'Medium',
                                                                'width' => '333',
                                                                'url' => 'http://www.flickr.com/photo_zoom.gne?id=851195&amp;size=m'
                                                              },
                                              'name' => 'size',
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'children' => [],
                                              'attributes' => {
                                                                'source' => 'http://photos1.flickr.com/851195_ae146eb33f_b.jpg',
                                                                'height' => '1024',
                                                                'label' => 'Large',
                                                                'width' => '683',
                                                                'url' => 'http://www.flickr.com/photo_zoom.gne?id=851195&amp;size=l'
                                                              },
                                              'name' => 'size',
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'children' => [],
                                              'attributes' => {
                                                                'source' => 'http://photos1.flickr.com/851195_ae146eb33f_o.jpg',
                                                                'height' => '1536',
                                                                'label' => 'Original',
                                                                'width' => '1024',
                                                                'url' => 'http://www.flickr.com/photo_zoom.gne?id=851195&amp;size=o'
                                                              },
                                              'name' => 'size',
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            }
                                          ],
                            'attributes' => {},
                            'name' => 'sizes',
                            'type' => 'tag'
                          },
                          {
                            'content' => ' ',
                            'type' => 'data'
                          }
                        ],
          'attributes' => {
                            'stat' => 'ok'
                          },
          'name' => 'rsp',
          'type' => 'tag'
	  }
	};
	return $r;
      }
      elsif ($methodname eq 'flickr.photos.getPerms') {
        my $r = {
        success => 1,
        tree => {
          'attributes' => {
                            'stat' => 'ok'
                          },
          'children' => [
                          {
                            'content' => ' ',
                            'type' => 'data'
                          },
                          {
                            'attributes' => {
                                              'permaddmeta' => '0',
                                              'isfamily' => '0',
                                              'permcomment' => '0',
                                              'isfriend' => '0',
                                              'ispublic' => '1',
                                              'id' => '851195'
                                            },
                            'children' => [],
                            'name' => 'perms',
                            'type' => 'tag'
                          },
                          {
                            'content' => ' ',
                            'type' => 'data'
                          }
                        ],
          'name' => 'rsp',
          'type' => 'tag'
	  }
	};
	return $r;
      }
      elsif (($methodname eq 'flickr.people.findByUsername') ||
             ($methodname eq 'flickr.people.findByEmail')) {
        my $r = {
          tree => {
            'attributes' => {
                            'stat' => 'ok'
                          },
            'children' => [
                          {
                            'content' => ' ',
                            'type' => 'data'
                          },
                          {
                            'attributes' => {
                                              'id' => '12345678@N00',
                                              'nsid' => '12345678@N00'
                                            },
                            'children' => [
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'attributes' => {},
                                              'children' => [
                                                              {
                                                                'content' => 'Jane Doe',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'name' => 'username',
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            }
                                          ],
                            'name' => 'user',
                            'type' => 'tag'
                          },
                          { 
                            'content' => ' ',
                            'type' => 'data'
                          }
                        ],
            'name' => 'rsp',
            'type' => 'tag'
          },
          success => 1
	    };
	    return $r;
      }
      elsif ($methodname eq 'flickr.people.getInfo') {
        my $r = {
          success => 1,
          tree => {
          'children' => [
                          {
                            'content' => ' ',
                            'type' => 'data'
                          },
                          {
                            'children' => [
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'children' => [
                                                              {
                                                                'content' => 'JaneDoe',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'attributes' => {},
                                              'name' => 'username',
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'children' => [
                                                              {
                                                                'content' => 'Jane Doe',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'attributes' => {},
                                              'name' => 'realname',
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'children' => [],
                                              'attributes' => {},
                                              'name' => 'location',
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'children' => [
                                                                                {
                                                                                  'content' => '2002-10-26 17:48:14',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'attributes' => {},
                                                                'name' => 'firstdatetaken',
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'children' => [
                                                                                {
                                                                                  'content' => '1071510391',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'attributes' => {},
                                                                'name' => 'firstdate',
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'children' => [
                                                                                {
                                                                                  'content' => '573',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'attributes' => {},
                                                                'name' => 'count',
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'attributes' => {},
                                              'name' => 'photos',
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            }
                                          ],
                            'attributes' => {
                                              'id' => '12345678@N00',
                                              'iconserver' => '1',
                                              'isadmin' => '0',
                                              'nsid' => '12345678@N00',
                                              'ispro' => '1'
                                            },
                            'name' => 'person',
                            'type' => 'tag'
                          },
                          {
                            'content' => ' ',
                            'type' => 'data'
                          }
                        ],
          'attributes' => {
                            'stat' => 'ok'
                          },
          'name' => 'rsp',
          'type' => 'tag'
                  }
        }
      }
      elsif ($methodname eq 'flickr.photosets.getList') {
        my $r = {
	  success => 1,
	  tree => {
          'attributes' => {
                            'stat' => 'ok'
                          },
          'name' => 'rsp',
          'type' => 'tag',
          'children' => [
                          {
                            'content' => ' ',
                            'type' => 'data'
                          },
                          {
                            'attributes' => {
                                              'cancreate' => '1'
                                            },
                            'name' => 'photosets',
                            'type' => 'tag',
                            'children' => [
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'attributes' => {
                                                                'photos' => '19',
                                                                'id' => '12345',
                                                                'server' => '11',
                                                                'secret' => '22b11db33f',
                                                                'primary' => '12345678'
                                                              },
                                              'name' => 'photoset',
                                              'type' => 'tag',
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'attributes' => {},
                                                                'name' => 'title',
                                                                'type' => 'tag',
                                                                'children' => [
                                                                                {
                                                                                  'content' => 'Test1',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ]
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'attributes' => {},
                                                                'name' => 'description',
                                                                'type' => 'tag',
                                                                'children' => [
                                                                                {
                                                                                  'content' => 'A test fotoset',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ]
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ]
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'attributes' => {
                                                                'photos' => '11',
                                                                'id' => '123457',
                                                                'server' => '5',
                                                                'secret' => 'd29031b33f',
                                                                'primary' => '7654321'
                                                              },
                                              'name' => 'photoset',
                                              'type' => 'tag',
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'attributes' => {},
                                                                'name' => 'title',
                                                                'type' => 'tag',
                                                                'children' => [
                                                                                {
                                                                                  'content' => 'Second Test Set',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ]
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'attributes' => {},
                                                                'name' => 'description',
                                                                'type' => 'tag',
                                                                'children' => [
                                                                                {
                                                                                  'content' => 'This is a description

Of a test photoset.

Enjoy!',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ]
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ]
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            }
                                          ]
                          },
                          {
                            'content' => ' ',
                            'type' => 'data'
                          }
                        ]
	  }
	};
	return $r;
      }
      elsif ($methodname eq 'flickr.photosets.getPhotos') {
        my $r = {
	  success => 1,
	  tree => {
          'type' => 'tag',
          'children' => [
                          {
                            'type' => 'data',
                            'content' => ' '
                          },
                          {
                            'type' => 'tag',
                            'children' => [
                                            {
                                              'type' => 'data',
                                              'content' => ' '
                                            },
                                            {
                                              'type' => 'tag',
                                              'children' => [],
                                              'name' => 'photo',
                                              'attributes' => {
                                                                'title' => 'CRW_1234.JPG',
                                                                'secret' => 'ae146eb33f',
                                                                'isprimary' => '1',
                                                                'server' => '1',
                                                                'id' => '665432'
                                                              }
                                            },
                                            {
                                              'type' => 'tag',
                                              'children' => [],
                                              'name' => 'photo',
                                              'attributes' => {
                                                                'title' => 'CRW_7762.JPG',
                                                                'secret' => 'eba434b33f',
                                                                'isprimary' => '0',
                                                                'server' => '1',
                                                                'id' => '998132'
                                                              }
                                            },
                                            {
                                              'type' => 'tag',
                                              'children' => [],
                                              'name' => 'photo',
                                              'attributes' => {
                                                                'title' => 'my_great holliday_photo.jpg',
                                                                'secret' => '8aae10b33f',
                                                                'isprimary' => '0',
                                                                'server' => '1',
                                                                'id' => '887156'
                                                              }
                                            },
                                            {
                                              'type' => 'tag',
                                              'children' => [],
                                              'name' => 'photo',
                                              'attributes' => {
                                                                'title' => 'CRW_7762.JPG',
                                                                'secret' => '6b1639b33f',
                                                                'isprimary' => '0',
                                                                'server' => '1',
                                                                'id' => '986653'
                                                              }
                                            },
                                            {
                                              'type' => 'tag',
                                              'children' => [],
                                              'name' => 'photo',
                                              'attributes' => {
                                                                'title' => 'CRW_3431.JPG',
                                                                'secret' => '0a2bd2b33f',
                                                                'isprimary' => '0',
                                                                'server' => '1',
                                                                'id' => '857233'
                                                              }
                                            },
                                          ],
                            'name' => 'photoset',
                            'attributes' => {
                                              'id' => '21821',
                                              'primary' => '665432'
                                            }
                          },
                          {
                            'type' => 'data',
                            'content' => ' '
                          }
                        ],
          'name' => 'rsp',
          'attributes' => {
                            'stat' => 'ok'
                          }
	      }
	    };
	    return $r;
      }
      elsif ($methodname eq 'flickr.photosets.getInfo') {
        my $r = {
	      success => 1,
	      tree => {
          'children' => [
                          {
                            'content' => ' ',
                            'type' => 'data'
                          },
                          {
                            'children' => [
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'children' => [
                                                              {
                                                                'content' => 'A great test photoset',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'attributes' => {},
                                              'name' => 'title',
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'children' => [
                                                              {
                                                                'content' => 'A great test album!',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'attributes' => {},
                                              'name' => 'description',
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            }
                                          ],
                            'attributes' => {
                                              'owner' => '12345678@N00',
                                              'id' => '12345',
                                              'photos' => '16',
                                              'secret' => 'ae14b33fc0',
                                              'primary' => '866554'
                                            },
                            'name' => 'photoset',
                            'type' => 'tag'
                          },
                          {
                            'content' => ' ',
                            'type' => 'data'
                          }
                        ],
          'attributes' => {
                            'stat' => 'ok'
                          },
          'name' => 'rsp',
          'type' => 'tag'
          }
        };
        return $r;
      }
      elsif ($methodname eq 'flickr.photosets.getContext') {
        my $r = {
	      success => 1,
	      tree => {
          'type' => 'tag',
          'children' => [
                          {
                            'type' => 'data',
                            'content' => ' '
                          },
                          {
                            'type' => 'tag',
                            'children' => [
                                            {
                                              'type' => 'data',
                                              'content' => '22'
                                            }
                                          ],
                            'attributes' => {},
                            'name' => 'count'
                          },
                          {
                            'type' => 'tag',
                            'children' => [],
                            'attributes' => {
                                              'title' => 'The previous photo in the set.',
                                              'url' => '/photos/jdoe/866542/in/set-12345/',
                                              'id' => '866542',
                                              'thumb' => 'http://photos7.flickr.com/866542_b33fa99a70_s.jpg',
                                              'secret' => 'b33fa99a70'
                                            },
                            'name' => 'prevphoto'
                          },
                          {
                            'type' => 'data',
                            'content' => ' '
                          },
                          {
                            'type' => 'tag',
                            'children' => [],
                            'attributes' => {
                                              'title' => 'The next photo in the set.',
                                              'url' => '/photos/jdoe/866544/in/set-12345/',
                                              'id' => '866544',
                                              'thumb' => 'http://photos7.flickr.com/866544_d34db33f_s.jpg',
                                              'secret' => 'd34db33f'
                                            },
                            'name' => 'nextphoto'
                          },
                          {
                            'type' => 'data',
                            'content' => ' '
                          }
                        ],
          'attributes' => {
                            'stat' => 'ok'
                          },
          'name' => 'rsp'
          }
        };
        return $r;
      }
    }
  );
}

1;
