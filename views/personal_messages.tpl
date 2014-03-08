<TMPL_INCLUDE NAME="top.tpl">
<!-- Content -->
<td class=content> 
	<TMPL_IF NAME="is_last">
		<h1>�<span class=letter>�</span>�� ������ �<span class=letter>��</span>������:</h1>

		<table class=personal_messages>
		<tr>
		<td class=menu>
			<TMPL_IF NAME="is_in_messages">
				���������� :: 
				<a href='/pm/out/'>������������</a>
			<TMPL_ELSE>
				<a href='/pm/in/'>����������</a> :: 
				������������
			</TMPL_IF>
		<TMPL_LOOP NAME="messages">
			<TMPL_IF NAME="lm_new">
				<tr><td class=new_message>�����!
			</TMPL_IF>
			<tr>
			<td class=info>
				<TMPL_IF NAME="lm_is_in_message">
					�� <a class=user href='/users/<TMPL_VAR NAME="lm_user_id">.html'><span class=user_name><TMPL_VAR NAME="lm_user_name"></span></a>
				<TMPL_ELSE>
					��� <a class=user href='/users/<TMPL_VAR NAME="lm_to_user_id">.html'><span class=user_name><TMPL_VAR NAME="lm_to_user_name"></span></a>
				</TMPL_IF>
				<span class=date>
					<TMPL_IF NAME="lm_is_in_message"><a href='/pm/dialog/<TMPL_VAR NAME="lm_user_id">/'>��������</a>&nbsp;&nbsp;</TMPL_IF>
					<TMPL_VAR NAME="lm_date">
				</span>
			<tr>
			<td class=text>
				<TMPL_VAR ESCAPE="NONE" NAME="lm_msg">
			<tr>
			<td class=empty>
				&nbsp;
		</TMPL_LOOP>
		</table>
		<TMPL_IF NAME="multi_page">
			<TMPL_INCLUDE NAME="pages.tpl">
		</TMPL_IF>
	</TMPL_IF>
	
	<TMPL_IF NAME="is_dialog">
		<center>
		<h1>�<span class=letter>�</span>����<span class=letter>�</span>�� �<span class=letter>�</span>�����<span class=letter>Y</span>:</h1>
		<p>[ <span class=user_name><TMPL_VAR NAME="recipient_name"></span> ]<br><br></p>
		<form method=post>
			<textarea name=msg rows=10 cols=60></textarea>
			<br>
			<br>
			<input type=submit value="������� �� ����">
			<input type=hidden name=user_id value="<TMPL_VAR NAME='recipient_id'>">
			<input type=hidden name=action value="post">
		</form>
		</center>

		<h1>�<span class=letter>�</span>�<span class=letter>�</span> ��������<span class=letter>�</span> � ���<span class=letter>�</span> �<span class=letter>�</span>������<span class=letter>�</span><span class=letter></span>:</h1>
		<TMPL_IF NAME="multi_page">
			<TMPL_INCLUDE NAME="pages.tpl">
		</TMPL_IF>
		<table class=personal_messages>
		<TMPL_LOOP NAME="messages">
			<tr>
			<td class=info>
				<a class=user href='/users/<TMPL_VAR NAME="dm_user_id">.html'><span class=user_name><TMPL_VAR NAME="dm_user_name"></span></a>
				<span class=date><TMPL_VAR NAME="dm_date"></span>
			<tr>
			<td class=text>
				<TMPL_VAR ESCAPE="NONE" NAME="dm_msg">
			<tr>
			<td class=empty>&nbsp;
		</TMPL_LOOP>
		</table>
		<TMPL_IF NAME="multi_page">
			<TMPL_INCLUDE NAME="pages.tpl">
		</TMPL_IF>
	</TMPL_IF>

<!-- Bottom -->
<TMPL_INCLUDE NAME="bottom.tpl">
