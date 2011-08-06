use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Avatar;
use Plack::Builder;
use Plack::App::File;
use File::Copy;
use Cwd;

my $tiledir = "$FindBin::Bin/tiles";
my $basedir = "$FindBin::Bin/static";
my $gendir  = "$FindBin::Bin/static/cache";
my $genurl  = '/cache';

die("Tile- or cache dir not found") unless(-d $tiledir && -d $gendir);

# make sure we have a default avatar
my $default = '99_99_99_99_99_99.gif';
unless(-f "$gendir/$default") {
    copy("$tiledir/$default","$gendir/$default") or die "Copy failed: $!";
    }

builder {
    enable "Static", path => qr{^/(images|js|css|cache)/}, root => $basedir;
    mount "/favicon.ico" => Plack::App::File->new(file => './static/favicon.ico');
    mount "/" => Avatar->new(
        base_dir   => $basedir,
        source_dir => $tiledir,
        target_dir => $gendir,
        base_url   => $genurl
        )->to_psgi;
}

