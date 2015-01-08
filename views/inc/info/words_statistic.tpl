<TMPL_IF wc_data_debug>

<table class=info_gray>
	<tr>
	<td class=title>Словарь
	<tr>
	<td>
	<p>Всего: <TMPL_VAR wc_total>
	<br>Уникальных: <TMPL_VAR wc_uniq>
	<br>В обллаке: <TMPL_VAR wc_visible>
	<br>% limit: <TMPL_VAR wc_limit>
	<TMPL_LOOP wc_data_debug>
		<p class=user_creo_list>
		<span class=note>[<TMPL_VAR freq>, <TMPL_VAR percent>%] </span>
		'<TMPL_VAR word>'
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
