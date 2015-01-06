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
		<TMPL_IF profiler_db_connect_time>
			<p>
				DB connect time:
				<b><TMPL_VAR profiler_db_connect_time></b>
			</p>
		</TMPL_IF>
		<p>
			Время SQL:
			<b><TMPL_VAR profiler_sql_time></b> (<TMPL_VAR profiler_sql_count> q)
		</p>
		<p>
			Время Memcached:
			<b><TMPL_VAR profiler_cache_total_time></b> 
			(<TMPL_VAR profiler_cache_from_cache>/<TMPL_VAR profiler_cache_get_count>)
		</p>
		<p>
			Общее время: 
			<b><TMPL_VAR profiler_gen_time></b>
		</p>

</table>

</TMPL_IF>
