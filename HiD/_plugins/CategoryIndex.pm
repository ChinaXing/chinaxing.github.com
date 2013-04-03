package CategoryIndex;
use base "HiD::Plugin";

sub after_publish {
    my ($self,$hid) = @_;

    my $layout_name = $hid->get_config('category_index_layout') // 'category_index';
    my $layout_obj = $hid->get_layout_by_name( $layout_name );

    unless ($layout_obj) {
        warn "category_index_layout unexist : " . $layout_name . "\n";
        return 1;
    }
    return 1 unless $hid->categories;
    
    foreach my $c (keys $hid->categories) {
        my $content = $layout_obj->render({
            page => { category => $c },
            site => $hid,
        });

        open my $cf, '>:utf8', $hid->destination . '/' . $c . '/index.html'
            or warn "$! $cf" and next;
        print $cf $content;
    }
    return 1;
}

1;
