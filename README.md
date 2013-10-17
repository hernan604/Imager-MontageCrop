# NAME

Imager::MontageCrop - Modified version of Imager::Montage

# SYNOPSIS

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

# DESCRIPTION

Imager::MontageCrop is a modified version of Imager::Montage. This version allows crop. I like cropped.

If the author of Imager::Montage is interested, this modification could be pushed into his code.

# DOCUMENTATION

See: [Imager::Montage](http://search.cpan.org/perldoc?Imager::Montage)

# AUTHOR

Hernan Lopes <hernan@cpan.org>

# COPYRIGHT

Copyright 2013- Hernan Lopes

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.



# SEE ALSO
