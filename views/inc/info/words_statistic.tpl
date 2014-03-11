<TMPL_IF NAME="words_statistic">

<table class=info>
	<tr>
	<td class=title>Словарь
	<tr>
	<td>
	<TMPL_LOOP NAME="words_statistic">
		<p class=user_creo_list>
		<span class=note>[<TMPL_VAR NAME="freq">] </span>
		<TMPL_VAR NAME="word">
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
