package PsyApp;

use strict;
use warnings;
use utf8;

use Dancer ':syntax';
use Dancer::Plugin::Controller '0.152';

use Carp;
$SIG{__DIE__} = sub { confess(@_) };

use Psy;

use PsyApp::Action;
use PsyApp::Action::Index;
use PsyApp::Action::Maindoctor;

use PsyApp::Action::List::Creo;
use PsyApp::Action::List::Creo::Comments;
use PsyApp::Action::List::Creo::Search;
use PsyApp::Action::List::User;

use PsyApp::Action::News::View;
use PsyApp::Action::News::Post;
use PsyApp::Action::News::Hide;

use PsyApp::Action::Register::Form;
use PsyApp::Action::Register::Post;
use PsyApp::Action::Auth;

use PsyApp::Action::AddCreo::Form;
use PsyApp::Action::AddCreo::Post;

use PsyApp::Action::Creo::View;
use PsyApp::Action::Creo::PostComment;
use PsyApp::Action::Creo::Print;
use PsyApp::Action::Creo::Select;
use PsyApp::Action::Creo::Vote;
use PsyApp::Action::Creo::Edit::Form;
use PsyApp::Action::Creo::Edit::Post;
use PsyApp::Action::Creo::Edit::Status;

use PsyApp::Action::Creo::BlackCopy::View;
use PsyApp::Action::Creo::BlackCopy::Update;
use PsyApp::Action::Creo::BlackCopy::Publish;

use PsyApp::Action::User::View;
use PsyApp::Action::User::Edit::Form;
use PsyApp::Action::User::Edit::Post;

use PsyApp::Action::Room::View;
use PsyApp::Action::Room::View::Proc;
use PsyApp::Action::Room::PostComment;

use PsyApp::Action::GB::View;
use PsyApp::Action::GB::Post;

use PsyApp::Action::PersonalMessages::View;
use PsyApp::Action::PersonalMessages::Post;

use PsyApp::Action::ProcedureSet;

use PsyApp::Action::Admin::Bot::Comment::Template;
use PsyApp::Action::Admin::Bot::Comment::Template::Post;

use PsyApp::Action::Error;
use PsyApp::Action::404;

use Utils;

our $VERSION = '0.1006';


sub show_error { controller(template => 'error', action => 'Error') }


hook 'before' => sub {
	set 'session_options' => {
		dbh   => sub { Psy::DB->connect->{dbh} },
		table => 'session'
	};

	my ($ip) = split /, /, request->env->{HTTP_X_FORWARDED_FOR};
	var psy => Psy->enter(
		session => sub { Dancer::session(@_) },
		ip      => $ip
	);

	var ban_left_time => vars->{psy}->banned;
	if (not request->path =~ '^/proc_room' and vars->{ban_left_time}) {
		redirect '/proc_room/';
	}
};

