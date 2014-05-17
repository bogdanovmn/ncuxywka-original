<center><h1><span class=letter>Z</span>АРЕГИСТРИР<span class=letter>Y</span>ЙСЯ!</h1>
<TMPL_IF NAME=user_auth>
	<p>Вы уже зарегистрированы!<br>Перед регистрацией другого пациэнта вам необходимо <a href='/auth/out'>выйти</a>.</p>
<TMPL_ELSE>
	<p>Прежде чем регистрироваться, прочитайте пожалуйста <a href='/faq_room/'>FAQ</a><br><br></p>
	<form onsubmit="return check_post_data();" name='add_user' method=post action=''>
		<table class=form>
			<tr>
				<td>Имя <span class=require>*</span><br><span class=note>Будет вашим логином и отображаться<br>на Психуюшке (не более 50 символов)</span>
				<td>
				<input id=reg_name size=35 type=text maxlength=50 name=name>
			<tr>
				<td>Пароль <span class=require>*</span><br><span class=note>Для входа на Психуюшку под<br>своим именем</span>
				<td>
				<input id=reg_pass size=35 type=password name=password value=''>
			<tr>
				<td>Пароль (повтор) <span class=require>*</span><br><span class=note>Это на случай, если вы во время<br>ввода пароля случайно уронили<br>шкаф на клавиатуру</span>
				<td>
				<input id=reg_pass_check size=35 type=password name=password_check value=''>
			<tr>
				<td>e-mail <span class=require>*</span><br><span class=note>Не будет отображаться на Психуюшке,<br>но пригодится, например, если вы<br>забудите пароль...</span>
				<td>
				<input id=reg_email size=35 type=text maxlength=40 name=email>
			<tr>
				<td>Город<br><span class=note>Где проживаете в данный<br>момент (душой и/или телом)</span>
				<td>
				<input size=35 type=text maxlength=50 name=city>
			<tr>
				<td>На что жалуемся, товарищ?
				<td>
				<textarea name=hates cols=60 rows=6></textarea>
			<tr>
				<td>Отношение к лекарствам 
				<td>
				<textarea name=loves cols=60 rows=6></textarea>
			<tr>
				<td>О себе<br><span class=note>Можете похвалить себя<br>или поругать :)</span>
				<td>
				<textarea name=about cols=60 rows=6></textarea>
			<tr>
				<td>&nbsp;
				<td>
				<input type=submit value='Оформиться'>
		</table>
		<input type=hidden name=action value='add'>
	</form>
</TMPL_IF>
</center>

<SCRIPT language='javascript' type="text/javascript">
<!--
function check_post_data() {
	var phrase = 'Не заполнено обязательное поле ';
    
	if (document.getElementById('reg_name').value == '') {
        alert(phrase + '"Имя"!');
		return false;
    }
	if (document.getElementById('reg_pass').value == '') {
        alert(phrase + '"Пароль"!');
		return false;
    }
	if (document.getElementById('reg_pass_check').value == '') {
        alert(phrase + '"Пароль (повтор)"!');
		return false;
    }
	if (document.getElementById('reg_email').value == '') {
        alert(phrase + '"e-mail"!');
		return false;
    }
	if (document.getElementById('reg_pass').value != document.getElementById('reg_pass_check').value) {
        alert('Повторный ввод пароля неверен!');
		return false;
    }
	
    return true;
}
-->
</SCRIPT>
