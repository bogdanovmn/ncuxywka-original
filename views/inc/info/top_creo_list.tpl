<TMPL_IF top_creo_list>

<table class=info>
	<tr>
	<td class=title>Верх шизофренизма
	<tr>
	<td>
	<TMPL_LOOP top_creo_list>
		<p class=user_creo_list>
		<span class=note><TMPL_VAR __counter__>. </span>
		<a href="/creos/<TMPL_VAR tcl_id>.html" title="Голосов: <TMPL_VAR tcl_cnt>">
			<b><TMPL_VAR tcl_title></b></a>
		<TMPL_UNLESS tcl_self_vote>
			<span class=subnote>?</span>
		</TMPL_UNLESS>
		<br>
		<span class=subnote><TMPL_VAR tcl_alias></span>
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
