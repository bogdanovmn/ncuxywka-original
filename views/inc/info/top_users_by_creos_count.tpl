<TMPL_IF NAME="top_users_by_creos_count">

<table class=info>
	<tr>
	<td class=title>Активно сдают анализы
	<tr>
	<td>
	<TMPL_LOOP NAME="top_users_by_creos_count">
		<p class=user_creo_list>
		<span class=note><TMPL_VAR NAME="__counter__">. </span>
		<a href="/users/<TMPL_VAR NAME='ccu_id'>.html"><b><TMPL_VAR NAME="ccu_name"></b></a>
		<span class=subnote>[<TMPL_VAR NAME="ccu_cnt">]</span>
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
