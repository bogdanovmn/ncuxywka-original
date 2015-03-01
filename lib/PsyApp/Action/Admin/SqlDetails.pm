package PsyApp::Action::Admin::SqlDetails;

use strict;
use warnings;
use utf8;

use Utils;

sub main {
	my ($self) = @_;

	my $psy = $self->params->{psy};

	unless ($psy->is_god) {
		return $psy->error("Вы хакер?");
	}

	my $sql_details = $psy->cache->try_get('sql_details', sub { [] }, 1);
	return {
		sql_details => [
			map  {
				$_->{sql} = $self->_sql_to_html($_->{sql});
				$_;
			}
			sort { 
				$b->{sql_time} <=> $a->{sql_time}
				or
				$b->{explain_total_rows} <=> $a->{explain_total_rows}
			}
			@$sql_details
		]
	};
}

sub _sql_to_html {
	my ($self, $sql) = @_;

	$sql =~ s#(\W)(
		SELECT|UPDATE|DELETE|INSERT|
		FROM|ORDER BY|GROUP BY|HAVING|
		JOIN|LEFT JOIN|RIGHT JOIN|INNER JOIN|ON|
		WHERE|AND|OR|IN|BETWEEN|INTERVAL|
		LIMIT|DESC|
		CASE|WHEN|THEN|ELSE|END
	)(\W)#$1<span class=sql_word>$2</span>$3#igmox;

	return $sql;
}

1;
