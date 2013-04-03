package SiteMap;
use base 'HiD::Plugin';
use POSIX 'strftime';
use XML::Simple;

use constant {
    BASE_URL => 'http://chinaxing.org',
    DEFAULT_CHNAGEFREQ => 'monthly',
    DEFAULT_SITEMAP_FILE => 'sitemap.xml',
};


sub after_publish {
    my ($self, $hid) = @_;

    my $filename = $hid->destination . '/' . ( $hid->get_config('sitemap') // DEFAULT_SITEMAP_FILE );

    my $xml_data = {
        urlset => [{
            xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9',
            url => [],
        }]
    };
    
    my $url_data = $xml_data->{urlset}->[0]->{url};  
    foreach my $p (@{ $hid->posts }) {
        my $lastmodify = strftime "%Y-%m-%dT%H:%M:%S%z", gmtime( (stat( $p->output_filename ))[9] );
        push @$url_data, {
            loc => [ BASE_URL . $p->url ],
            lastmod => [ $lastmodify ],
            changefreq => [ $p->get_metadata('change_frequency') // DEFAULT_CHNAGEFREQ ],
        };
    }
    XMLout($xml_data, KeepRoot => 1, XMLDecl => "<?xml version='1.0' encoding='UTF-8'?>",  OutputFile => $filename);

    return 1;
}

1;
