<TMPL_INCLUDE NAME="top.tpl">
<!-- Content -->
<td class=content> 
	<center><h1>СДА<span class=letter>Й</span> АНАЛИ<span class=letter>Z</span>Ы:</h1>
	<TMPL_UNLESS NAME="user_auth">
		<div class=strict>Чтобы сдать свои анализы вам необходимо <a href='/register/'>зерегистрироваться</a> <br>и войти на Психуюшку под своим именем.</div>
	<TMPL_ELSE>
		<TMPL_UNLESS NAME="can_add">
			<div class=strict>Ваши предыдущие анализы показали нам что Вы достаточно здоровы!<br>Мы советуем Вам сдать следующий анализ<br>не ранее чем через <TMPL_VAR NAME="time_to_post"></div> 
			<p>&nbsp;
		</TMPL_UNLESS>
		<div class=strict>Перед тем как сдать анализы обязательно прочьтите <a href='/faq_room/'>FAQ</a>!</div>
		<p>&nbsp;
		<form onsubmit="return check_post_data();" name='add_history' method=post>
			<table class=form>
				<tr>	
					<td><span class=note>Пациэнт:</span>
					<td>
						<span class=user_name><TMPL_VAR NAME='alias'></span>
						<input type=hidden maxlength=50 name=alias value="<TMPL_VAR NAME='alias'>">
				<tr>
					<td><span class=note>Название:</span>
					<td>
					<input id=creo_title size=75 maxlength=250 type=text name=title value=''>
				<tr>
					<td><span class=note>Анализы:</span>
					<td>
					<textarea id=creo_body name=body value='' cols=75 rows=25></textarea>
				<tr>
					<td>&nbsp;
					<td>
					<input id=faq_read type=checkbox name='faq'> C <a href='/faq_room/'>FAQ'ом</a> ознакомлен и согласен!
				<tr>
					<td>&nbsp;
					<td>
						<table class="add_creo_buttons">
							<tr>
								<td class=first>
									<TMPL_IF NAME="can_add">
										<input type=submit name='white_copy' value='Сдать анализы'>
									</TMPL_IF>
								<td class=second>
									<input type=submit name='black_copy' value='Оставить в черновиках'>
						</table>
			</table>
			<input type=hidden name=action value='add'>
		</form>
	</TMPL_UNLESS>
	</center>

<SCRIPT language='javascript' type="text/javascript">
<!--
function check_post_data() {
    if (document.getElementById('creo_title').value == '' || document.getElementById('creo_body').value == '') {
        alert('Название анализа и текст анализа должны быть заполнены!');
		return false;
    }
	
	if (!document.getElementById('faq_read').checked) {
        alert('Настоятельно рекомендуем вам прочесть FAQ!');
		return false;
    }
	
    return true;
}
-->
</SCRIPT>

<!-- Bottom -->
<TMPL_INCLUDE NAME="bottom.tpl">
