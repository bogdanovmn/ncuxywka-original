<TMPL_IF user_creo_list>

<table class=info>
	<tr>
	<td class=title>Анализы пациэнта
	<tr>
	<td>
	<TMPL_IF avatar>
		<center><p><img alt='<TMPL_VAR cl_alias>' src='/<TMPL_VAR avatar>_thumb'></center>
	</TMPL_IF>
	<tr>
	<td>
	<TMPL_LOOP user_creo_list>
		<p class=user_creo_list>
		<TMPL_IF cl_selected>
			<TMPL_IF cl_quarantine><s></TMPL_IF>
			&#149;&nbsp;<TMPL_VAR cl_title>
			<TMPL_IF cl_quarantine></s></TMPL_IF>
		<TMPL_ELSE>
			<a title="Диагнозов: <TMPL_VAR cl_comments_count>" href="/creos/<TMPL_VAR cl_id>.html">
				<TMPL_IF cl_quarantine><s></TMPL_IF>
				<TMPL_VAR cl_title><TMPL_IF cl_quarantine></s></TMPL_IF></a>
		</TMPL_IF>
		<TMPL_UNLESS cl_self_vote>
			<span class=subnote>?</span>
		</TMPL_UNLESS>
		</p>
	</TMPL_LOOP>

	<TMPL_IF user_creo_list_more>
		<div class=more_creos>
					<a href="/users/<TMPL_VAR c_user_id>.html#creos">... читать ещё <TMPL_VAR user_creo_list_more> ...</a>
		</div>
	</TMPL_IF>
	
</table>

</TMPL_IF>
