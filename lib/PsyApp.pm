package PsyApp;

use strict;
use warnings;
use utf8;

use Dancer ':syntax';
use lib '/home/tolobayko/devel/perl-projects/perl-dancer-plugin-controller/lib';
use Dancer::Plugin::Controller;

use Psy;
use PsyApp::Action::Index;
use PsyApp::Action::News;

use PsyApp::Action::Register;
use PsyApp::Action::Register::Post;
use PsyApp::Action::Auth;

use PsyApp::Action::CreoAdd;
use PsyApp::Action::CreoAdd::Post;
use PsyApp::Action::CreoView;
use PsyApp::Action::CreoView::Post;
use PsyApp::Action::CreoPrint;
use PsyApp::Action::CreoList;

use PsyApp::Action::Talks;

use PsyApp::Action::User;
use PsyApp::Action::UserEdit;
use PsyApp::Action::UserEdit::Post;
use PsyApp::Action::Users;

use PsyApp::Action::Room;
use PsyApp::Action::Room::Proc;
use PsyApp::Action::RoomPost;
use PsyApp::Action::GB;
use PsyApp::Action::GB::Post;

use PsyApp::Action::Error;
use PsyApp::Action::404;

use Utils;

our $VERSION = '0.1003';


hook 'before' => sub {
	set 'session_options' => {
		dbh   => sub { Psy::DB->connect->{dbh} },
		table => 'session'
	};
	cookie expire => '1 month';

	var psy => Psy->enter(
		session => sub { Dancer::session(@_) }
	);
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
# Register form 
#
get qr#/register/(error)?# => sub {
	my ($has_error) = splat;

	var has_error => 1 if $has_error;
	controller(template => 'register', action => 'Register');
};
#
# Register post
#
post '/register/' => sub { 
	if (controller(action => 'Register::Post')) {
		redirect '/main/';
	}
	else {
		redirect '/register/error';
	}
};
#
# Auth action
#
any qr#/auth/(in|out)# => sub { 
	my ($action) = splat;

	var action => $action;
	if (controller(action => 'Auth')) {
		redirect request->referer;
	}
	else {
		controller(template => 'error', action => 'Error');
	}
};
#
# Creo add form
#
get '/add_creo/' => sub { controller(template => 'add_creo', action => 'CreoAdd') };
#
# Creo add post data
#
post '/add_creo/' => sub {
	if (controller(action => 'CreoAdd::Post')) {
		redirect '/main/';
	}
	else {
		controller(template => 'add_creo', action => 'CreoAdd');
	}
};
# Creo view
#
get '/creos/:id.html' => sub { 
	controller(
		template     => 'creo_view', 
		action       => 'CreoView',
		redirect_404 => '/404.html'
	) 
};
#
# Creo print
#
get '/print/:id.html' => sub { 
	controller(
		template     => 'creo_print',
		layout       => 'minimal',
		action       => 'CreoPrint',
		redirect_404 => '/404.html'
	) };
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
get '/users/:id.html' => sub { 
	controller(
		template     => 'user_view', 
		action       => 'User',
		redirect_404 => '/404.html'
	) 
};
#
# User edit form
#
get '/user_edit/' => sub { controller(template => 'user_edit', action => 'UserEdit') };
#
# User edit post data
#
post '/user_edit/' => sub {
	if (params->{avatar}) {
		params->{avatar} = request->upload('avatar')->file_handle;
	}

	if (controller(action => 'UserEdit::Post')) {
		redirect '/user_edit/';
	}
	else {
		controller(template => 'user_edit', action => 'UserEdit');
	}
};
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
post qr#/(wish|petr|frenizm|mainshit|proc|faq|neo_faq)_room/?# => sub { 
	my ($room) = splat;
	var room => $room;

	controller(action => "RoomPost");
	redirect sprintf('/%s_room/', $room);
};

get qr#/(wish|petr|frenizm|mainshit|proc|faq|neo_faq)_room/(?:page(\d+)\.html)?# => sub { 
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
	controller(template => 'gb', action => 'GB') 
};
#
# News page
#
get '/news/' => sub { controller(template => 'news', action => 'News') };
#
# Main page
#
get '/(main/)?' => sub { controller(template => 'index', action => 'Index') };
#
# 404
#
any qr{.*} => sub { controller(template => '404', action => '404') };

true;
