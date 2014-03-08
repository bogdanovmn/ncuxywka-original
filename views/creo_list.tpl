<div class=search_menu>
	<form method=post action="/search/">
		<input type=text name=search_text>
		<input type=submit value="�����">
	</form>
</div>

<center>
	<TMPL_IF NAME=quarantine>
		<h1>�<span class=letter>�</span>�<span class=letter>A</span>����</h1>
		<p class=note>����� ��������� ��� �������, ������� �� ������ ���������, �������� �������� � �������� ��� ��������� ���������.</p>
		<p>&nbsp;</p>
	</TMPL_IF>

	<TMPL_IF NAME=deleted>
		<h1>���<span class=letter>�</span>���� �<span class=letter>�</span>�������</h1>
		<p class=note>����� ��������� ��� ������������� �������</p>
		<p>&nbsp;</p>
	</TMPL_IF>

	<TMPL_IF NAME=regular_creo_list>
		<h1>�����<span class=letter>Z</span>�</h1>
		<p class=note>����� ��������� ��� �������. ���� �� ������ ����� ���� ������� - ����� <a href='/add_creo/'>����</a></p>
		<p>&nbsp;</p>
	</TMPL_IF>
	
	<TMPL_IF NAME=neofuturism>
		<h1><span class=letter>NEO</span>������<span class=letter>Z</span>�</h1>
		<p class=note>����� ��������� ��� ������������. ��������� ������� <a href='/neo_faq_room/'>���</a></p>
		<p>&nbsp;</p>
	</TMPL_IF>
</center>

<p class=jump>
<TMPL_LOOP NAME=jump_links>
	<TMPL_IF NAME=selected>
		<span>&nbsp;<TMPL_VAR NAME=title>&nbsp;</span>
	<TMPL_ELSE>
		<a href='/<TMPL_VAR NAME=type>/<TMPL_VAR NAME=name>/'>&nbsp;<TMPL_VAR NAME=title>&nbsp;</a>
	</TMPL_IF> 
</TMPL_LOOP>
</p>

<table class=creo_list>
	<tr>
	<th class=date>����<TMPL_UNLESS NAME=alex_jile><th class=user>�������</TMPL_UNLESS><th class=title>��������<th class=comments>����<th class=resume>�������
<TMPL_LOOP NAME=creo_list>
	<tr>
		<td class=date>
			<TMPL_VAR NAME=cl_post_date>
		<TMPL_UNLESS NAME=alex_jile>
			<td class=user>
				<TMPL_IF NAME=cl_user_id>
					<a href='/users/<TMPL_VAR NAME=cl_user_id>.html'><TMPL_VAR NAME=cl_alias></a>
				<TMPL_ELSE>
					<TMPL_VAR NAME=cl_alias>
				</TMPL_IF>
		</TMPL_UNLESS>
		<td class=title>
			<a href="/creos/<TMPL_VAR ESCAPE=URL NAME=cl_id>.html"><TMPL_VAR NAME=cl_title></a>
			<TMPL_UNLESS NAME=cl_self_vote>
				<span class=subnote>?</span>
			</TMPL_UNLESS>
		<td class=comments>
			<TMPL_VAR NAME=cl_comments_count>
		<td class=resume>
			<TMPL_VAR NAME=cl_votes_count>
</TMPL_LOOP>
</table>

<TMPL_IF NAME=quarantine>
	<div class=deleted_creos_link>
		<a href="/deleted/">�������� ���������</a>
	</div>
</TMPL_IF>
