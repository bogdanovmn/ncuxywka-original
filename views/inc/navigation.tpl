<table class=main_menu_block>
<tr class=title>
	<td>Основные кабинеты
<tr>
	<td>
		<table class=main_menu>
		<tr><td>
			<a href='/main/'>Приемная</a>
		<tr><td>
			<a href='/faq_room/'>Справочная</a>
			<span class=note>(FAQ)</span>
		<TMPL_UNLESS NAME=user_auth>
			<tr><td>
				<a href='/register/'>Регистратура</a>
		<TMPL_ELSE>
			<TMPL_UNLESS NAME=is_plagiarist>
				<tr><td>
					<a href='/add_creo/'>Лабораторная</a>
					<br>
					<span class=note>(Сдать анализы)</span>
			</TMPL_UNLESS>
		</TMPL_UNLESS>
		<tr><td>
			<a href='/gb/'>Палата #6</a>
			<TMPL_IF NAME=lgbc_post_date>
				<br><span class=subnote>Последнее: <TMPL_VAR NAME=lgbc_post_date> от <TMPL_VAR NAME=lgbc_alias></span>
			</TMPL_IF>
		</table>
</table>

<table class=main_menu_block>
<tr class=title>
	<td>Картотека
<tr>
	<td>
		<table class=main_menu>
			<tr><td>
			<a href='/users/'>Пациэнты</a>
			<tr><td>
			<a href='/creos/'>Анализы</a>
			<tr><td>
			<a href='/quarantine/'>Карантин</a>
			<tr><td>
			<a href='/talks/'>Диагнозы</a>
			<TMPL_IF NAME=lcm_post_date>
				<br><span class=subnote>Последнее: <TMPL_VAR NAME=lcm_post_date> от <TMPL_VAR NAME=lcm_alias></span>
			</TMPL_IF>
		</table>
</table>

<!-- Auth data -->

<table class=info>
<tr>
<TMPL_IF NAME=user_auth>
	<td class=title>Бюллетень 
	<tr>
	<td>
	<p class=hello>Хайц, <a href="/users/<TMPL_VAR NAME=user_id>.html"><span class=user_name><TMPL_VAR NAME=alias></span></a>!<br><br>
	<p class=submenu>&#149;&nbsp;<a href="/user_edit/">Настройки</a>
	<p class=submenu>&#149;
		<TMPL_IF NAME=new_messages>
			<a href='/pm/in/'><span class=new_messages>Личные сообщения</span></a>
			<br>
			<span class=subnote>Новые: <TMPL_VAR NAME=new_messages></span>
		<TMPL_ELSE>
			<a href='/pm/in/'>Личные сообщения</a>
		</TMPL_IF>
	<p class=submenu>&#149;&nbsp;<a href="/talks/from/<TMPL_VAR NAME=user_id>">Мои диагнозы</a>
	<p class=submenu>&#149;&nbsp;<a href="/talks/for/<TMPL_VAR NAME=user_id>">Диагнозы к моим анализам</a>
	<TMPL_IF NAME=lcfm_post_date>
		<br><span class=subnote><TMPL_VAR NAME=lcfm_post_date> от <TMPL_VAR NAME=lcfm_alias></span>
	</TMPL_IF>
	<p class=submenu>&#149;&nbsp;<a href="/auth/out">Выйти</a>
<TMPL_ELSE>
	<td class=title>Вход 
	<tr>
	<td>
	<form name=login method=post action='/auth/in'>
	<table class=form>
		<tr>
		<td>Имя:
		<br><input size=16 type=text name=name value=''>
		<tr>
		<td>Пароль:
		<br><input size=16 type=password name=password value=''>
		<tr>
		<td class=login_ok_button><input type=submit name=login_submit value='ok'>

	</table>
	</form>
</TMPL_IF>
</table>

<!-- Spec rooms -->
<table class=info>
<tr>
<td class=title>Другие палаты
<tr>
<td>
	<p class=spec_submenu>&#149;&nbsp;
		<a href='/wish_room/'>Книга Желаний</a>
		<TMPL_IF NAME=srlc_wish_post_date>
			<br><span class=subnote><TMPL_VAR NAME=srlc_wish_post_date> от <TMPL_VAR NAME=srlc_wish_alias></span>
		</TMPL_IF>
	</p>
	<p class=spec_submenu>&#149;&nbsp;
		<a href='/petr_room/'>Похождения Поросенка Петра</a>
		<TMPL_IF NAME=srlc_petr_post_date>
			<br><span class=subnote><TMPL_VAR NAME=srlc_petr_post_date> от <TMPL_VAR NAME=srlc_petr_alias></span>
		</TMPL_IF>
	</p>
	<p class=spec_submenu>&#149;&nbsp;
		<a href='/frenizm_room/'>Олигофренизмы</a>
		<TMPL_IF NAME=srlc_frenizm_post_date>
			<br><span class=subnote><TMPL_VAR NAME=srlc_frenizm_post_date> от <TMPL_VAR NAME=srlc_frenizm_alias></span>
		</TMPL_IF>
	</p>
	<p class=spec_submenu>&#149;&nbsp;
		<a href='/mainshit_room/'>Главсрач</a>
		<TMPL_IF NAME=srlc_mainshit_post_date>
			<br><span class=subnote><TMPL_VAR NAME=srlc_mainshit_post_date> от <TMPL_VAR NAME=srlc_mainshit_alias></span>
		</TMPL_IF>
	</p>
	<p class=spec_submenu>&#149;&nbsp;
		<a href='/proc_room/'>Процедурная</a>
		<TMPL_IF NAME=srlc_proc_post_date>
			<br><span class=subnote><TMPL_VAR NAME=srlc_proc_post_date> от <TMPL_VAR NAME=srlc_proc_alias></span>
		</TMPL_IF>
	</p>
	<p class=spec_submenu>&#149;&nbsp;
		<a href='/neofuturism/'>Неофутуризм</a>
	</p>
	<TMPL_IF NAME=god>
		<p class=spec_submenu>&#149;&nbsp;
			<a href='/maindoctor/'>Кабинет Главврача</a>
		</p>
	</TMPL_IF>
</table>

<TMPL_IF NAME=counter>
<table class=info>
<tr>
<td class=title>Статистико
<tr>
<td>
<center>
<!--LiveInternet logo-->
<a href="http://www.liveinternet.ru/click" target="_blank">
	<img src="//counter.yadro.ru/logo?14.15" title="Статистико =)" alt="" width="88" height="31"/>
</a>
</center>
<!--/LiveInternet-->
</table>


</TMPL_IF>
