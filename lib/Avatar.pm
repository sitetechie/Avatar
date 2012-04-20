package Avatar;

BEGIN {
    $Avatar::VERSION   = '0.001';
    $Avatar::AUTHORITY = 'cpan:SITETECH';
    }

use strict;
use warnings;
use 5.010;

use File::Spec::Functions;
use Plack::Request;
use Plack::Response;
use GD;
use Moose;
use Path::Class;
use Cwd;

my $face_coords = {
        # dstX,dstY,srcX,srcY,width,height
        99 => {
            eyes => [33,34,0,0,108,42],
            earl => [7,52,0,0,29,64],
            earr => [136,52,0,0,29,64],
            nose => [63,53,0,0,48,61],
            lips => [49,102,0,0,76,55]
            },
        1 => {
            eyes => [33,32,0,0,108,42],
            earl => [5,50,0,0,29,64],
            earr => [137,50,0,0,29,64],
            nose => [63,47,0,0,48,61],
            lips => [49,100,0,0,76,55]
            },
        2 => {
            eyes => [33,38,0,0,108,42],
            earl => [7,32,0,0,29,64],
            earr => [139,34,0,0,29,64],
            nose => [63,52,0,0,48,61],
            lips => [49,99,0,0,76,55]
            },
        3 => {
            eyes => [32,52,0,0,108,42],
            earl => [13,57,0,0,29,64],
            earr => [129,57,0,0,29,64],
            nose => [63,67,0,0,48,61],
            lips => [49,111,0,0,76,55]
            },
        4 => {
            eyes => [33,34,0,0,108,42],
            earl => [7,52,0,0,29,64],
            earr => [136,52,0,0,29,64],
            nose => [63,53,0,0,48,61],
            lips => [49,102,0,0,76,55]
            },
        5 => {
            eyes => [33,34,0,0,108,42],
            earl => [8,52,0,0,29,64],
            earr => [137,52,0,0,29,64],
            nose => [63,54,0,0,48,61],
            lips => [49,104,0,0,76,55]
            },
        6 => {
            eyes => [33,36,0,0,108,42],
            earl => [7,50,0,0,29,64],
            earr => [134,50,0,0,29,64],
            nose => [63,54,0,0,48,61],
            lips => [49,104,0,0,76,55]
            },
        7 => {
            eyes => [33,30,0,0,108,42],
            earl => [2,46,0,0,29,64],
            earr => [143,46,0,0,29,64],
            nose => [63,48,0,0,48,61],
            lips => [49,100,0,0,76,55]
            },
        8 => {
            eyes => [34,52,0,0,108,42],
            earl => [4,57,0,0,29,64],
            earr => [142,57,0,0,29,64],
            nose => [64,67,0,0,48,61],
            lips => [51,106,0,0,76,55]
            },
        9 => {
            eyes => [33,36,0,0,108,42],
            earl => [5,50,0,0,29,64],
            earr => [137,50,0,0,29,64],
            nose => [63,53,0,0,48,61],
            lips => [49,104,0,0,76,55]
            },
        10 => {
            eyes => [37,50,0,0,108,42],
            earl => [18,57,0,0,29,64],
            earr => [134,57,0,0,29,64],
            nose => [66,68,0,0,48,61],
            lips => [54,108,0,0,76,55]
            },
        11 => {
            eyes => [33,38,0,0,108,42],
            earl => [11,50,0,0,29,64],
            earr => [131,50,0,0,29,64],
            nose => [63,54,0,0,48,61],
            lips => [49,104,0,0,76,55]
            },
        12 => {
            eyes => [32,52,0,0,108,42],
            earl => [9,57,0,0,29,64],
            earr => [132,57,0,0,29,64],
            nose => [63,67,0,0,48,61],
            lips => [49,111,0,0,76,55]
            },
        13 => {
            eyes => [33,57,0,0,108,42],
            earl => [14,57,0,0,29,64],
            earr => [130,57,0,0,29,64],
            nose => [62,73,0,0,48,61],
            lips => [50,111,0,0,76,55]
            },

        14 => {
            eyes => [32,56,0,0,108,42],
            earl => [9,57,0,0,29,64],
            earr => [134,57,0,0,29,64],
            nose => [63,68,0,0,48,61],
            lips => [49,111,0,0,76,55]
            },
        15 => {
            eyes => [34,62,0,0,108,42],
            earl => [13,57,0,0,29,64],
            earr => [129,57,0,0,29,64],
            nose => [63,73,0,0,48,61],
            lips => [49,111,0,0,76,55]
            },

        16 => {
            eyes => [34,64,0,0,108,42],
            earl => [13,57,0,0,29,64],
            earr => [131,57,0,0,29,64],
            nose => [63,73,0,0,48,61],
            lips => [49,111,0,0,76,55]
            },
        17 => {
            eyes => [34,54,0,0,108,42],
            earl => [11,57,0,0,29,64],
            earr => [136,57,0,0,29,64],
            nose => [63,66,0,0,48,61],
            lips => [49,111,0,0,76,55]
            },
        18 => {
            eyes => [34,56,0,0,108,42],
            earl => [13,57,0,0,29,64],
            earr => [134,57,0,0,29,64],
            nose => [63,67,0,0,48,61],
            lips => [49,111,0,0,76,55]
            },

        };
        # 48 x 61

