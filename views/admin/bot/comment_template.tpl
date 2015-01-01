<form method=post>
	<table class=form>
	<tr>
		<td>Характер
		<td>
			<select name=character_id>
				<TMPL_LOOP NAME=characters>
					<option <TMPL_IF NAME=selected>selected</TMPL_IF> value='<TMPL_VAR NAME=id>'>
						<TMPL_VAR NAME=name>
					</option>
				</TMPL_LOOP>
			</select>
	<tr>
		<td>Категория
		<td><select name=category_id>
				<TMPL_LOOP NAME=categories>
					<option <TMPL_IF NAME=selected>selected</TMPL_IF> value='<TMPL_VAR NAME=id>'>
						<TMPL_VAR NAME=name>
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

<TMPL_IF NAME=templates>
	<table>
	<TMPL_LOOP NAME=templates>
		<tr>
			<td><TMPL_VAR NAME=bct_template>
			<td>...

	</TMPL_LOOP>
	</table>
<TMPL_ELSE>
	<center>пусто</center>
</TMPL_IF>

