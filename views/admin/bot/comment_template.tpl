<form method=post action=/doctor/bot/comment_template/>
	<table class=form>
	<tr>
		<td>Характер
		<td>
			<select name=character_id>
				<TMPL_LOOP characters>
					<option <TMPL_IF selected>selected</TMPL_IF> value='<TMPL_VAR id>'>
						<TMPL_VAR name>
					</option>
				</TMPL_LOOP>
			</select>
	<tr>
		<td>Категория
		<td><select name=category_id>
				<TMPL_LOOP categories>
					<option <TMPL_IF selected>selected</TMPL_IF> value='<TMPL_VAR id>'>
						<TMPL_VAR name>
					</option>
				</TMPL_LOOP>
			</select>
	<tr>
		<td><input type=submit name=refresh value='Обновить'>
		<td>
	<tr><td><td>
	<tr><td><td>
	<tr>
		<td><input type=submit name=add value='Добавить шаблон'>
		<td><input type=text name=template size=80>
	</table>
</form>

<h1>Шаблоны</h1>

<TMPL_IF templates>
	<table>
	<TMPL_LOOP templates>
		<tr>
			<td><TMPL_VAR bct_template>
			<td>...

	</TMPL_LOOP>
	</table>
<TMPL_ELSE>
	<center>пусто</center>
</TMPL_IF>