hook 'before_template_render' => sub {
	my ($template_params) = @_;


	if (vars->{psy}) {
		my $skin_name = 'new_year';#'original';

		if (vars->{set_neo_skin} or $template_params->{c_neofuturism}) {
			$skin_name = 'neo';
		}

		my $common_info = vars->{psy}->common_info(skin => $skin_name);
		while (my ($k, $v) = each %$common_info) {
			$template_params->{$k} = $v;
		}
	}
};
#
# Main page
#
get '/(main/)?' => sub { controller(template => 'index', action => 'Index') };
#
# Register form 
#
get '/register/' => sub {
	controller(template => 'register', action => 'Register::Form');
};
#
# Register post
#
post '/register/' => sub { 
	if (controller(action => 'Register::Post')) {
		redirect '/main/';
	}
	else {
		controller(template => 'register', action => 'Register::Form');
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
		show_error;
	}
};
#
# Creo add form
#
get '/add_creo/' => sub { controller(template => 'add_creo', action => 'AddCreo::Form') };
#
# Creo add post data
#
post '/add_creo/' => sub {
	if (controller(action => 'AddCreo::Post')) {
		redirect '/main/';
	}
	else {
		controller(template => 'add_creo', action => 'AddCreo::Form');
	}
};
#
# Creo black copy view
#
get qr#/black_copy/(preview|edit)/(\d+).html# => sub {
	my ($action, $id) = splat;

	if ($action eq 'edit') {
		var edit => 1;
	}
	var id => $id;
	controller(template => 'creo_black_copy', action => 'Creo::BlackCopy::View') 
};
#
# Creo black copy add post data
#
post '/black_copy/' => sub {
	if (controller(action => 'Creo::BlackCopy::Update')) {
		redirect sprintf('/black_copy/preview/%d.html', params->{id});
	}
	else {
		var edit => 1;
		controller(template => 'creo_black_copy', action => 'Creo::BlackCopy::View');
	}
};
#
# Creo black copy publish
#
post '/black_copy/publish' => sub {
	if (controller(action => 'Creo::BlackCopy::Publish')) {
		redirect '/main/';
	}
	else {
		show_error;
	}
};
#
# Creo edit form
#
get '/creo_edit/full/:id/' => sub { controller(template => 'creo_edit', action => 'Creo::Edit::Form') };
#
# Creo edit post
#
post '/creo_edit/full/' => sub {
	if (controller(action => 'Creo::Edit::Post')) {
		redirect sprintf('/creos/%d.html', params->{id});
	}
	else {
		controller(template => 'creo_edit', action => 'Creo::Edit::Form');
	}
};
#
# Creo change status
#
get qr#/creo_edit/(delete|to_quarantine|from_quarantine|to_neofuturism|from_neofuturism|to_plagiarism)/(\d+)/# => sub {
	my ($action, $id) = splat;

	var action => $action;
	var id     => $id;
	if (controller(action => 'Creo::Edit::Status')) {
		redirect request->referer;
	}
	else {
		show_error;
	}
};
#
# Creo view
#
get qr{/creos(a)?/(\d+)\.html} => sub { 
	my (@params) = splat;
	
	if (@params > 1) { 
		var details => 1;
		var id      => $params[1];
	}
	else {
		var id => $params[0];
	}

	controller(
		template     => 'creo_view', 
		action       => 'Creo::View',
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
		action       => 'Creo::Print',
		redirect_404 => '/404.html'
	) };
#
# Post creo comment
#
post '/creos/:id.html' => sub { 
	controller(action => 'Creo::PostComment');
	redirect request->referer;
};
#
# User view
#
get qr{/users(a)?/(\d+)\.html} => sub { 
	my (@params) = splat;
	
	if (@params > 1) { 
		var details => 1;
		var id      => $params[1];
	}
	else {
		var id => $params[0];
	}

	controller(
		template     => 'user_view', 
		action       => 'User::View',
		redirect_404 => '/404.html'
	) 
};
#
# User edit form
#
get '/user_edit/' => sub { controller(template => 'user_edit', action => 'User::Edit::Form') };
#
# User edit post data
#
post '/user_edit/' => sub {
	if (params->{avatar}) {
		params->{avatar} = request->upload('avatar')->file_handle;
	}

	if (controller(action => 'User::Edit::Post')) {
		redirect '/user_edit/';
	}
	else {
		controller(template => 'user_edit', action => 'User::Edit::Form');
	}
};
#
# Users
#
get '/users/' => sub { controller(template => 'users', action => 'List::User') };
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
		var neofuturism  => 1;
		var set_neo_skin => 1;
	}

	if ($period) {
		var period => $period;
	}

	controller(template => 'creo_list', action => 'List::Creo') 
};
#
# Comments
#
get qr#/talks/(?:page(\d+)\.html)?# => sub {
	my ($page) = splat;

	if ($page) {
		var page => $page;
	}

	controller(template => 'talks', action => 'List::Creo::Comments');
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

	controller(template => 'talks', action => 'List::Creo::Comments');
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

	controller(template => 'talks', action => 'List::Creo::Comments');
};
#
# Rooms
#
post qr#/(wish|petr|frenizm|mainshit|proc|faq|neo_faq)_room/?# => sub { 
	my ($room) = splat;
	var room => $room;

	if (controller(action => "Room::PostComment")) {
		redirect request->referer;
	}
	else {
		show_error;
	}
};

