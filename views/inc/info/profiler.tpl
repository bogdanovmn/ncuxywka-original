<TMPL_IF NAME="ms_profiler">

<table class="info_gray">
	<tr>
	<td class=title>���������
	<tr>
	<td>
		<p>
			DB connections:
			<b><TMPL_VAR NAME="profiler_db_connections"></b>
		</p>
		<p>
			DB connections time:
			<b><TMPL_VAR NAME="profiler_db_connect_time"></b>
		</p>
		<p>
			����� SQL:
			<b><TMPL_VAR NAME="profiler_sql_time"></b>
		</p>
		<p>
			����� �����: 
			<b><TMPL_VAR NAME="profiler_gen_time"></b>
		</p>
		<p>
			���-�� SQL:
			<b><TMPL_VAR NAME="profiler_sql_count"></b>
		</p>

</table>

</TMPL_IF>
