<center>
<h1>П<span class=letter>Р</span>ОЦЕДУ<span class=letter>Р</span>НАЯ</h1>

<TMPL_UNLESS NAME=inside>
	<p class=note>Уважаемый пациэнт, если вам надоели окружающие вас психи и прочие личности, обитающие в Психуюшке или если вы чувствуете, что вам необходима шокотерапия - используйте процедурный кабинет: наши врачи сделают вам легкую лоботомию и дадут сладкую таблетку.</p>
	<br>
	<img src='/img/<TMPL_VAR NAME=skin_pic_proc>' width=400>
	<br>
	<br>
	<form method=post action='/procedure/'>
		<select name=duration>
			<option value='5'>5 минут</option>
			<option value='15'>15 минут</option>
			<option value='30'>30 минут</option>
			<option value='60'>1 час</option>
			<option value='180'>3 часа</option>
			<option value='1440'>1 день</option>
		</select>
		<input type=submit value='Начать процедуры'>
	</form>
	<br><br>
<TMPL_ELSE>
	<p class=note>Вы находитесь в процедурном кабинете. Как вы сюда попали? Возможно сами и добровольно, а возможно вас сюда принудительно отправил Главврач. В любом случае, расслабтесь: у вас выпал замечательный шанс отдохнуть от общества Психуюшки.</p>
	<p class=proc_left_time>Осталось <span id='left_time'><TMPL_VAR NAME=ban_left_time></span> секунд</p>
	<br>
	<img src='/img/<TMPL_VAR NAME=skin_pic_proc>' width=400>
	<h1>ПОБ<span class=letter>Y</span>ЯНЬ!</h1>
	<center>
	<TMPL_INCLUDE NAME='../inc/comments_post_form.tpl'>
	</center>
	<h1>Дисп<span class=letter>у</span>т:</h1>
	<TMPL_INCLUDE NAME='../inc/comments.tpl'>
	
	<script type=text/javascript> 
	<!--
		var left_time=<TMPL_VAR NAME=ban_left_time>;
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
