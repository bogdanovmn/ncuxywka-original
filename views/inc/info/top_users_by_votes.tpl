<TMPL_IF top_users_by_votes>

<table class=info>
	<tr>
	<td class=title>Самые шизанутые
	<tr>
	<td>
	<TMPL_LOOP top_users_by_votes>
		<p class=user_creo_list>
		<span class=note><TMPL_VAR __counter__>. </span>
		<a href="/users/<TMPL_VAR tul_user_id>.html"><b><TMPL_VAR tul_user_name></b></a>
		<br><span class=subnote>[Голосов: <TMPL_VAR tul_cnt>]</span>
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
