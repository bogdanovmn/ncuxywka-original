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
use PsyApp::Action::CreoList;
use PsyApp::Action::Talks;
use PsyApp::Action::User;
use PsyApp::Action::Users;
use PsyApp::Action::Room;
use PsyApp::Action::Room::Proc;
use PsyApp::Action::RoomPost;
use PsyApp::Action::GB;
use PsyApp::Action::GB::Post;
use PsyApp::Action::404;
use Utils;

our $VERSION = '0.1001';


hook 'before' => sub {
	var psy => Psy->enter;
};

hook 'before_template_render' => sub {
	my ($template_params) = @_;

	if (vars->{room} and vars->{room} eq 'proc') {
		set layout => 'minimal';
	}
	else {
		set layout => 'main';
	}

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
# Users
#
get '/users/' => sub { controller(template => 'users', action => 'Users') };
#
# Creos
#
get qr#/(creos|quarantine|deleted|neofuturism)/(week|month|y\d{4})?/?# => sub {
	my ($type_str, $period) = splat;
	var type => {
		creos       => 0,
		quarantine  => 1,
		deleted     => 2,
		neofuturism => 0,
	}->{$type_str};

	if ($type_str eq 'neofuturism') {
		var neofuturism => 1;
	}

	if ($period) {
		var period => $period;
	}

	controller(template => 'creo_list', action => 'CreoList') 
};
#
# Comments
#
get qr#/talks/(?:page(\d+)\.html)?# => sub {
	my ($page) = splat;

	if ($page) {
		var page => $page;
	}

	controller(template => 'talks', action => 'Talks');
};
#
# Comments for/from user
#
get qr#/talks/(for|from)/(\d+)(?:/page(\d+)\.html)?# => sub {
	my ($target_type, $target_id, $page) = splat;

	var $target_type => $target_id;

	if ($page) {
		var page => $page;
	}

	controller(template => 'talks', action => 'Talks');
};
#
# Comments from user for user
#
get qr#/talks/for/(\d+)/from/(\d+)(?:/page(\d+)\.html)?# => sub {
	my ($for_id, $from_id, $page) = splat;

	var for  => $for_id;
	var from => $from_id;

	if ($page) {
		var page => $page;
	}

	controller(template => 'talks', action => 'Talks');
};
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
		$action = 'Room::Proc';
	}

	controller(
		template => 'rooms/'. $room, 
		action => $action 
	);
};
#
# Guest book
#
get qr#/gb/(?:page(\d+)\.html)?# => sub { 
	my ($page) = splat;

	if ($page) {
		var page => $page;
	}

	controller(template => 'gb', action => 'GB') };
#
# Main page
#
get '/(main/)?' => sub { controller(template => 'index', action => 'Index') };
#
# 404
#
any qr{.*} => sub { controller(template => '404', action => '404') };

true;
