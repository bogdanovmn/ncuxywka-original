package PSY::SKIN;

use strict;
use warnings;

my $SKINS = {
	original => {
		css => {
			main => "auto_main.css"
		},
		pic => {
			main => "main201402.png",
			logo => "ncuxywka_com.jpg",
			lozung => "medical_car_green.gif",
			gb => "gb.jpg",
			nizm => "nizm.jpg",
			mainshit => "mainshit.jpg",
			proc => "proc.jpg"
		},
		button => {
			creo_comment => 'Поставить диагноз',
			gb_comment => 'Кря-кря',
			vote => 'Оценить',
			creo_select => 'Добавить этот анализ в мое избранное!'
		}
	},

	neo => {
		css => {
			main => "auto_neo.css"
		},
		pic => {
			main => "main201309.png",
			lozung => "medical_car_green.gif",
			logo => "neo_ncuxywka_com.png",
		},
		button => {
			creo_comment => 'Поставить диагноз',
			vote => 'Оценить',
			creo_select => 'Добавить этот неофутуризм в мое избранное!'
		}
	},

	new_year => {
		css => {
			main => "auto_ny.css"
		},
		pic => {
			main => "main_ny_2013.jpeg",
			logo => "ncuxywka_com_new_year.jpg",
			lozung => "ny_logo.gif",
			gb => "gb_ny.jpg",
			nizm => "nizm_ny.jpg",
			mainshit => "mainshit_ny.jpg",
			proc => "proc_ny.jpg"
		},
		js_include => [{js_file => "snow.js"}]
	},

	first_april => {
		css => {
			main => "first_april_main.css"
		},
		pic => {
			main => "bee/main.jpg",
			logo => "bee/ncuxywka_com_1apr.jpg",
			lozung => "bee/lozung.png",
			gb => "bee/girl.jpg",
			nizm => "bee/nizm.jpg",
			mainshit => "bee/mainshit.jpg",
			proc => "bee/proc.jpg"
		}
	},
	feb14 => {
		css => {
			main => "auto_14feb.css"
		},
		pic => {
			main => "main_14feb.jpg",
			logo => "ncuxywka_com_14_feb.jpg",
			lozung => "lozung_14feb.jpg",
			gb => "main_14feb.jpg",
			nizm => "main_14feb.jpg",
			mainshit => "main_14feb.jpg",
			proc => "main_14feb.jpg"
		},
		#js_include => [{js_file => "snow.js"}]
	},
};
sub get_skin {
	my $name = shift;
	my %skin = ();
	my $prefix = "skin_";
	while (my ($key, $value) = each %{$SKINS->{$name}}) {
		if ("HASH" eq ref($value)) {
			while (my ($sub_key, $sub_value) = each %$value) {
				$skin{$prefix.$key."_".$sub_key} = $sub_value;
			}
		}
		else {
			$skin{$prefix.$key} = $value;
		}
	}

	return %skin;
}
1;
