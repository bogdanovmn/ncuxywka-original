<TMPL_INCLUDE NAME="top.tpl">
<!-- Content -->
<td class=content> 
	<center><h1><span class=letter>Z</span>����������<span class=letter>Y</span>���!</h1>
	<TMPL_IF NAME="user_auth">
		<p>�� ��� ����������������!<br>����� ������������ ������� �������� ��� ���������� <a href='/auth/out'>�����</a>.</p>
	<TMPL_ELSE>
		<p>������ ��� ����������������, ���������� ���������� <a href='/faq_room/'>FAQ</a><br><br></p>
		<form onsubmit="return check_post_data();" name='add_user' method=post action=''>
			<table class=form>
				<tr>
					<td>��� <span class=require>*</span><br><span class=note>����� ����� ������� � ������������<br>�� ��������� (�� ����� 50 ��������)</span>
					<td>
					<input id=reg_name size=35 type=text maxlength=50 name=name>
				<tr>
					<td>������ <span class=require>*</span><br><span class=note>��� ����� �� ��������� ���<br>����� ������</span>
					<td>
					<input id=reg_pass size=35 type=password name=password value=''>
				<tr>
					<td>������ (������) <span class=require>*</span><br><span class=note>��� �� ������, ���� �� �� �����<br>����� ������ �������� �������<br>���� �� ����������</span>
					<td>
					<input id=reg_pass_check size=35 type=password name=password_check value=''>
				<tr>
					<td>e-mail <span class=require>*</span><br><span class=note>�� ����� ������������ �� ���������,<br>�� ����������, ��������, ���� ��<br>�������� ������...</span>
					<td>
					<input id=reg_email size=35 type=text maxlength=40 name=email>
				<tr>
					<td>�����<br><span class=note>��� ���������� � ������<br>������ (����� �/��� �����)</span>
					<td>
					<input size=35 type=text maxlength=50 name=city>
				<tr>
					<td>�� ��� ��������, �������?
					<td>
					<textarea name=hates cols=60 rows=6></textarea>
				<tr>
					<td>��������� � ���������� 
					<td>
					<textarea name=loves cols=60 rows=6></textarea>
				<tr>
					<td>� ����<br><span class=note>������ ��������� ����<br>��� �������� :)</span>
					<td>
					<textarea name=about cols=60 rows=6></textarea>
				<tr>
					<td>&nbsp;
					<td>
					<input type=submit value='����������'>
			</table>
			<input type=hidden name=ses value='<TMPL_VAR NAME="ses">'>
			<input type=hidden name=action value='add'>
		</form>
	</TMPL_IF>
	</center>

<SCRIPT language='javascript' type="text/javascript">
<!--
function check_post_data() {
	var phrase = '�� ��������� ������������ ���� ';
    
	if (document.getElementById('reg_name').value == '') {
        alert(phrase + '"���"!');
		return false;
    }
	if (document.getElementById('reg_pass').value == '') {
        alert(phrase + '"������"!');
		return false;
    }
	if (document.getElementById('reg_pass_check').value == '') {
        alert(phrase + '"������ (������)"!');
		return false;
    }
	if (document.getElementById('reg_email').value == '') {
        alert(phrase + '"e-mail"!');
		return false;
    }
	if (document.getElementById('reg_pass').value != document.getElementById('reg_pass_check').value) {
        alert('��������� ���� ������ �������!');
		return false;
    }
	
    return true;
}
-->
</SCRIPT>

<!-- Bottom -->
<TMPL_INCLUDE NAME="bottom.tpl">
