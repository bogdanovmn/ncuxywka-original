<TMPL_IF NAME="popular_creo_list">

<table class=info>
	<tr>
	<td class=title>�������� ������
	<tr>
	<td>
	<TMPL_LOOP NAME="popular_creo_list">
		<p class=user_creo_list>
		<a href="/creos/<TMPL_VAR NAME='pcl_id'>.html"><b><TMPL_VAR NAME="pcl_title"></b> - <TMPL_VAR NAME="pcl_alias"></a>
		<span class=subnote> [���������: <TMPL_VAR NAME="pcl_last_comment_date"> �� <TMPL_VAR NAME="pcl_comment_alias">]</span>
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
