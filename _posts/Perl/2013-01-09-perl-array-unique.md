---
layout: post
title: unique elements of array in Perl
category: Perl
change_frequency: monthly
---

    my @new_a = keys %{ {map {$_ => } @a} };

__例子__:

    use Modern::Perl;
    use Data::Dumper;
    
    my @a = (
        { a => 'b'},
        { a => 'c'},
        { a => 'b'},
    );
    
    say "-----------------------";
    
    my $e = [ keys %{ {map {$_ => 1}  map {$_->{a} } @a } } ];
    
    say Dumper $e;

__输出__:

    -----------------------
    $VAR1 = [
              'c',
              'b'
            ];

