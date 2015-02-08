<TMPL_IF sql_details>
	<h1>SQL</h1>

	<a id=contents></a>
	<h2>Contents</h2>
	<table class=sql_details_head>
	<TMPL_LOOP sql_details>
		<tr>
			<td><TMPL_VAR sql_time>
			<td><TMPL_VAR explain_total_rows>
			<td><TMPL_VAR extra>
			<td><a href="#<TMPL_VAR __counter__>"><TMPL_VAR caller DEFAULT='???'></a>
	</TMPL_LOOP>
	</table>
		
	<h2>Details</h2>

	<TMPL_LOOP sql_details>
		<a id=<TMPL_VAR __counter__>></a>
		<div class=sql_details>
			<p>
			<b>caller:</b> <TMPL_VAR caller>
			<br>
			<b>time:</b> <TMPL_VAR sql_time>
			<br>
			<b>sql:</b> <pre><TMPL_VAR sql ESCAPE=NONE></pre>
			<br>
			<b>explain:</b>
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
				
		<a href=#contents>up</a>
		</div>
	</TMPL_LOOP>
<TMPL_ELSE>
	<h1>Уже ничего нет</h1>
</TMPL_IF>
