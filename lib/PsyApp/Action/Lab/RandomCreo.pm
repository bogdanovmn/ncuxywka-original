package PsyApp::Action::Lab::RandomCreo;

use strict;
use warnings;
use utf8;

use Psy::Text::Generator::Creo;
use Utils;
use Psy::Text;


sub main {
	my ($self) = @_;

	my $user_id_1  = $self->params->{user_id_1};
	my $user_id_2  = $self->params->{user_id_2};
	my $depth      = $self->params->{depth};
	my $psy        = $self->params->{psy};

	my $users = $self->_get_users;

	my $depths = [
		{ value => 3, name => 'Высокая' },
		{ value => 4, name => 'Средняя' },
		{ value => 5, name => 'Низкая'  },
	];

	my $form = {
		users_1 => Utils::set_selected_flag($users, $user_id_1, 'user_id'),
		depth   => Utils::set_selected_flag($depths, $depth, 'value'),
	};

	return $form if not $user_id_1 and not $user_id_2;

	my $generator = Psy::Text::Generator::Creo->new( 
		user_id => [ $user_id_1 || (), $user_id_2 || () ]
	);

	return {
		text => Psy::Text::convert_to_html($generator->create(chunk_length => $depth)),
		%$form
	};
	
}

sub _get_users {
	my ($self) = @_;

	return [ 
		sort { $a->{user_name} cmp $b->{user_name} }
		@ {
			$self->psy->schema_select(
				'UserStat',
				{ creo_post => { '>' => 3 } },
				undef,
				[qw/ user_id /],
				undef,
				{ user_id => 'user_name' }
			)
		}
	];
}

1;
