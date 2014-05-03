package PsyApp;

use strict;
use warnings;
use utf8;

use Dancer ':syntax';
use Dancer::Plugin::Controller;

use Psy;
use PsyApp::Action::Index;
use PsyApp::Action::CreoView;
use PsyApp::Action::CreoView::Post;
use PsyApp::Action::User;
use PsyApp::Action::Room;
use PsyApp::Action::Room::Proc;
use Utils;

our $VERSION = '0.1';


hook 'before' => sub {
	var psy => Psy->enter;
};

hook 'before_template_render' => sub {
	my ($template_params) = @_;

	if (vars->{psy}) {
		my $common_info = vars->{psy}->common_info;
		while (my ($k, $v) = each %$common_info) {
			$template_params->{$k} = $v;
		}
	}
};
#
# Creo view
#
get  '/creos/:id.html' => sub { controller(template => 'creo_view', action => 'CreoView') };
#
# Post creo comment
#
post '/creos/:id.html' => sub { 
	controller(action => 'CreoView::Post');
	redirect sprintf('/creos/%s.html', params->{id});
};
#
# User view
#
get '/users/:id.html' => sub { controller(template => 'user_view', action => 'User') };
#
# Rooms
#
post qr{/(wish|petr|frenizm|mainshit|proc|faq|neo_faq)_room/?} => sub { 
	my ($room) = splat;
	var room => $room;

	controller(action => "RoomPost");
	redirect sprintf('/%s_room/', $room);
};

get qr{/(wish|petr|frenizm|mainshit|proc|faq|neo_faq)_room/(?:page(\d+)\.html)?} => sub { 
	my ($room, $page) = splat;
	
	var room => $room;
	var page => $page;

	my $action = 'Room';

	if ($room eq 'proc') {
		set layout => 'minimal';
		$action = 'Room::Proc';
	}

	controller(
		template => 'rooms/'. $room, 
		action => $action 
	);
};
#
# Main page
#
get '/' => sub { controller(template => 'index',     action => 'Index') };


true;
