<TMPL_IF NAME="vova_last_creos">

<table class=vova_last_info>
	<tr>
	<td class=title>Тепленькое от Жиля
	<tr>
	<td>
	<TMPL_LOOP NAME="vova_last_creos">
		<p class=user_creo_list>
		<a href="/creos/<TMPL_VAR NAME='cl_id'>.html"><TMPL_VAR NAME="cl_title"></a>
		<br><span class=note><TMPL_VAR NAME="cl_post_date"></span>
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
