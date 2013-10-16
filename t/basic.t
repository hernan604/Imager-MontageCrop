use strict;
use Test::More;
use Imager::MontageCrop;
use Path::Class;

my $img   = Imager::MontageCrop->new();
my $imgs = [
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
        files       => $imgs,
        crop_h      => 130,
        crop_w      => 140,
        resize_w    => 180,
#       resize_h    => 50,
        margin_v    => 10,
        margin_h    => 10,
        geometry_w  => 130,  # geometry from source. if not set , the resize_w , resize_h will be the default
        geometry_h  => 120,  # if we aren't going to resize the source images , we should specify the geometry at least.
        cols        => 5,
        rows        => 2,
        page_width  => 900,
        page_height => 400,
        background_color => "#FFF",
    }
);

$page->write( file => 'montage.png' , type => 'png'  );  # generate a 1000x1000 pixels image with 5x5 tiles
ok ( -e "montage.png" , "montage.png was created with success" );



# replace with the actual test
ok 1;

done_testing;