has 'base_dir' => (
    is  => 'ro',
    #isa => 'Path::Class::Dir',
    default => sub { dir('./static') },
);

has 'source_dir' => (
    is  => 'ro',
    #isa => 'Path::Class::Dir',
    default => sub { dir('./tiles') },
);

has 'target_dir' => (
    is  => 'ro',
    #isa => 'Path::Class::Dir',
    default => sub { dir('./static/cache') },
);

has 'base_url' => (
    is  => 'ro',
    default => sub { '/cache' },
);

has 'tiles' => (
    is  => 'ro',
    lazy_build => 1,
);

sub _build_tiles {
    my $self = shift;
    
    my $dir = $self->source_dir;    
    my ($necks, $faces, $eyes, $lips, $noses, $earsl, $earsr) = ({},{},{},{},{},{},{});
    # necks
    foreach my $id(0..21) {
        $id ||= 99;
        my $neck = "$dir/necks/neck" . $id . '.gif';
        open(my $fh, '<', "$neck") || die("cannot open $neck file");
        my $img = newFromGif GD::Image($fh);
        close $fh;
        $necks->{$id} = $img;
        }
    # faces
    foreach my $id(0..18) {
        $id ||= 99;
        my $face = "$dir/faces/face" . $id . '.gif';
        open (my $fh, '<', "$face") || die("cannot open $face file");
        my $img = newFromGif GD::Image($fh);
        close $fh;
        $faces->{$id} = $img;
        }
    # eyes
    foreach my $id(0..68) {
        $id ||= 99;
        my $src = "$dir/eyes/eyes" . $id . '.gif';
        open (my $fh, '<', "$src") || die("cannot open $src file");
        my $img = newFromGif GD::Image($fh);
        close $fh;
        $eyes->{$id} = $img;
        }
    # lips
    foreach my $id(0..75) {
        $id ||= 99;
        my $src = "$dir/lips/lips" . $id . '.gif';
        open (my $fh, '<', "$src") || die("cannot open $src file");
        my $img = newFromGif GD::Image($fh);
        close $fh;
        $lips->{$id} = $img;
        }
    # noses
    foreach my $id(0..37) {
        next if $id == 12;
        $id ||= 99;
        my $src = "$dir/noses/nose" . $id . '.gif';
        open (my $fh, '<', "$src") || die("cannot open $src file");
        my $img = newFromGif GD::Image($fh);
        close $fh;
        $noses->{$id} = $img;
        }
    # ears
    foreach my $id(0..19) {
        $id ||= 99;
        my $src = "$dir/earsl/ear" . $id . '.gif';
        open (my $fh, '<', "$src") || die("cannot open $src file");
        my $img = newFromGif GD::Image($fh);
        close $fh;
        $earsl->{$id} = $img;
        }
    foreach my $id(0..19) {
        $id ||= 99;
        my $src = "$dir/earsr/ear" . $id . '.gif';
        open (my $fh, '<', "$src") || die("cannot open $src file");
        my $img = newFromGif GD::Image($fh);
        close $fh;
        $earsr->{$id} = $img;
        }
    return {
        necks => $necks,
        faces => $faces,
        eyes  => $eyes,
        lips  => $lips,
        noses => $noses,
        earsl => $earsl,
        earsr => $earsr,
        };
    }