get qr#/(wish|petr|frenizm|mainshit|proc|faq|neo_faq)_room/(?:page(\d+)\.html)?# => sub { 
	my ($room, $page) = splat;
	
	var room => $room;
	var page => $page;

	my $action = 'Room::View';

	if ($room eq 'proc') {
		$action = 'Room::View::Proc';
	}
	elsif ($room eq 'neo_faq') {
		var set_neo_skin => 1;
	}

	controller(
		template => 'rooms/'. $room, 
		action => $action,
		layout => $room eq 'proc' ? 'minimal' : 'main'
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
	controller(template => 'gb', action => 'GB::View') 
};
#
# Guest book post comment 
#
post '/gb/' => sub { 
	if (controller(action => "GB::Post")) {
		redirect request->referer;
	}
	else {
		show_error;
	}
};
#
# News page
#
get '/news/' => sub { controller(template => 'news', action => 'News::View') };
#
# News post 
#
post '/news/' => sub { 
	if (controller(action => "News::Post")) {
		redirect request->referer;
	}
	else {
		show_error;
	}
};
#
# News hide 
#
get '/news/hide/:id' => sub { 
	if (controller(action => "News::Hide")) {
		redirect request->referer;
	}
	else {
		show_error;
	}
};

#
# Select creo
#
any qr#/select/(add|del)/(\d+)# => sub { 
	my ($action, $creo_id) = splat;

	var action  => $action;
	var creo_id => $creo_id;
	if (controller(action => 'Creo::Select')) {
		redirect request->referer;
	}
	else {
		show_error;
	}
};
#
# Vote creo 
#
post '/vote' => sub { 
	if (controller(action => 'Creo::Vote')) {
		redirect request->referer;
	}
	else {
		show_error;
	}
};
#
# Personal messages list
#
get qr#/pm/(in|out)/(?:page(\d+)\.html)?# => sub {
	my ($action, $page) = splat;

	var action => $action;
	var page   => $page;
	controller(template => 'personal_messages', action => 'PersonalMessages::View');
};
get qr#/pm/(dialog)/(\d+)/(?:page(\d+)\.html)?# => sub {
	my ($action, $to_user_id, $page) = splat;

	var action     => $action;
	var to_user_id => $to_user_id;
	var page       => $page;
	controller(template => 'personal_messages', action => 'PersonalMessages::View');
};
#
# Personal message post
#
post '/pm/post' => sub {
	if (controller(action => 'PersonalMessages::Post')) {
		redirect sprintf('/pm/dialog/%d/', params->{user_id});
	}
	else {
		show_error;
	}
};

#
# Procedure set (self-ban)
#
post '/procedure/' => sub {
	var self => 1;
	if (controller(action => 'ProcedureSet')) {
		redirect '/proc_room/';
	}
	else {
		show_error;
	}
};
#
# Creo search
#
post '/search/' => sub { controller( template => 'creo_search', action => 'List::Creo::Search' ) };
#
# Procedure set (ban)
#
get qr#/procedure/user/(\d+)# => sub {
	my ($user_id) = splat;

	var user_id => $user_id;
	if (controller(action => 'ProcedureSet')) {
		redirect request->referer;
	}
	else {
		show_error;
	}
};
#
# Maindoctor room
#
get '/maindoctor/' => sub { controller( template => 'maindoctor', action => 'Maindoctor' ) };

#
# Admin
#

#
# Bot comments template
#
get '/doctor/bot/comment_template/' => sub {
	controller( 
		template => 'admin/bot/comment_template', 
		action   => 'Admin::Bot::Comment::Template',
		layout   => 'minimal'
	)
};
#
# Bot comments template post
#
post '/doctor/bot/comment_template/' => sub {
	if (controller(action => 'Admin::Bot::Comment::Template::Post')) {
		redirect '/doctor/bot/comment_template/';
	}
	else {
		show_error;
	}
};

#
# 404
#
any qr{.*} => sub { controller(template => '404', action => '404') };

true;

