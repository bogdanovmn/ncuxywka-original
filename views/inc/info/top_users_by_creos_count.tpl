<TMPL_IF top_users_by_creos_count>

<table class=info>
	<tr>
	<td class=title>Активно сдают анализы
	<tr>
	<td>
	<TMPL_LOOP top_users_by_creos_count>
		<p class=user_creo_list>
		<span class=note><TMPL_VAR __counter__>. </span>
		<a href="/users/<TMPL_VAR ccu_id>.html"><b><TMPL_VAR ccu_name></b></a>
		<span class=subnote>[<TMPL_VAR ccu_cnt>]</span>
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
