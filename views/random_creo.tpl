<center>
	<div class=header>ЛАБ<span class=letter>О</span>РОТОРИ<span class=letter>Я</span></div>
</center>

<form method=post>
	<table>
	<tr>
	<td>
		Пациэнт
		<br>
		<select name=user_id_1>
			<TMPL_LOOP users_1>
				<option value="<TMPL_VAR user_id>" <TMPL_IF selected>selected</TMPL_IF>>
					<TMPL_VAR user_name>
				</option>
			</TMPL_LOOP>
		</select>
	<td>
		Степень шизофрении
		<br>
		<select name=depth>
			<TMPL_LOOP depth>
				<option value="<TMPL_VAR value>" <TMPL_IF selected>selected</TMPL_IF>>
					<TMPL_VAR name>
				</option>
			</TMPL_LOOP>
		</select>
	<td>
		<input type=submit value='Испытать'>
	</table>
</form>

<h1>Вот что получилось</h1>

<div class=creo_body><TMPL_VAR text></div>
