<TMPL_IF ban_total_list>

<table class=info>
	<tr>
	<td class=title>Общее время процедур
	<tr>
	<td>
	<TMPL_LOOP ban_total_list>
		<p class=user_creo_list>
		<a href="/users/<TMPL_VAR btl_user_id>.html"><b><TMPL_VAR btl_name></b></a>
		<br><span class=note>[Общее время: <TMPL_VAR btl_time>]</span>
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
