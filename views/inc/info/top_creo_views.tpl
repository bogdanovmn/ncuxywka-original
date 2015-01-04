<TMPL_IF top_creo_views>

<table class=info>
	<tr>
	<td class=title>Топ просмотров
	<tr>
	<td>
	<TMPL_LOOP top_creo_views>
		<p class=user_creo_list>
		<span class=note>[<TMPL_VAR cvt_cnt>] </span>
		<a href="/creos/<TMPL_VAR cvt_creo_id>.html">
			<b><TMPL_VAR cvt_title></b></a>
		<br>
		<span class=subnote><TMPL_VAR cvt_user_name></span>
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
