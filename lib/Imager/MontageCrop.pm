package Imager::MontageCrop;
use base Imager::Montage;
use strict;
use warnings;
use 5.008_005;
our $VERSION = '0.01';

sub gen_page {
    my $self = shift;
    my $args = shift;

    $args->{geometry_w} ||= $args->{resize_w};
    $args->{geometry_h} ||= $args->{resize_h};

    $args->{$_} ||= 0
        for(qw/border frame margin_v margin_h/);

    $args->{$_}         ||= '#ffffff'
        for (qw/background_color border_color frame_color/);

    $args->{page_width}
        ||= $args->{frame} * 2
        + ( $args->{border} * 2 ) * $args->{cols}
        + $args->{geometry_w} * $args->{cols}
        + ( $args->{margin_h} * 2 ) * $args->{cols};

    $args->{page_height}
        ||= $args->{frame} * 2
        + ( $args->{border} * 2 ) * $args->{rows}
        + $args->{geometry_h} * $args->{rows}
        + ( $args->{margin_v} * 2 ) * $args->{rows};
 
 
    $args->{$_} = $self->_load_color( $args->{$_} )
        for (qw/background_color border_color frame_color/);
 
    # create a page
    my $page_img = Imager->new(
        xsize => $args->{page_width},
        ysize => $args->{page_height});
 
    $self->_set_resolution( $page_img, $args->{res} )
        if ( exists $args->{res} );
 
    # this could make a frame for page
    if ( exists $args->{frame} ) {
        $page_img->box(
            filled => 1,
            color  => $args->{frame_color} );
 
        my $box = Imager->new(
                xsize => $args->{page_width} - $args->{frame} * 2 ,
                ysize => $args->{page_height} - $args->{frame} * 2 )->box( filled => 1, color  => $args->{background_color});
 
        $page_img->paste(
            left => $args->{frame},
            top  => $args->{frame},
            src  => $box);
    }
    else {
        $page_img->box(
            filled => 1,
            color  => $args->{background_color},
        );
    }
 
    my ( $top, $left ) = (
        $args->{frame},
        $args->{frame} );
 
    for my $col ( 0 .. $args->{cols} - 1 ) {
 
        $top = $args->{frame};
 
        for my $row ( 0 .. $args->{rows} - 1 ) {
 
            # get filename
            my $file = ${ $args->{files} }[ $col * $args->{rows} + $row ];
            next if ( ! defined $file );
 
 
            my $canvas_img = $self->_load_image($file);
 
            # resize it if we define a new size
            if ( exists $args->{resize_w} ) {
                $canvas_img = $canvas_img->scale(
                                    xpixels => $args->{resize_w},
                                    ypixels => $args->{resize_h},
                                    type    => 'max',); }  # XXX: make nonprop as parameter

            if ( exists $args->{ crop_h } && exists $args->{ crop_w } ) {
                $canvas_img = $canvas_img->crop(
                      width  => $args->{ crop_w },
                      height => $args->{ crop_h },
                    ) or return $canvas_img->errstr;
            }
            
 
            # flip
            if ( exists $args->{flip}
                and ( exists $args->{flip_exclude} and !eval( $args->{flip_exclude} ) ) ) {
                $canvas_img->flip( dir => $args->{flip} ); }
 
            # if border is set
            if( $args->{border} ) {
                # gen border , paste it before we paste image to the page
                my $box = Imager->new(
                    xsize => $args->{geometry_w} + $args->{border} * 2,
                    ysize => $args->{geometry_h} + $args->{border} * 2 )->box( filled => 1, color => $args->{border_color} );
                $page_img->paste(
                    left => $left + $args->{margin_h} ,
                    top  => $top + $args->{margin_v} ,
                    src  => $box );
            }
 
            $page_img->paste(
                left => $left + $args->{margin_h} + $args->{border} ,  # default border is 0
                top  => $top + $args->{margin_v} + $args->{border} ,
                src  => $canvas_img);
 
        } continue {
            $top += ( $args->{border} * 2 + $args->{margin_v} * 2 + $args->{geometry_h} );
        }
    }
    continue {
        $left += ( $args->{border} * 2 + $args->{margin_h} * 2 + $args->{geometry_w} );
    }
 
    return $page_img;
};


1;

__END__

=encoding utf-8

=head1 NAME

Imager::MontageCrop - Modified version of Imager::Montage

=head1 SYNOPSIS

  use Imager::MontageCrop;
  use Path::Class;

  my $img   = Imager::MontageCrop->new();

  my $imgs  = [
    "t/images/a.png" ,
    "t/images/b.png" ,
    "t/images/c.png" ,
    "t/images/d.png" ,
    "t/images/e.png" ,
    "t/images/f.png" ,
    "t/images/g.png" ,
    "t/images/h.png" ,
    "t/images/i.png" ,
    "t/images/j.png" ,
  ];

  my $page  = $img->gen_page(
      {
          files             => $imgs,
          crop_h            => 130,
          crop_w            => 140,
          resize_w          => 180,
          margin_v          => 10,
          margin_h          => 10,
          geometry_w        => 130,
          geometry_h        => 120,
          cols              => 5,
          rows              => 2,
          page_width        => 900,
          page_height       => 400,
          background_color  => "#FFF",
      }
  );

  $page->write(
    file => 'montage.png' , 
    type => 'png'  
  ); 

=head1 DESCRIPTION

Imager::MontageCrop is a modified version of Imager::Montage. This version allows crop. I like cropped.

If the author of Imager::Montage is interested, this modification could be pushed into his code.

=head1 DOCUMENTATION

See: L<Imager::Montage>

=head1 AUTHOR

Hernan Lopes E<lt>hernan@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2013- Hernan Lopes

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=head1 SEE ALSO

=cut
