<TMPL_IF sql_details>
	<h1>SQL details</h1>
	<TMPL_LOOP sql_details>
		<div class=sql_details>
			<p><b>caller:</b> <TMPL_VAR caller>
			<br><b>sql:</b> <pre><TMPL_VAR sql></pre>
			<br><b>time:</b> <TMPL_VAR sql_time>
			<br>
			<table>
				<tr>
					<th>select_type
					<th>table
					<th>type
					<th>possible_keys
					<th>key
					<th>ref
					<th>rows
					<th>extra

			<TMPL_LOOP explain_details>
				<tr>
					<td><TMPL_VAR select_type>
					<td><TMPL_VAR table>
					<td><TMPL_VAR type>
					<td><TMPL_VAR possible_keys>
					<td><TMPL_VAR key>
					<td><TMPL_VAR ref>
					<td><TMPL_VAR rows>
					<td><TMPL_VAR extra>
			</TMPL_LOOP>
			</table>
				
		</div>
	</TMPL_LOOP>
<TMPL_ELSE>
	<h1>Уже ничего нет</h1>
</TMPL_IF>
