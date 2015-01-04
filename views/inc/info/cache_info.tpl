<TMPL_IF cache_total_size>

<table class="info creo_statistic">
	<tr>
	<td class=title>Кэш
	<tr>
	<td>
		<p>
			Кол-во элементов: 
			<br>
			<span class=value><TMPL_VAR cache_elements_count></span>
		</p>
		<p>
			Общий объем:
			<br>
			<span class=value><TMPL_VAR cache_total_size></span>
		</p>
		<p>
			Uptime:
			<br>
			<span class=value><TMPL_VAR cache_uptime></span>
		</p>
</table>

</TMPL_IF>
