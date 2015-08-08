use Test::More tests => 5;

BEGIN {
use_ok( 'Flickr::API::Utils' );
}

diag("Testing Flickr::API::Utils");

my $api_result = {
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
                                              'license' => '0',
                                              'rotation' => '0',
                                              'dateuploaded' => '1097663727',
                                              'server' => '1',
                                              'id' => '123456',
                                              'secret' => 'ae146eb33f',
                                              'isfavorite' => '0'
                                            },
                            'children' => [
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'attributes' => {
                                                                'nsid' => '12345678@N00',
                                                                'username' => 'Jane Doe',
                                                                'realname' => 'Jane Doe',
                                                                'location' => ''
                                                              },
                                              'children' => [],
                                              'name' => 'owner',
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'attributes' => {},
                                              'children' => [
                                                              {
                                                                'content' => 'CRW_9780_JFR.JPG',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'name' => 'title',
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'attributes' => {},
                                              'children' => [
                                                              {
                                                                'type' => 'data',
                                                                'content' => 'A test photo. Please disregard.'
                                                              }
                                                            ],
                                              'name' => 'description',
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'attributes' => {
                                                                'ispublic' => '1',
                                                                'isfamily' => '0',
                                                                'isfriend' => '0'
                                                              },
                                              'children' => [],
                                              'name' => 'visibility',
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'attributes' => {
                                                                'posted' => '1097663727',
                                                                'takengranularity' => '0',
                                                                'taken' => '2004-10-05 16:08:12'
                                                              },
                                              'children' => [],
                                              'name' => 'dates',
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'attributes' => {
                                                                'canaddmeta' => '0',
                                                                'cancomment' => '0'
                                                              },
                                              'children' => [],
                                              'name' => 'editability',
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'attributes' => {},
                                              'children' => [
                                                              {
                                                                'content' => '2',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'name' => 'comments',
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'attributes' => {},
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'attributes' => {
                                                                                  'y' => '66',
                                                                                  'h' => '50',
                                                                                  'w' => '50',
                                                                                  'authorname' => 'Jane Doe',
                                                                                  'author' => '12345678@N00',
                                                                                  'id' => '123456',
                                                                                  'x' => '283'
                                                                                },
                                                                'children' => [
                                                                                {
                                                                                  'content' => 'An interesting tidbit.',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'name' => 'note',
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'attributes' => {
                                                                                  'y' => '305',
                                                                                  'h' => '45',
                                                                                  'w' => '24',
                                                                                  'authorname' => 'Jane Doe',
                                                                                  'author' => '12345678@N00',
                                                                                  'id' => '123457',
                                                                                  'x' => '41'
                                                                                },
                                                                'children' => [
                                                                                {
                                                                                  'content' => 'Another interesting tidbit.',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'name' => 'note',
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'attributes' => {
                                                                                  'y' => '362',
                                                                                  'h' => '92',
                                                                                  'w' => '277',
                                                                                  'authorname' => 'Jane Doe',
                                                                                  'author' => '12345678@N00',
                                                                                  'id' => '123458',
                                                                                  'x' => '30'
                                                                                },
                                                                'children' => [
                                                                                {
                                                                                  'content' => 'Yet another great tidbit.',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'name' => 'note',
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'name' => 'notes',
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            },
                                            {
                                              'attributes' => {},
                                              'children' => [
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'attributes' => {
                                                                                  'raw' => 'ericeira',
                                                                                  'author' => '12345678@N00',
                                                                                  'id' => '1234567'
                                                                                },
                                                                'children' => [
                                                                                {
                                                                                  'content' => 'ericeira',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'name' => 'tag',
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'attributes' => {
                                                                                  'raw' => 'passeios',
                                                                                  'author' => '12345678@N00',
                                                                                  'id' => '1234568'
                                                                                },
                                                                'children' => [
                                                                                {
                                                                                  'content' => 'passeios',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'name' => 'tag',
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              },
                                                              {
                                                                'attributes' => {
                                                                                  'raw' => 'janela',
                                                                                  'author' => '12345678@N00',
                                                                                  'id' => '1234569'
                                                                                },
                                                                'children' => [
                                                                                {
                                                                                  'content' => 'janela',
                                                                                  'type' => 'data'
                                                                                }
                                                                              ],
                                                                'name' => 'tag',
                                                                'type' => 'tag'
                                                              },
                                                              {
                                                                'content' => ' ',
                                                                'type' => 'data'
                                                              }
                                                            ],
                                              'name' => 'tags',
                                              'type' => 'tag'
                                            },
                                            {
                                              'content' => ' ',
                                              'type' => 'data'
                                            }
                                          ],
                            'name' => 'photo',
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


my $utils = Flickr::API::Utils->new();

isa_ok($utils, 'Flickr::API::Utils');

my $t = {};
is($utils->test_return($api_result, $t), 1, 'test_return');

$utils->get_attributes($api_result->{tree}{children}[1], $t);

my $expected_result = {
  rotation => 0,
  isfavorite => 0,
  secret => 'ae146eb33f',
  license => 0,
  dateuploaded => 1097663727,
  server => 1,
  id => 123456,
  success => 1
};

is_deeply($t, $expected_result, 'get_attributes');

my $interesting = {
      owner => 'attributes',
      visibility => 'attributes',
      dates => 'attributes',
      title => 'simple_content',
      description => 'simple_content',
      permissions => 'attributes',
      editability => 'attributes',
      comments => 'simple_content',
      notes => {
        complex => 'array',
        note => 'attributes&simple_content',
      },
      tags => {
        complex => 'array',
        tag => 'attributes&simple_content',
      },
    };


my $parse_result = $utils->auto_parse($api_result->{tree}{children}[1]{children}, $interesting);
%$t = (%$t, %$parse_result);

$expected_result = {
          'license' => '0',
          'owner' => {
                       'nsid' => '12345678@N00',
                       'realname' => 'Jane Doe',
                       'location' => '',
                       'username' => 'Jane Doe'
                     },
          'description' => 'A test photo. Please disregard.',
          'success' => 1,
          'secret' => 'ae146eb33f',
          'isfavorite' => '0',
          'notes' => [
                       {
                         'note' => {
                                     'w' => '50',
                                     'id' => '123456',
                                     'value' => 'An interesting tidbit.',
                                     'y' => '66',
                                     'h' => '50',
                                     'x' => '283',
                                     'authorname' => 'Jane Doe',
                                     'author' => '12345678@N00'
                                   }
                       },
                       {
                         'note' => {
                                     'w' => '24',
                                     'id' => '123457',
                                     'value' => 'Another interesting tidbit.',
                                     'y' => '305',
                                     'h' => '45',
                                     'x' => '41',
                                     'authorname' => 'Jane Doe',
                                     'author' => '12345678@N00'
                                   }
                       },
                       {
                         'note' => {
                                     'w' => '277',
                                     'id' => '123458',
                                     'value' => 'Yet another great tidbit.',
                                     'y' => '362',
                                     'h' => '92',
                                     'x' => '30',
                                     'authorname' => 'Jane Doe',
                                     'author' => '12345678@N00'
                                   }
                       }
                     ],
          'dateuploaded' => '1097663727',
          'dates' => {
                       'takengranularity' => '0',
                       'posted' => '1097663727',
                       'taken' => '2004-10-05 16:08:12'
                     },
          'title' => 'CRW_9780_JFR.JPG',
          'tags' => [
                      {
                        'tag' => {
                                   'raw' => 'ericeira',
                                   'id' => '1234567',
                                   'value' => 'ericeira',
                                   'author' => '12345678@N00'
                                 }
                      },
                      {
                        'tag' => {
                                   'raw' => 'passeios',
                                   'id' => '1234568',
                                   'value' => 'passeios',
                                   'author' => '12345678@N00'
                                 }
                      },
                      {
                        'tag' => {
                                   'raw' => 'janela',
                                   'id' => '1234569',
                                   'value' => 'janela',
                                   'author' => '12345678@N00'
                                 }
                      }
                    ],
          'comments' => '2',
          'server' => '1',
          'id' => '123456',
          'rotation' => '0',
          'visibility' => {
                            'isfriend' => '0',
                            'ispublic' => '1',
                            'isfamily' => '0'
                          },
          'editability' => {
                             'cancomment' => '0',
                             'canaddmeta' => '0'
                           }
};
is_deeply($t, $expected_result, 'auto_parse');
