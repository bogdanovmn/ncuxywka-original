<TMPL_IF NAME="creo_statistic">

<table class="info creo_statistic">
	<tr>
	<td class=title>����������
	<tr>
	<td>
		<p>
			���-�� ����������: 
			<br>
			<span class=value><TMPL_VAR NAME="views_total"></span>
		</p>
		<TMPL_IF NAME="selections_total">
			<p title="<TMPL_LOOP NAME='selections_info'><TMPL_VAR NAME='si_user_name'>&#10;&#13;</TMPL_LOOP>">
				�������� � ���������:
				<br>
				<span class=value><TMPL_VAR NAME="selections_total"></span>
			</p>
		</TMPL_IF>
</table>

</TMPL_IF>
