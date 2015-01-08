<TMPL_IF wc_data_debug>

<TMPL_LOOP wc_data_debug>
	<table class=info_gray>
		<tr>
		<td class=title>Словарь "<TMPL_VAR wc_title>"
		<tr>
		<td>
		<p><b>Всего:</b> <TMPL_VAR wc_total>
		<br><b>Уникальных:</b> <TMPL_VAR wc_uniq>
		<br><b>В обллаке:</b> <TMPL_VAR wc_visible>
		<br><b>В обллаке уинк.частот:</b> <TMPL_VAR wc_uniq_freq>
		<br><b>% limit:</b> <TMPL_VAR wc_limit>
		<br>
		<br>
		</p>
		<TMPL_LOOP wc_data>
			<p class=user_creo_list>
			<span class=note>[<TMPL_VAR freq>, <TMPL_VAR percent>%] </span>
			'<TMPL_VAR word>'
			</p>
		</TMPL_LOOP>
		
	</table>
</TMPL_LOOP>

</TMPL_IF>
