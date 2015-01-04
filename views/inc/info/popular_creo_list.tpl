<TMPL_IF popular_creo_list>

<table class=info>
	<tr>
	<td class=title>Активный диспут
	<tr>
	<td>
	<TMPL_LOOP popular_creo_list>
		<p class=user_creo_list>
		<a href="/creos/<TMPL_VAR pcl_id>.html"><b><TMPL_VAR pcl_title></b> - <TMPL_VAR pcl_alias></a>
		<span class=subnote> [Последнее: <TMPL_VAR pcl_last_comment_date> от <TMPL_VAR pcl_comment_alias>]</span>
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
