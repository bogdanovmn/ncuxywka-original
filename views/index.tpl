<table class=main_news>
<tr>
<td class=about>
	<center>
	<table class=info_about>
		<tr>
		<td class=title>КУДА Я ПОПАЛ?
		<tr>
		<td><b>Психуюшка</b> - это литературное онлайн сообщество, полная свобода слова и отсутствие цензуры. <a href='/faq_room/'>Подробнее...</a>
	</table>
	<table class=info_about>
	<tr>
	<td class=title>ЗАЧЕМ?
	<tr>
	<td><p><a href='/creos/'>Почитать анализы</a>
		<p><a href='/talks/'>Поставить диагнозы</a>
		<p><a href='/add_creo/'>Прислать свои анализы</a>
	</table>
	</center>
<td>
	<center><img alt='ПСИХУЮШКА.COM' src='/img/<TMPL_VAR NAME=skin_pic_main>'></center>
<td class=user_news>
	<table class=info_news>
	<tr>
	<td class=title>Новички
	<tr>
	<td>
		<TMPL_LOOP NAME=new_users>
			<p>
			<a href="/users/<TMPL_VAR NAME=nu_id>.html"><TMPL_VAR NAME=nu_name></a>
			<br>
			<span class=note><TMPL_VAR NAME=nu_reg_date></span>
			</p>
		</TMPL_LOOP>
	</table>
</table>		

<table class=news>
<tr>
	<td class=title>Пси-Новости
<tr>
	<td class=info>
		<TMPL_LOOP NAME=news>
			<p>
			<b><TMPL_VAR NAME=n_post_date></b>
			от <a class=author href="/users/<TMPL_VAR NAME=n_user_id>.html"><TMPL_VAR NAME=n_user_name></a>
			<br>
			<TMPL_VAR NAME=n_msg>
			</p>
		</TMPL_LOOP>
		<div class=more>
			<a href="/news/">Архив новостей</a>
		</div>
</table>

<div class=last_creos_title>Последние <a href='/creos/'>анализы</a>:</div>
<TMPL_LOOP NAME=last_creos>
	<table class=creo_preview>
		<tr class=info>
			<td>
				<a href="/creos/<TMPL_VAR ESCAPE=URL NAME=lc_id>.html">
					<b><TMPL_VAR NAME=lc_alias></b> : <TMPL_VAR NAME=lc_title>
				</a>
			<td class=date>
				<b><TMPL_VAR NAME=lc_post_date></b>
		<tr class=info>
			<td colspan=2 class=diag>
				Диагнозов: <TMPL_VAR NAME=lc_comments_count>
		<tr class=text>
			<td colspan=2>
				<table class=creo_preview_text>
				<tr>
					<td class=avatar>
						<TMPL_IF NAME=lc_avatar>
							<center><img alt='<TMPL_VAR NAME=lc_alias>' src='/<TMPL_VAR NAME=lc_avatar>_thumb'></center>
						<TMPL_ELSE>
							&nbsp;
						</TMPL_IF>
					<td class=text>
						<TMPL_VAR ESCAPE="NONE" NAME=lc_body>
						<TMPL_IF NAME=lc_cuted>
							<br><span class=note>--> Ампутировано <--</span>
						</TMPL_IF>
				</table>
		<TMPL_IF NAME=lc_more>
			<tr class=more_creos>
				<td colspan=2>
					<TMPL_LOOP NAME=lc_more>
						<i><TMPL_VAR NAME=lc_post_date></i>
						<a href="/creos/<TMPL_VAR ESCAPE=URL NAME=lc_id>.html">
							<TMPL_VAR NAME=lc_title>
						</a>
						<i>&nbsp;(<TMPL_VAR NAME=lc_comments_count> диаг.)</i><TMPL_UNLESS NAME=__last__>,&nbsp;</TMPL_UNLESS>
					</TMPL_LOOP>
		</TMPL_IF>
	</table>
</TMPL_LOOP>
