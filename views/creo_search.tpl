<div class=search_menu>
	<form method=post action="/search/">
		<input type=text name=search_text value="<TMPL_VAR search_text>">
		<input type=submit value="Найти">
	</form>
</div>
<center>
		<h1>РЕ<span class=letter>ЗY</span>ЛЬТАТ П<span class=letter>О</span>ИСКА</h1>
</center>

<TMPL_IF creo_list>
	<table class="creo_list search_creo_list">
		<tr>

		<th class=date>Дата
		<th class=user>Пациэнт
		<th class=title>Название
	
	<TMPL_LOOP creo_list>
		<tr>
			<td class=date>
				<TMPL_VAR cl_post_date>
			<td class=user>
				<TMPL_IF cl_user_id>
					<a href='/users/<TMPL_VAR cl_user_id>.html'><TMPL_VAR cl_alias></a>
				<TMPL_ELSE>
					<TMPL_VAR cl_alias>
				</TMPL_IF>
			<td class=title>
				<TMPL_IF cl_quarantine><s></TMPL_IF>
				<a href="/creos/<TMPL_VAR ESCAPE=URL NAME='cl_id'>.html"><TMPL_VAR cl_title></a>
				<TMPL_IF cl_quarantine></s></TMPL_IF>
				<TMPL_UNLESS cl_self_vote>
					<span class=subnote>?</span>
				</TMPL_UNLESS>
	</TMPL_LOOP>
	</table>
<TMPL_ELSE>
	<center><div class=strict>Ничего не найдено</div></center>
</TMPL_IF>
