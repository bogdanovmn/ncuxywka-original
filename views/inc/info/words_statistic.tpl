<TMPL_IF words_statistic>

<table class=info>
	<tr>
	<td class=title>Словарь
	<tr>
	<td>
	<TMPL_LOOP words_statistic>
		<p class=user_creo_list>
		<span class=note>[<TMPL_VAR freq>] </span>
		<TMPL_VAR word>
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
