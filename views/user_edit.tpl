<TMPL_INCLUDE NAME="top.tpl">
<!-- Content -->
<td class=content> 
	<center><h1>И<span class=letter>Z</span>МЕНИТЬ ДАННЫЕ</h1>
	<form name='edit_user' method=post enctype='multipart/form-data'>
		<table class=user_edit_menu>
		<tr>
			<td id="m_password" class=selected onclick="select_block('password');">Пароль
			<td id="m_avatar" onclick="select_block('avatar');">Аватар
			<td id="m_contact" onclick="select_block('contact');">Контакты
			<td id="m_about" onclick="select_block('about');">О себе
		</table>
		<div class="edit_elements_open" id="password">
			<table class=form>
				<tr>
					<td>Cтарый пароль <span class=require>*</span>
					<td>
					<input size=35 type=password name=old_password value='' autocomplete=off >
				<tr>
					<td>Новый пароль <span class=require>*</span>
					<td>
					<input size=35 type=password name=new_password value=''>
				<tr>
					<td>Новый пароль (повтор) <span class=require>*</span>
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
						<br><input type=checkbox name=delete_avatar> Удалить аватар
					</TMPL_IF>
				<td class=change_avatar>
					Изменить аватар 
					<br>
					<span class=note>(файл должен быть в формате jpeg и размером не более 200Kb)</span>
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
					<td>Город:
					<td>
					<input size=35 type=text maxlength=50 name=city value='<TMPL_VAR NAME="city">'>
				<tr>
					<td>На что жалуемся, товарищ?
					<td>
					<textarea name=hates value='' cols=60 rows=6><TMPL_VAR NAME="hates"></textarea>
				<tr>
					<td>Отношение к лекарствам:
					<td>
					<textarea name=loves value='' cols=60 rows=6><TMPL_VAR NAME="loves"></textarea>
				<tr>
					<td>О себе:
					<td>
					<textarea name=about value='' cols=60 rows=6><TMPL_VAR NAME="about"></textarea>
			</table>
		</div>
		<input type=hidden name=action value='add'>
		<input type=submit value='Обновить свои данные'>
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
