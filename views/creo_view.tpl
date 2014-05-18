<center>
<TMPL_IF NAME=quarantine>
	<h1>ЛЕТ<span class=letter>А</span>ЛЬНЫЙ ИС<span class=letter>X</span>OД:</h1>
<TMPL_ELSE>
	<TMPL_IF NAME=deleted>
		<h1>МУС<span class=letter>О</span>РНЫЙ К<span class=letter>О</span>НТЕЙНЕР</h1>
	<TMPL_ELSE>
		<TMPL_IF NAME=neofuturism>
			<h1><span class=letter>NEO</span>ФУТУРИ<span class=letter>Z</span>М:</h1>
		<TMPL_ELSE>
			<h1>АНАЛИ<span class=letter>Z</span>:</h1>
		</TMPL_IF>
	</TMPL_IF>
</TMPL_IF>
<p>
<a href='/users/<TMPL_VAR NAME=c_user_id>.html'>
	<span class=creo_author><TMPL_VAR NAME=c_alias></span></a>, 
	<span class=creo_date><TMPL_VAR NAME=c_post_date></span>
	&nbsp;&nbsp;<a href='/print/<TMPL_VAR NAME=c_id>.html'><img alt='Для печати' src='/img/printer.gif'></a>
<br>
<br>
<span class=creo_title><TMPL_VAR NAME=c_title></span>
<br>
<br>
</p>
</center>

<TMPL_IF NAME=deleted>
	<p class='deleted_msg'>
		<TMPL_IF NAME=plagiarist>
			Анализ отправлен в регистратуру для поиска хозяина
		<TMPL_ELSE>
			Уборщица шваброй махнула и случайно удалила этот анализ...
		</TMPL_IF>
	</p>
<TMPL_ELSE>
	<div class=creo_body><TMPL_VAR ESCAPE="NONE" NAME=c_body></div>
</TMPL_IF>
<br><br>
<hr>

<center>

<TMPL_UNLESS NAME=deleted>

<TMPL_IF NAME=can_select>
<form method=post action='/select/add/<TMPL_VAR NAME=creo_id>'>
	<input type=submit value='Добавить этот анализ в мое избранное!'><br><br>
</form>
</TMPL_IF>
<table class=creo_vote_result>
<tr>
<td>
	<p class=note>Уже проголосовало <TMPL_VAR NAME=votes> пациэнтов</p>
	
	<TMPL_UNLESS NAME=has_vote_power>
		<p class=note>У вас еще слишком мало опыта чтобы голосовать!</p>
	</TMPL_UNLESS>

	<TMPL_IF NAME=already_voted>
		<p class=note>Вы уже голосовали за этот анализ...</p>

	
		<TMPL_IF NAME=votes_rank>
			<td>
			<img alt="<TMPL_VAR NAME=votes_rank_title>" src="/img/stamps/<TMPL_VAR NAME=votes_rank>.jpg">
		</TMPL_IF>
	</TMPL_IF>
</table>
<TMPL_IF NAME=can_vote>
	<h1><span class=letter>О</span>ЦЕНИ:</h1>
	<p>
	<form method=post action='/vote'>
		<table class=vote> 
		<tr>
		<td><input type=radio name=vote_id value='1'><td>Психоз!
		<tr>
		<td><input type=radio name=vote_id value='2'><td>Шизофрения
		<tr>
		<td><input type=radio name=vote_id value='3'><td>паФрейду
		<tr>
		<td><input type=radio name=vote_id value='4'><td>Параноя
		<tr>
		<td><input type=radio name=vote_id value='5'><td>Пациэнт нуждается в лоботомии!
		<tr>
		<td colspan=2><br><input type=submit value='Оценить'>
		</table>
		<input type=hidden name=creo_id value="<TMPL_VAR NAME=creo_id>">
	</form>
</TMPL_IF>

<TMPL_IF NAME=ad_votes>
	<table class=creo_votes>
	<TMPL_LOOP NAME=ad_votes>
		<tr>
		<td><a href="/usersa/<TMPL_VAR NAME=cv_user_id>.html"><TMPL_VAR NAME=cv_user_name></a>
		<td><TMPL_VAR NAME=cv_ip>
		<td><TMPL_VAR NAME=cv_vote>
		<td><TMPL_VAR NAME=cv_date>
		<td><TMPL_VAR NAME=cv_delta>

	</TMPL_LOOP>
	</table>
</TMPL_IF>
<hr>

</TMPL_UNLESS>

<TMPL_INCLUDE NAME="social_networks.tpl">

<TMPL_IF NAME=comments>
	<h1>ДИАГНО<span class=letter>Z</span>Ы:</h1>
</TMPL_IF>

<TMPL_INCLUDE NAME="inc/comments.tpl">

<TMPL_UNLESS NAME=deleted>
	<h1>П<span class=letter>О</span>СТАВЬ Д<span class=letter>И</span>АГНО<span class=letter>Z</span>!</h1>
	
	<TMPL_INCLUDE NAME="inc/comments_post_form.tpl">
</TMPL_UNLESS>

</center>
