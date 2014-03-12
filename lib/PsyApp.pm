package PsyApp;

use strict;
use warnings;
use utf8;

use Dancer ':syntax';
use Dancer::Plugin::Controller;

use Psy;
use PsyApp::Action::Index;
use Utils;

our $VERSION = '0.1';

sub _template {
	my $content = Dancer::template(@_);
	utf8::decode($content);
	return $content;
}


sub ___controller {
	my (%p) = @_;
	
	my $template_name = $p{template} || '';
	my $action_name = $p{action} || '';
	
	my $action_class = 'PsyApp::Action::'. $action_name;
	my $action_params = {
		Dancer::params(),
		%{Dancer::vars()}
	};

	if ($template_name) {
		return _template( 
			$template_name,
			$action_name
				? $action_class->main($action_params)
				: {}
		);
	}
	else {
		return $action_class->main($action_params);
	}
}

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

get '/creos/:id.html' => sub { controller(template => 'creo_view', action => 'CreoView') };
get '/'               => sub { controller(template => 'index',     action => 'Index') };

true;
