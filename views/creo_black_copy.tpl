<TMPL_INCLUDE NAME="top.tpl">
<!-- Content -->
<td class=content> 
	<center>
	<TMPL_IF NAME="black_copy_edit">
		<h1>ЧЕРН<span class=letter>О</span>ВИ<span class=letter>К</span></h1>
		<form onsubmit="return check_post_data();" name='update_black_copy' method=post>
			<table class=form>
				<tr>
					<td><span class=note>Название:</span>
					<td>
					<input id=creo_title size=75 maxlength=250 type=text name=title value='<TMPL_VAR NAME="c_title">'>
				<tr>
					<td><span class=note>Анализы:</span>
					<td>
					<textarea id=creo_body name=body value='' cols=75 rows=25><TMPL_VAR NAME="c_body"></textarea>
				<tr>
					<td>&nbsp;
					<td>
						<input type=submit name='update' value='Сохранить изменения'>
			</table>
			<input type=hidden name=action value='add'>
			<input type=hidden name=id value='<TMPL_VAR NAME="creo_id">'>
		</form>
	<TMPL_ELSE>
		<TMPL_UNLESS NAME="can_public">
			<div class=strict>Ваши предыдущие анализы показали нам что Вы достаточно здоровы!<br>Мы советуем Вам сдать следующий анализ<br>не ранее чем через <TMPL_VAR NAME="time_to_public"></div> 
			<p>&nbsp;
		</TMPL_UNLESS>
		<table class=black_copy_menu>
			<tr>
			<td class=public>
				<form method=post onsubmit="return check_public_data();">
					<TMPL_IF NAME="can_public">
						<input type=submit value="Сдать этот анализ">
					</TMPL_IF>
					<input type=hidden name="id" value="<TMPL_VAR NAME='creo_id'>">
					<input type=hidden name="action" value="public">
					<TMPL_IF NAME="can_public">
						<br>
						<input id=faq_read type=checkbox name='faq'> C <a href='/faq_room/'>FAQ'ом</a> ознакомлен и согласен!
					</TMPL_IF>
				</form>
			<td class=edit>
				<a href="/black_copy/edit/<TMPL_VAR NAME='creo_id'>.html">
					<input type=button value="Внести правки">
				</a>
		</table>
		<h1>ЧЕРН<span class=letter>О</span>ВИ<span class=letter>К</span></h1>
		<span class=creo_title><TMPL_VAR NAME="c_title"></span>
		<br><br>
		<div class=creo_body><TMPL_VAR ESCAPE="NONE" NAME="c_body"></div>
	</TMPL_IF>

	</center>

<SCRIPT language='javascript' type="text/javascript">
<!--
function check_post_data() {
    if (document.getElementById('creo_title').value == '' || document.getElementById('creo_body').value == '') {
        alert('Название анализа и текст анализа должны быть заполнены!');
		return false;
    }
    return true;
}
function check_public_data() {
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
