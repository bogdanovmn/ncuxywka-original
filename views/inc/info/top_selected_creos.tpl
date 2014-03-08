<TMPL_IF NAME="top_selected_creos">

<table class=info>
	<tr>
	<td class=title>Топ избранного
	<tr>
	<td>
	<TMPL_LOOP NAME="top_selected_creos">
		<p class=user_creo_list>
		<span class=note>[<TMPL_VAR NAME="sct_cnt">] </span>
		<a href="/creos/<TMPL_VAR NAME='sct_creo_id'>.html">
			<b><TMPL_VAR NAME="sct_title"></b></a>
		<br>
		<span class=subnote><TMPL_VAR NAME="sct_user_name"></span>
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
