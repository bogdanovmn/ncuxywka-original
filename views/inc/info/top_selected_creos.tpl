<TMPL_IF top_selected_creos>

<table class=info>
	<tr>
	<td class=title>Топ избранного
	<tr>
	<td>
	<TMPL_LOOP top_selected_creos>
		<p class=user_creo_list>
		<span class=note>[<TMPL_VAR sct_cnt>] </span>
		<a href="/creos/<TMPL_VAR sct_creo_id>.html">
			<b><TMPL_VAR sct_title></b></a>
		<br>
		<span class=subnote><TMPL_VAR sct_user_name></span>
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
