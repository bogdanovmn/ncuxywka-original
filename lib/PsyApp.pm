package PsyApp;

use Dancer ':syntax';

use PsyApp::Action::Index;

our $VERSION = '0.1';


sub controller {
	my (%p) = @_;
	
	my $template_name = $p{template} || '';
	my $action_name = $p{action} || '';
	
	my $action_class = 'PsyApp::Action::'. $action_name;
	my $action_params = {
		Dancer::params(),
		%{Dancer::vars()}
	};

	# Если задан шаблон - возращаем результат рендера
	# Если шаблона не задан - возвращаем реультат экшена
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

get '/' => sub { controller(template => 'index', action => 'Index') };

true;
