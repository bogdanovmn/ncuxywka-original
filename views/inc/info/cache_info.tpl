<TMPL_IF NAME="cache_total_size">

<table class="info creo_statistic">
	<tr>
	<td class=title>Кэш
	<tr>
	<td>
		<p>
			Кол-во элементов: 
			<br>
			<span class=value><TMPL_VAR NAME="cache_elements_count"></span>
		</p>
		<p>
			Общий объем:
			<br>
			<span class=value><TMPL_VAR NAME="cache_total_size"></span>
		</p>
		<p>
			Uptime:
			<br>
			<span class=value><TMPL_VAR NAME="cache_uptime"></span>
		</p>
</table>

</TMPL_IF>
