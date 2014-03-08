<TMPL_IF NAME="most_active_users">

<table class=info>
	<tr>
	<td class=title>Самые буйные
	<tr>
	<td>
	<TMPL_LOOP NAME="most_active_users">
		<p class=user_creo_list>
		<span class=note><TMPL_VAR NAME="__counter__">. </span>
		<a href="/users/<TMPL_VAR NAME='au_id'>.html"><b><TMPL_VAR NAME="au_name"></b></a>
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
