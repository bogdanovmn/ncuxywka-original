<TMPL_IF NAME="user_creo_list">

<table class=info>
	<tr>
	<td class=title>Анализы пациэнта
	<tr>
	<td>
	<TMPL_IF NAME="avatar">
		<center><p><img alt='<TMPL_VAR NAME="cl_alias">' src='/<TMPL_VAR NAME="avatar">_thumb'></center>
	</TMPL_IF>
	<tr>
	<td>
	<TMPL_LOOP NAME="user_creo_list">
		<p class=user_creo_list>
		<TMPL_IF NAME="cl_selected">
			<TMPL_IF NAME="cl_quarantine"><s></TMPL_IF>
			&#149;&nbsp;<TMPL_VAR NAME="cl_title">
			<TMPL_IF NAME="cl_quarantine"></s></TMPL_IF>
		<TMPL_ELSE>
			<a title="Диагнозов: <TMPL_VAR NAME='cl_comments_count'>" href="/creos/<TMPL_VAR NAME='cl_id'>.html">
				<TMPL_IF NAME="cl_quarantine"><s></TMPL_IF>
				<TMPL_VAR NAME="cl_title"><TMPL_IF NAME="cl_quarantine"></s></TMPL_IF></a>
		</TMPL_IF>
		<TMPL_UNLESS NAME="cl_self_vote">
			<span class=subnote>?</span>
		</TMPL_UNLESS>
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
