<TMPL_INCLUDE NAME="top.tpl">
<!-- Content -->
<td class=content> 
	<center><h1>�<span class=letter>Z</span>������ ������</h1>
	<form name='edit_user' method=post enctype='multipart/form-data'>
		<table class=user_edit_menu>
		<tr>
			<td id="m_password" class=selected onclick="select_block('password');">������
			<td id="m_avatar" onclick="select_block('avatar');">������
			<td id="m_contact" onclick="select_block('contact');">��������
			<td id="m_about" onclick="select_block('about');">� ����
		</table>
		<div class="edit_elements_open" id="password">
			<table class=form>
				<tr>
					<td>C����� ������ <span class=require>*</span>
					<td>
					<input size=35 type=password name=old_password value='' autocomplete=off >
				<tr>
					<td>����� ������ <span class=require>*</span>
					<td>
					<input size=35 type=password name=new_password value=''>
				<tr>
					<td>����� ������ (������) <span class=require>*</span>
					<td>
					<input size=35 type=password name=new_password_check value=''>
			</table>
		</div>
		<div class=edit_elements id="avatar">
			<table class=form>
			<tr>
				<td>
					<TMPL_IF NAME="avatar">
						<p><img src='/<TMPL_VAR NAME="avatar">_thumb'>
						<br><input type=checkbox name=delete_avatar> ������� ������
					</TMPL_IF>
				<td class=change_avatar>
					�������� ������ 
					<br>
					<span class=note>(���� ������ ���� � ������� jpeg � �������� �� ����� 200Kb)</span>
					<br><br>
					<input size=35 type=file name=avatar>
			</table>
		</div>
		<div class=edit_elements id="contact">
			<table class=form>
			<tr>
				<td>e-mail <span class=require>*</span>
				<td>
				<input size=35 type=text maxlength=50 name=email value='<TMPL_VAR NAME="email">'>
			</table>
		</div>
		<div class=edit_elements id="about">
			<table class=form>
				<tr>
					<td>�����:
					<td>
					<input size=35 type=text maxlength=50 name=city value='<TMPL_VAR NAME="city">'>
				<tr>
					<td>�� ��� ��������, �������?
					<td>
					<textarea name=hates value='' cols=60 rows=6><TMPL_VAR NAME="hates"></textarea>
				<tr>
					<td>��������� � ����������:
					<td>
					<textarea name=loves value='' cols=60 rows=6><TMPL_VAR NAME="loves"></textarea>
				<tr>
					<td>� ����:
					<td>
					<textarea name=about value='' cols=60 rows=6><TMPL_VAR NAME="about"></textarea>
			</table>
		</div>
		<input type=hidden name=action value='add'>
		<input type=submit value='�������� ���� ������'>
	</form>
	</center>

<script>
	function select_block(id) {
		var blocks = ['password', 'avatar', 'contact', 'about'];
		for (var i = 0; i < blocks.length; i++) {
			if (blocks[i] == id) {
				document.getElementById(blocks[i]).style.display = "block";
				document.getElementById("m_" + blocks[i]).setAttribute("class", "selected");
			}
			else {
				document.getElementById(blocks[i]).style.display = "none";
				document.getElementById("m_" + blocks[i]).setAttribute("class", "");
			}
		}
	}
</script>

<!-- Bottom -->
<TMPL_INCLUDE NAME="bottom.tpl">
