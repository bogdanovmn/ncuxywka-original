<center>
<TMPL_IF quarantine>
	<div class=header>ЛЕТ<span class=letter>А</span>ЛЬНЫЙ ИС<span class=letter>X</span>OД:</div>
<TMPL_ELSE>
	<TMPL_IF deleted>
		<div class=header>МУС<span class=letter>О</span>РНЫЙ К<span class=letter>О</span>НТЕЙНЕР</div>
	<TMPL_ELSE>
		<TMPL_IF neofuturism>
			<div class=header><span class=letter>NEO</span>ФУТУРИ<span class=letter>Z</span>М:</div>
		<TMPL_ELSE>
			<div class=header>АНАЛИ<span class=letter>Z</span>:</div>
		</TMPL_IF>
	</TMPL_IF>
</TMPL_IF>
<p>
<a href='/users/<TMPL_VAR c_user_id>.html'>
	<span class=creo_author><TMPL_VAR c_alias></span></a>, 
	<span class=creo_date><TMPL_VAR c_post_date></span>
	&nbsp;&nbsp;<a href='/print/<TMPL_VAR c_id>.html'><img alt='Для печати' src='/img/printer.gif'></a>
</p>

<h1 class=creo_title><TMPL_VAR c_title></h1>
</center>

<TMPL_IF deleted>
	<p class='deleted_msg'>
		<TMPL_IF plagiarist>
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

<TMPL_UNLESS deleted>

<TMPL_IF can_select>
<form method=post action='/select/add/<TMPL_VAR creo_id>'>
	<input type=submit value='Добавить этот анализ в мое избранное!'><br><br>
</form>
</TMPL_IF>
<table class=creo_vote_result>
<tr>
<td>
	<p class=note>Уже проголосовало <TMPL_VAR votes> пациэнтов</p>
	
	<TMPL_UNLESS has_vote_power>
		<p class=note>У вас еще слишком мало опыта чтобы голосовать!</p>
	</TMPL_UNLESS>

	<TMPL_IF already_voted>
		<p class=note>Вы уже голосовали за этот анализ...</p>

	
		<TMPL_IF votes_rank>
			<td>
			<img alt="<TMPL_VAR votes_rank_title>" src="/img/stamps/<TMPL_VAR votes_rank>.jpg">
		</TMPL_IF>
	</TMPL_IF>
</table>
<TMPL_IF can_vote>
	<div class=header><span class=letter>О</span>ЦЕНИ:</div>
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
		<input type=hidden name=creo_id value="<TMPL_VAR creo_id>">
	</form>
</TMPL_IF>

<TMPL_IF ad_votes>
	<table class=creo_votes>
	<TMPL_LOOP ad_votes>
		<tr>
		<td><a href="/usersa/<TMPL_VAR cv_user_id>.html"><TMPL_VAR cv_user_name></a>
		<td><TMPL_VAR cv_ip>
		<td><TMPL_VAR cv_vote>
		<td><TMPL_VAR cv_date>
		<td><TMPL_VAR cv_delta>

	</TMPL_LOOP>
	</table>
</TMPL_IF>
<hr>

</TMPL_UNLESS>

<TMPL_INCLUDE NAME="social_networks.tpl">

<TMPL_IF comments>
	<div class=header>ДИАГНО<span class=letter>Z</span>Ы:</div>
</TMPL_IF>

<TMPL_INCLUDE NAME="inc/comments.tpl">

<TMPL_UNLESS deleted>
	<div class=header>П<span class=letter>О</span>СТАВЬ Д<span class=letter>И</span>АГНО<span class=letter>Z</span>!</div>
	
	<TMPL_INCLUDE NAME="inc/comments_post_form.tpl">
</TMPL_UNLESS>

</center>
