<TMPL_IF vova_last_creos>

<table class=vova_last_info>
	<tr>
	<td class=title>Тепленькое от Жиля
	<tr>
	<td>
	<TMPL_LOOP vova_last_creos>
		<p class=user_creo_list>
		<a href="/creos/<TMPL_VAR cl_id>.html"><TMPL_VAR cl_title></a>
		<br><span class=note><TMPL_VAR cl_post_date></span>
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
