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

get  '/creos/:id.html' => sub { controller(template => 'creo_view', action => 'CreoView') };
post '/creos/:id.html' => sub { 
	controller(action => 'CreoView::Post');
	redirect sprintf('/creos/%s.html', params->{id});
};

get  '/users/:id.html' => sub { controller(template => 'user_view', action => 'User') };

get '/' => sub { controller(template => 'index',     action => 'Index') };


true;
