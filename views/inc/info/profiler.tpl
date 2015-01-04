<TMPL_IF ms_profiler>

<table class="info_gray">
	<tr>
	<td class=title>Профайлер
	<tr>
	<td>
		<p>
			DB connections:
			<b><TMPL_VAR profiler_db_connections></b>
		</p>
		<p>
			DB connections time:
			<b><TMPL_VAR profiler_db_connect_time></b>
		</p>
		<p>
			Время SQL:
			<b><TMPL_VAR profiler_sql_time></b>
		</p>
		<p>
			Общее время: 
			<b><TMPL_VAR profiler_gen_time></b>
		</p>
		<p>
			Кол-во SQL:
			<b><TMPL_VAR profiler_sql_count></b>
		</p>

</table>

</TMPL_IF>
