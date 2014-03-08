package PSY::RSS;

use strict;
use warnings;

use PSY::DB;
use PSY::ERRORS;
use XML::RSS;

use Data::Dumper;

use constant RSS_CREO_LIST_FILE => "rss/creo_list.rdf";
use constant RSS_COMMENTS_FILE => "rss/comments.rdf";
use constant RSS_CREO_LIST_LIMIT => 20;
use constant RSS_COMMENTS_LIMIT => 20;

#
# Constructor
#
sub new {
	my ($class) = @_;

	my $self = {};
	
	return $self;
}
#
#
#
sub create_creo_list {
	$rss->channel(
		title          => 'Íîâûå àíàëèçû',
		link           => 'http://ncuxywka.com/',
		language       => 'ru',
		description    => 'Ëåíòà íîâûõ àíàëèçîâ íà Ïñèõóşøêå',
		copyright      => 'Copyright 2012, ncuxywka.com',
		#pubDate        => 'Thu, 23 Aug 1999 07:00:00 GMT',
		#lastBuildDate  => 'Thu, 23 Aug 1999 16:20:26 GMT',
		#docs           => 'http://www.blahblah.org/fm.cdf',
		managingEditor => 'ncuxywka@gmail.com',
		webMaster      => 'ncuxywka@gmail.com'
	);

#	$rss->image(
#		title       => 'ncuxywka.com',
#		url         => 'http://ncuxywka.com/favicon.ico',
#		link        => 'http://ncuxywka.com',
#		width       => 88,
#		height      => 31,
#		description => 'This is the Freshmeat image stupid'
#	);

	$rss->add_item(
		title => "GTKeyboard 0.85",
		# creates a guid field with permaLink=true
		permaLink  => "http://freshmeat.net/news/1999/06/21/930003829.html",
		# alternately creates a guid field with permaLink=false
		# guid     => "gtkeyboard-0.85"
		enclosure   => { url=>$url, type=>"application/x-bittorrent" },
		description => 'blah blah'
	);
}
#
#
#
sub update_creo_list {
	my (%creo) = @_;

	my $rss = XML::RSS->new;
	$rss->parsefile(RSS_CREO_LIST_FILE);

	while (@{$rss->{'items'}} >= RSS_CREO_LIST_LIMIT) {
		pop(@{$rss->{'items'});
	}

	$rss->add_item(
		title => $creo{title},
		link  => "http://ncuxywka.com/1.html",
		mode  => 'insert'
	);
}


1;
