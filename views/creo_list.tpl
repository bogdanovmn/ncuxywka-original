<div class=search_menu>
	<form method=post action="/search/">
		<input type=text name=search_text>
		<input type=submit value="Найти">
	</form>
</div>

<center>
	<TMPL_IF quarantine>
		<h1>К<span class=letter>А</span>Р<span class=letter>A</span>НТИН</h1>
		<p class=note>Здесь находятся все анализы, которые по мнению Главврача, являются ужасными и опасными для пациэнтов Психуюшки.</p>
		<p>&nbsp;</p>
	</TMPL_IF>

	<TMPL_IF deleted>
		<h1>МУС<span class=letter>О</span>РНЫЙ К<span class=letter>О</span>НТЕЙНЕР</h1>
		<p class=note>Здесь находятся все забракованные анализы</p>
		<p>&nbsp;</p>
	</TMPL_IF>

	<TMPL_IF regular_creo_list>
		<h1>АНАЛИ<span class=letter>Z</span>Ы</h1>
		<p class=note>Здесь находятся все анализы. Если вы хотите сдать свои анализы - жмите <a href='/add_creo/'>сюда</a></p>
		<p>&nbsp;</p>
	</TMPL_IF>
	
	<TMPL_IF neofuturism>
		<h1><span class=letter>NEO</span>ФУТУРИ<span class=letter>Z</span>М</h1>
		<p class=note>Здесь находятся все неофутуризмы. Подробнее читайте <a href='/neo_faq_room/'>тут</a></p>
		<p>&nbsp;</p>
	</TMPL_IF>
</center>

<p class=jump>
<TMPL_LOOP jump_links>
	<TMPL_IF selected>
		<span>&nbsp;<TMPL_VAR title>&nbsp;</span>
	<TMPL_ELSE>
		<a href='/<TMPL_VAR type>/<TMPL_VAR name>/'>&nbsp;<TMPL_VAR title>&nbsp;</a>
	</TMPL_IF> 
</TMPL_LOOP>
</p>

<table class=creo_list>
	<tr>
	<th class=date>Дата<TMPL_UNLESS alex_jile><th class=user>Пациэнт</TMPL_UNLESS><th class=title>Название<th class=comments>Диаг<th class=resume>Голосов
<TMPL_LOOP creo_list>
	<tr>
		<td class=date>
			<TMPL_VAR cl_post_date>
		<TMPL_UNLESS alex_jile>
			<td class=user>
				<TMPL_IF cl_user_id>
					<a href='/users/<TMPL_VAR cl_user_id>.html'><TMPL_VAR cl_alias></a>
				<TMPL_ELSE>
					<TMPL_VAR cl_alias>
				</TMPL_IF>
		</TMPL_UNLESS>
		<td class=title>
			<a href="/creos/<TMPL_VAR ESCAPE=URL NAME=cl_id>.html"><TMPL_VAR cl_title></a>
			<TMPL_UNLESS cl_self_vote>
				<span class=subnote>?</span>
			</TMPL_UNLESS>
		<td class=comments>
			<TMPL_VAR cl_comments_count>
		<td class=resume>
			<TMPL_VAR cl_votes_count>
</TMPL_LOOP>
</table>

<TMPL_IF quarantine>
	<div class=deleted_creos_link>
		<a href="/deleted/">Мусорный контейнер</a>
	</div>
</TMPL_IF>
