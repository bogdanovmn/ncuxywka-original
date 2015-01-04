<TMPL_IF creo_statistic>

<table class="info creo_statistic">
	<tr>
	<td class=title>Статистика
	<tr>
	<td>
		<p>
			Кол-во просмотров: 
			<br>
			<span class=value><TMPL_VAR views_total></span>
		</p>
		<TMPL_IF selections_total>
			<p title="<TMPL_LOOP selections_info><TMPL_VAR si_user_name>&#10;&#13;</TMPL_LOOP>">
				Добавили в избранное:
				<br>
				<span class=value><TMPL_VAR selections_total></span>
			</p>
		</TMPL_IF>
</table>

</TMPL_IF>