sub to_psgi {
    my $self = shift;
    return sub { $self->call(@_) };
    }

sub call {
    my ($self, $env) = @_;

    my $req = Plack::Request->new($env);
    my $cookie = $req->cookies->{avatar} || '99_99_99_99_99_99';
    my $id;
    LOOP: foreach my $item(qw/neck face eye lip nose ear/) {
        if(my $query = $req->param($item)) {
            $id = $self->gen_image($cookie, $item, $query);
            last LOOP;
            }
        }

    unless($id || $req->param('setup')) {
        open(my $fh, "<", catfile($self->base_dir, 'index.html')) or die $!;
        return [ 200, ['Content-Type' => 'text/html'], $fh ];
        };

    $id ||= $self->gen_image($cookie);
    my $url = $self->base_url . '/' . $id . '.gif';
    my $res = Plack::Response->new;

    $res->cookies->{avatar} = {
        value => $id,
        path  => "/",
        expires => time + 24 * 60 * 60 * 7 * 8, # 8 weeks
        #domain => '.example.com',        
        };

    if($req->param('debug')) {
        $res->status(200);
        $res->content_type('text/html');
        $res->body("<img border='1' src='$url'>");
        return $res->finalize;
        }
    else {
        _no_cache($res);        
        $res->redirect($url, 302);
        return $res->finalize;
        }
    }

sub _no_cache {
    my $res = shift;
    
    $res->header('Expires' => 'Fri, 30 Oct 1998 14:19:41 GMT'); # Proxies
    $res->header('Pragma' => 'no-cache'); # HTTP 1.0
    $res->header('Cache-Control' => 'no-store, no-cache, must-revalidate, max-age=0'); # HTTP 1.1
    # might also need: private, max-stale=0, post-check=0, pre-check=0
    }

sub gen_image {
    my ($self, $id, $item, $query) = @_;

    my ($neck, $face, $eye, $lip, $nose, $ear) = split('_', $id);
    if($item && $query) {
        my $str = '$' . $item . " = $query";
        eval "$str";
        $id = join('_', $neck, $face, $eye, $lip, $nose, $ear);
        }
    my $newgif = $self->target_dir . '/'. $id . '.gif';
    return $id if -f $newgif;

    my (@earl_c, @earr_c, @nose_c, @lips_c, @eye_c);
    @eye_c  = @{$face_coords->{$face}->{eyes}};
    @lips_c = @{$face_coords->{$face}->{lips}};
    @nose_c = @{$face_coords->{$face}->{nose}};
    @earl_c = @{$face_coords->{$face}->{earl}} if ($face_coords->{$face}->{earl});
    @earr_c = @{$face_coords->{$face}->{earr}} if ($face_coords->{$face}->{earr});
    
    my $tiles = $self->tiles;
    my $img = $tiles->{necks}->{$neck}->clone();
    $img->copy($tiles->{lips}->{$lip}, @lips_c);
    $img->copy($tiles->{noses}->{$nose}, @nose_c);
    $img->copy($tiles->{faces}->{$face},0,0,0,0,170,240);
    $img->copy($tiles->{earsl}->{$ear}, @earl_c) if ($#earl_c > 0);
    $img->copy($tiles->{earsr}->{$ear}, @earr_c) if ($#earr_c > 0);
    $img->copy($tiles->{eyes}->{$eye}, @eye_c);

    open (DISPLAY, '>', $newgif) || die ("something wrong with $newgif");
    binmode DISPLAY;
    print DISPLAY $img->gif;
    close DISPLAY;
    die("File $newgif NotFound") unless -f $newgif;
    
    return $id;
    }

1;
__END__


=pod

=encoding utf-8

=head1 NAME

Avatar - Simple Avatar GIF generator, to run under Plack

=head1 VERSION

0.001

=head1 SYNOPSIS

  # app.psgi
  use Avatar;
  Avatar->new()->to_psgi;

=head1 DESCRIPTION

Plack application to compose Avatar GIFs from separate tile GIFs.

=head1 AUTHOR

Peter de Vos, C<< <sitetech@cpan.org> >>

=head1 SOURCE

You can contribute or fork this project via GitHub:

  git clone git://github.com/sitetechie/Avatar.git

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2011 Peter de Vos.

This module is free software; you can redistribute it and/or modify it under the
same terms as Perl itself. See L<perlartistic>.

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

=cut
