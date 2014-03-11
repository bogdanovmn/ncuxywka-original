<TMPL_IF NAME="top_users_by_votes">

<table class=info>
	<tr>
	<td class=title>Самые шизанутые
	<tr>
	<td>
	<TMPL_LOOP NAME="top_users_by_votes">
		<p class=user_creo_list>
		<span class=note><TMPL_VAR NAME="__counter__">. </span>
		<a href="/users/<TMPL_VAR NAME='tul_user_id'>.html"><b><TMPL_VAR NAME="tul_user_name"></b></a>
		<br><span class=subnote>[Голосов: <TMPL_VAR NAME="tul_cnt">]</span>
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
