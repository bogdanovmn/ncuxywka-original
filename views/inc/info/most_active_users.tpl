<TMPL_IF most_active_users>

<table class=info>
	<tr>
	<td class=title>Самые буйные
	<tr>
	<td>
	<TMPL_LOOP most_active_users>
		<p class=user_creo_list>
		<span class=note><TMPL_VAR __counter__>. </span>
		<a href="/users/<TMPL_VAR au_id>.html"><b><TMPL_VAR au_name></b></a>
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
