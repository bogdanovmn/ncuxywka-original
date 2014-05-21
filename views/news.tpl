<TMPL_IF NAME=god>
	<center>
	<h1>НОВОС<span class=letter>T</span>Ь</h1>
	
	<form id=news_post_form name=news_post_form method=post action=''>
		<table class=form>
			<tr>
				<td><span class=note>Новость:</span>
				<td>
				<textarea id=post_text rows=10 cols=60 name=msg></textarea>
			<tr>
				<td>&nbsp;
				<td>
				<input type=submit id=submit_add name=add value='Сообщить эту замечательную новость!'>
		</table>
		<input type=hidden id=action name=action value='add'>
	</form>
	</center>
</TMPL_IF>

<center>
	<h1>АР<span class=letter>Х</span>ИВ <span class=letter>ПСИ</span> - НОВОС<span class=letter>Т</span>ЕЙ</h1>
</center>

<table class=news_archive>
<TMPL_LOOP NAME=news>
	<tr>
	<td class=info>
		<b><TMPL_VAR NAME=n_post_date></b> 
		от <a href="/users/<TMPL_VAR NAME=n_user_id>.html"><TMPL_VAR NAME=n_user_name></a>
	<td class=menu>
		<TMPL_IF NAME=god>
			<a href="/news/hide/<TMPL_VAR NAME=n_id>">Удалить</a>
		</TMPL_IF>
	<tr>
	<td class=text colspan=2>
		<TMPL_VAR NAME=n_msg>
</TMPL_LOOP>
</table>
