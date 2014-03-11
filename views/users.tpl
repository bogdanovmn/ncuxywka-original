<TMPL_INCLUDE NAME="top.tpl">
<!-- Content -->
<td class=content> 
	<center>
	<h1>ПАЦИЭ<span class=letter>N</span>ТЫ</h1>
	</center>
	
	<table class=user_edit_menu>
	<tr>
		<td id="m_diag" class=selected onclick="select_block('diag');">По диагнозу
		<td id="m_date" onclick="select_block('date');">По дате поступления
		<td id="m_letter" onclick="select_block('letter');">По алфавиту
	</table>

	<div class="user_list_open" id="diag">
	
		<table class=users>
		<tr>
		<td>
		<TMPL_IF NAME="rank_1">
			<h2 class=user_rank>Легенды Психуюшки</h2>
			<TMPL_LOOP NAME="rank_1">
				<p><a href='/users/<TMPL_VAR NAME="ru_id">.html'><TMPL_VAR NAME="ru_name"></a></p>
			</TMPL_LOOP>
		</TMPL_IF>
		</table>

		<table class=users>
		<tr>
		<td>
			<TMPL_IF NAME="rank_2">
				<h2 class=user_rank>Шизофреники</h2>
				<TMPL_LOOP NAME="rank_2">
					<p><a href='/users/<TMPL_VAR NAME="ru_id">.html'><TMPL_VAR NAME="ru_name"></a></p>
				</TMPL_LOOP>
			</TMPL_IF>
			<td>
			<TMPL_IF NAME="rank_3">
				<h2 class=user_rank>Пациэнты Фрейда</h2>
				<TMPL_LOOP NAME="rank_3">
					<p><a href='/users/<TMPL_VAR NAME="ru_id">.html'><TMPL_VAR NAME="ru_name"></a></p>
				</TMPL_LOOP>
			</TMPL_IF>
			<td>
			<TMPL_IF NAME="rank_4">
				<h2 class=user_rank>Параноики</h2>
				<TMPL_LOOP NAME="rank_4">
					<p><a href='/users/<TMPL_VAR NAME="ru_id">.html'><TMPL_VAR NAME="ru_name"></a></p>
				</TMPL_LOOP>
			</TMPL_IF>
		</table>

		<table class=users>
		<tr>
		<td>
		<TMPL_IF NAME="rank_5">
			<h2 class=user_rank>Тяжелый случай (нуждаются в срочной лоботомии)</h2>
			<TMPL_LOOP NAME="rank_5">
				<TMPL_IF NAME="ru_plagiarist"><s></TMPL_IF>
				<p><a href='/users/<TMPL_VAR NAME="ru_id">.html'><TMPL_VAR NAME="ru_name"></a></p>
				<TMPL_IF NAME="ru_plagiarist"></s></TMPL_IF>
			</TMPL_LOOP>
		</TMPL_IF>
		</table>
		
		<table class=users>
		<tr>
		<td>
		<TMPL_IF NAME="rank_0">
			<h2 class=user_rank>Диагноз пока не ясен</h2>
			<TMPL_LOOP NAME="rank_0">
				<p><a href='/users/<TMPL_VAR NAME="ru_id">.html'><TMPL_VAR NAME="ru_name"></a></p>
			</TMPL_LOOP>
		</TMPL_IF>
		<td>
		<TMPL_IF NAME="rank_100">
			<h2 class=user_rank>Сидят в очереди на сдачу анализов</h2>
			<TMPL_LOOP NAME="rank_100">
				<p><a href='/users/<TMPL_VAR NAME="ru_id">.html'><TMPL_VAR NAME="ru_name"></a></p>
			</TMPL_LOOP>
		</TMPL_IF>
		</table>

	</div>

	<!-- by date -->

	<div class=user_list id="date">
		<table class=user_list_by_reg_date>
			<TMPL_LOOP NAME="users_by_reg_date">
				<tr <TMPL_IF NAME="u_group">class=group</TMPL_IF>>
					<td class=date><TMPL_IF NAME="u_show_date"><TMPL_VAR NAME="u_reg_date"></TMPL_IF>
					<td class=name>
						<TMPL_IF NAME="u_plagiarist"><s></TMPL_IF>
						<a href='/users/<TMPL_VAR NAME="u_id">.html'><TMPL_VAR NAME="u_name"></a>
						<TMPL_IF NAME="u_plagiarist"></s></TMPL_IF>
			</TMPL_LOOP>
		</table>
	</div>

	<!-- by letter -->

	<div class=user_list id="letter">
		<table class=user_list_by_letter>
			<tr>
				<TMPL_LOOP NAME="user_list_by_letter_groups">
					<td>
						<TMPL_LOOP NAME="ul_letters">
							<br>
							<span class=user_letter><TMPL_VAR NAME="ull_letter"></span>
							<br><br>
							<TMPL_LOOP NAME="ull_users">
								<TMPL_IF NAME="u_plagiarist"><s></TMPL_IF>
								<a href='/users/<TMPL_VAR NAME="u_id">.html'><TMPL_VAR NAME="u_name"></a>
								<TMPL_IF NAME="u_plagiarist"></s></TMPL_IF>
								<br>
							</TMPL_LOOP>
						</TMPL_LOOP>
				</TMPL_LOOP>
		</table>
	</div>

<script>
	function select_block(id) {
		var blocks = ['diag', 'date', 'letter'];
		for (var i = 0; i < blocks.length; i++) {
			if (blocks[i] == id) {
				document.getElementById(blocks[i]).style.display = "block";
				document.getElementById("m_" + blocks[i]).setAttribute("class", "selected");
			}
			else {
				document.getElementById(blocks[i]).style.display = "none";
				document.getElementById("m_" + blocks[i]).setAttribute("class", "");
			}
		}
	}
</script>

<!-- Bottom -->
<TMPL_INCLUDE NAME="bottom.tpl">
