<TMPL_INCLUDE NAME="top.tpl">
<!-- Content -->
<td class=content> 
	<div class=search_menu>
		<form method=post action="/search/">
			<input type=text name=search_text value="<TMPL_VAR NAME='search_text'>">
			<input type=submit value="�����">
		</form>
	</div>
	<center>
			<h1>��<span class=letter>�Y</span>����� �<span class=letter>�</span>����</h1>
	</center>

	<TMPL_IF NAME="creo_list">
		<table class="creo_list search_creo_list">
			<tr>

			<th class=date>����
			<th class=user>�������
			<th class=title>��������
		
		<TMPL_LOOP NAME="creo_list">
			<tr>
				<td class=date>
					<TMPL_VAR NAME="cl_post_date">
				<td class=user>
					<TMPL_IF NAME="cl_user_id">
						<a href='/users/<TMPL_VAR NAME="cl_user_id">.html'><TMPL_VAR NAME="cl_alias"></a>
					<TMPL_ELSE>
						<TMPL_VAR NAME="cl_alias">
					</TMPL_IF>
				<td class=title>
					<TMPL_IF NAME="cl_quarantine"><s></TMPL_IF>
					<a href="/creos/<TMPL_VAR ESCAPE=URL NAME='cl_id'>.html"><TMPL_VAR NAME="cl_title"></a>
					<TMPL_IF NAME="cl_quarantine"></s></TMPL_IF>
					<TMPL_UNLESS NAME="cl_self_vote">
						<span class=subnote>?</span>
					</TMPL_UNLESS>
		</TMPL_LOOP>
		</table>
	<TMPL_ELSE>
		<center><div class=strict>������ �� �������</div></center>
	</TMPL_IF>
<!-- Bottom -->
<TMPL_INCLUDE NAME="bottom.tpl">
