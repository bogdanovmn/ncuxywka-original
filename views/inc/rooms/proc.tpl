<TMPL_INCLUDE NAME='../head.tpl'>

<center>
<table class=main_simple>
<tr>
<td>
    <center><a href='/'><img src='/img/<TMPL_VAR NAME="skin_pic_logo">'></a></center>
<tr>
<td class=content>
	<center>
	<h1>�<span class=letter>�</span>�����<span class=letter>�</span>���</h1>

	<TMPL_UNLESS NAME="inside">
		<p class=note>��������� �������, ���� ��� ������� ���������� ��� ����� � ������ ��������, ��������� � ��������� ��� ���� �� ����������, ��� ��� ���������� ����������� - ����������� ����������� �������: ���� ����� ������� ��� ������ ��������� � ����� ������� ��������.</p>
		<br>
		<img src='/img/<TMPL_VAR NAME="skin_pic_proc">' width=400>
		<br><br><form name=proc_in type=post action='/procedure.cgi'>
			<select name=duration>
				<option value='5'>5 �����</option>
				<option value='15'>15 �����</option>
				<option value='30'>30 �����</option>
				<option value='60'>1 ���</option>
				<option value='180'>3 ����</option>
				<option value='1440'>1 ����</option>
			</select>
			<input type=submit value='������ ���������'>
		</form>
		<br><br>
	<TMPL_ELSE>
		<p class=note>�� ���������� � ����������� ��������. ��� �� ���� ������? �������� ���� � �����������, � �������� ��� ���� ������������� �������� ��������. � ����� ������, �����������: � ��� ����� ������������� ���� ��������� �� �������� ���������.</p>
		<p class=proc_left_time>�������� <span id='left_time'><TMPL_VAR NAME="ban_left_time"></span> ������</p>
		<br>
		<img src='/img/<TMPL_VAR NAME="skin_pic_proc">' width=400>
		<h1>���<span class=letter>Y</span>���!</h1>
		<center>
		<TMPL_INCLUDE NAME='../comments_post_form.tpl'>
		</center>
		<h1>����<span class=letter>�</span>�:</h1>
		<TMPL_INCLUDE NAME='../comments.tpl'>
		
		<script type=text/javascript> 
		<!--
			var left_time=<TMPL_VAR NAME="ban_left_time">;
			function update_left_time() {
				left_time--;
				if (left_time <= 0) {
					window.location.reload();
				}
				document.getElementById("left_time").firstChild.nodeValue = left_time;
			}
			setInterval('update_left_time()', 1000);
		//-->
		</script> 
	</TMPL_UNLESS>
<tr>
<td>
    <hr>
    <table class=bottom>
        <tr>
            <td class=copyright>&copy;2010-2013 ncuxywka.com
            <td class=note>�������� �������������: ������������� ��������� ������ ��� ������ ��������!
    </table>
    <p>&nbsp;

</table>

<TMPL_INCLUDE NAME='../foot.tpl'>
