<TMPL_INCLUDE NAME="top.tpl">
<!-- Content -->
<td class=content> 
	<center>
	<TMPL_IF NAME="black_copy_edit">
		<h1>����<span class=letter>�</span>��<span class=letter>�</span></h1>
		<form onsubmit="return check_post_data();" name='update_black_copy' method=post>
			<table class=form>
				<tr>
					<td><span class=note>��������:</span>
					<td>
					<input id=creo_title size=75 maxlength=250 type=text name=title value='<TMPL_VAR NAME="c_title">'>
				<tr>
					<td><span class=note>�������:</span>
					<td>
					<textarea id=creo_body name=body value='' cols=75 rows=25><TMPL_VAR NAME="c_body"></textarea>
				<tr>
					<td>&nbsp;
					<td>
						<input type=submit name='update' value='��������� ���������'>
			</table>
			<input type=hidden name=action value='add'>
			<input type=hidden name=id value='<TMPL_VAR NAME="creo_id">'>
		</form>
	<TMPL_ELSE>
		<TMPL_UNLESS NAME="can_public">
			<div class=strict>���� ���������� ������� �������� ��� ��� �� ���������� �������!<br>�� �������� ��� ����� ��������� ������<br>�� ����� ��� ����� <TMPL_VAR NAME="time_to_public"></div> 
			<p>&nbsp;
		</TMPL_UNLESS>
		<table class=black_copy_menu>
			<tr>
			<td class=public>
				<form method=post onsubmit="return check_public_data();">
					<TMPL_IF NAME="can_public">
						<input type=submit value="����� ���� ������">
					</TMPL_IF>
					<input type=hidden name="id" value="<TMPL_VAR NAME='creo_id'>">
					<input type=hidden name="action" value="public">
					<TMPL_IF NAME="can_public">
						<br>
						<input id=faq_read type=checkbox name='faq'> C <a href='/faq_room/'>FAQ'��</a> ���������� � ��������!
					</TMPL_IF>
				</form>
			<td class=edit>
				<a href="/black_copy/edit/<TMPL_VAR NAME='creo_id'>.html">
					<input type=button value="������ ������">
				</a>
		</table>
		<h1>����<span class=letter>�</span>��<span class=letter>�</span></h1>
		<span class=creo_title><TMPL_VAR NAME="c_title"></span>
		<br><br>
		<div class=creo_body><TMPL_VAR ESCAPE="NONE" NAME="c_body"></div>
	</TMPL_IF>

	</center>

<SCRIPT language='javascript' type="text/javascript">
<!--
function check_post_data() {
    if (document.getElementById('creo_title').value == '' || document.getElementById('creo_body').value == '') {
        alert('�������� ������� � ����� ������� ������ ���� ���������!');
		return false;
    }
    return true;
}
function check_public_data() {
	if (!document.getElementById('faq_read').checked) {
        alert('������������ ����������� ��� �������� FAQ!');
		return false;
    }
    return true;
}
-->
</SCRIPT>

<!-- Bottom -->
<TMPL_INCLUDE NAME="bottom.tpl">
