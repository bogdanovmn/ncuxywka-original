<TMPL_IF petr_top_users_list>

<table class=info>
	<tr>
	<td class=title>Лучшие друзья Петра
	<tr>
	<td>
	<TMPL_LOOP petr_top_users_list>
		<p class=user_creo_list>
		<span class=note>[<TMPL_VAR pp_cnt>] </span>
		<TMPL_IF pp_user_id>
			<a href="/users/<TMPL_VAR pp_user_id>.html"><b><TMPL_VAR pp_alias></b></a>
		<TMPL_ELSE>
			<TMPL_VAR pp_alias>
		</TMPL_IF>
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
