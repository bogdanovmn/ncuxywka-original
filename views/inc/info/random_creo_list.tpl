<TMPL_IF random_creo_list>

<table class=info>
	<tr>
	<td class=title>Случайные анализы
	<tr>
	<td>
	<TMPL_LOOP random_creo_list>
		<p class=user_creo_list>
		<a href="/creos/<TMPL_VAR cl_id>.html"><b><TMPL_VAR cl_title></b></a>
		<br><span class=link_note><TMPL_VAR cl_alias></span>
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
