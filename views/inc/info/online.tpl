<TMPL_IF NAME="online">
<table class=info>
	<tr>
	<td class=title>На проводе
	<tr>
	<td>
		<TMPL_LOOP NAME="online">
			<p class=user_creo_list>
			<TMPL_IF NAME="o_count">
				<br>
				<span class=note><b>Случайные прохожие:</b> <TMPL_VAR NAME="o_count"></span>
			<TMPL_ELSE>
				<TMPL_IF NAME="o_user_id">
					<a class=user_online href='/users/<TMPL_VAR NAME="o_user_id">.html'><TMPL_VAR NAME="o_user_name"></a>
					<br>
					<span class=note><TMPL_VAR NAME="o_action_time"></span>
				</TMPL_IF>
			</TMPL_IF>
			</p>
		</TMPL_LOOP>
</table>

</TMPL_IF>
