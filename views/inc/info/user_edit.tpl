<TMPL_IF NAME="user_edit_menu">

<table class=info_red>
	<tr>
	<td class=title>������ ���������
	<tr>
	<td>
		<TMPL_IF NAME="ms_user_ban">
			<p class=submenu>&#149;&nbsp;
			<TMPL_IF NAME="user_ban_left_time">
				�� ��������� �������� ��������
				<span class=note><TMPL_VAR NAME="user_ban_left_time"></span>
			<TMPL_ELSE>
				<a href="/procedure.cgi?user_id=<TMPL_VAR NAME='u_id'>">��������� ���������</a>
				<br>
				<span class=note>�����������������: 6 �����</span>
			</TMPL_IF>
			</p>
		</TMPL_IF>
		
		<TMPL_IF NAME="god">
			<p class=submenu>&#149;&nbsp;
				<a target=_blank href="http://ip-whois.net/ip_geo.php?ip=<TMPL_VAR NAME='u_ip'>">���������</a>
			</p>
		</TMPL_IF>
</table>

</TMPL_IF>
