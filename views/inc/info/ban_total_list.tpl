<TMPL_IF NAME="ban_total_list">

<table class=info>
	<tr>
	<td class=title>����� ����� ��������
	<tr>
	<td>
	<TMPL_LOOP NAME="ban_total_list">
		<p class=user_creo_list>
		<a href="/users/<TMPL_VAR NAME='btl_user_id'>.html"><b><TMPL_VAR NAME="btl_name"></b></a>
		<br><span class=note>[����� �����: <TMPL_VAR NAME="btl_time">]</span>
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
