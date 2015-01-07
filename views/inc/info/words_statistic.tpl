<TMPL_IF wc_data>

<table class=info>
	<tr>
	<td class=title>Словарь
	<tr>
	<td>
	<p>Всего: <TMPL_VAR wc_total>
	<br>Уникальных: <TMPL_VAR wc_uniq>
	<TMPL_LOOP wc_data>
		<p class=user_creo_list>
		<span class=note>[<TMPL_VAR freq>, <TMPL_VAR percent>%] </span>
		'<TMPL_VAR word>'
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
