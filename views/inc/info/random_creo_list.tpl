<TMPL_IF NAME="random_creo_list">

<table class=info>
	<tr>
	<td class=title>Случайные анализы
	<tr>
	<td>
	<TMPL_LOOP NAME="random_creo_list">
		<p class=user_creo_list>
		<a href="/creos/<TMPL_VAR NAME='cl_id'>.html"><b><TMPL_VAR NAME="cl_title"></b></a>
		<br><span class=link_note><TMPL_VAR NAME="cl_alias"></span>
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
