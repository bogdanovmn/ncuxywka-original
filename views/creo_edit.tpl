<TMPL_INCLUDE NAME="top.tpl">
<!-- Content -->
<td class=content> 
	<center>
		<h1>���<span class=letter>�</span>����<span class=letter>�</span></h1>
		<form onsubmit="return check_post_data();" name='edit_save' method=post>
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
			<input type=hidden name=action value='edit_save'>
			<input type=hidden name=id value='<TMPL_VAR NAME="c_id">'>
		</form>
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
-->
</SCRIPT>

<!-- Bottom -->
<TMPL_INCLUDE NAME="bottom.tpl">
