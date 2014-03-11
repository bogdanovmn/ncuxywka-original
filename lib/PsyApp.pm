package PsyApp;

use strict;
use warnings;

use Dancer ':syntax';

use Psy;
use PsyApp::Action::Index;
use Utils;

our $VERSION = '0.1';

sub _template {
	my $content = Dancer::template(@_);
	utf8::decode($content);
	return $content;
}


sub controller {
	my (%p) = @_;
	
	my $template_name = $p{template} || '';
	my $action_name = $p{action} || '';
	
	my $action_class = 'PsyApp::Action::'. $action_name;
	my $action_params = {
		Dancer::params(),
		%{Dancer::vars()}
	};

	# Р•СЃР»Рё Р·Р°РґР°РЅ С€Р°Р±Р»РѕРЅ - РІРѕР·СЂР°С‰Р°РµРј СЂРµР·СѓР»СЊС‚Р°С‚ СЂРµРЅРґРµСЂР°
	# Р•СЃР»Рё С€Р°Р±Р»РѕРЅР° РЅРµ Р·Р°РґР°РЅ - РІРѕР·РІСЂР°С‰Р°РµРј СЂРµСѓР»СЊС‚Р°С‚ СЌРєС€РµРЅР°
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

get '/' => sub { controller(template => 'index', action => 'Index') };

true;
