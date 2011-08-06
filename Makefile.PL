use strict;
use warnings;

use inc::Module::Install;

name            'Avatar';
all_from        'lib/Avatar.pm';
homepage        'http://sitetechie.com/';

requires        'Plack';
requires        'GD';
requires        'Moose';
requires        'Path::Class';

auto_install;
WriteAll;
