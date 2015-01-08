<h1>ИСТОРИ<span class=letter>Я</span> БОЛЕ<span class=letter>Z</span>НИ</h1>

<TMPL_IF avatar>
	<p><img src='/<TMPL_VAR avatar>_thumb'><br><br>
</TMPL_IF>

<p><b>Имя:</b><br><TMPL_VAR u_name><br><br>
<TMPL_IF u_city><p><b>Город:</b><br><TMPL_VAR u_city><br><br></TMPL_IF>
<TMPL_IF u_hates><p><b>Жалуется:</b><br><TMPL_VAR ESCAPE="NONE" NAME=u_hates><br><br></TMPL_IF>
<TMPL_IF u_loves><p><b>Отношение к лекарствам:</b><br><TMPL_VAR ESCAPE="NONE" NAME=u_loves><br><br></TMPL_IF>
<TMPL_IF u_about><p><b>О себе:</b><br><TMPL_VAR ESCAPE="NONE" NAME=u_about><br><br></TMPL_IF>

<table class=user_info>
<tr>
<td class=about>
	<p><b>Дата регистрации:</b><br><TMPL_VAR u_reg_date><br><br>
	<p><b>Дата изменения данных:</b><br><TMPL_VAR u_edit_date><br><br>
<td class=statistic>
	Пульс пациэнта
	<div id=user_activity_plot class=user_activity_plot></div>
</table>

<p><b>Диагнозы:</b><br>
<a href='/talks/from/<TMPL_VAR u_id>'>Отправленные пациэнтом (<TMPL_VAR u_from_comments_count>)</a><br>
<a href='/talks/for/<TMPL_VAR u_id>'>Полученные пациэнтом (<TMPL_VAR u_for_comments_count>)</a><br>
<br>
<p><b>Отношение к окружающим пациэнтам:</b><br>
<TMPL_VAR user_votes_out_rank_title>

<TMPL_IF user_auth>
	<br>
	<br>
	<TMPL_UNLESS can_delete>
		[ <a href="/pm/dialog/<TMPL_VAR u_id>/">Отправить этому пациэнту личное сообщение</a> ]
	</TMPL_UNLESS>
</TMPL_IF>


<TMPL_IF show_details>
	<h1>ПО<span class=letter>Д</span>РОБНЕ<span class=letter>Е</span></h1>
</TMPL_IF>


<table class=user_edit_menu>
<tr>
	<TMPL_IF creo_list>
		<td id="m_b_creos" class=selected onclick="select_block('b_creos');">Анализы
	</TMPL_IF>

	<TMPL_IF selected_creo_list> 
		<td id="m_b_favorite" onclick="select_block('b_favorite');">Избранное
	</TMPL_IF>

	<TMPL_IF creo_list>
		<td id="m_b_lexicon" onclick="select_block('b_lexicon');">Лексикон
	</TMPL_IF>
</table>

<TMPL_IF creo_list>
	<a id=creos></a>
	<div class="user_list_open" id="b_creos">
	<table class=user_creo_list>
		<tr>
		<th class=date>Дата<th class=title>Название<th class=comments>Диаг<th class=resume>Голоса
	<TMPL_LOOP creo_list>
		<tr>
			<td class=date>
				<TMPL_VAR cl_post_date>
			<td class=title>
				<TMPL_IF cl_quarantine><s></TMPL_IF>
				<a href="/creos/<TMPL_VAR ESCAPE=URL NAME=cl_id>.html"><TMPL_VAR cl_title></a>
				<TMPL_IF cl_quarantine></s></TMPL_IF>
				<TMPL_UNLESS cl_self_vote>
					<span class=subnote>?</span>
				</TMPL_UNLESS>
			<td class=comments>
				<TMPL_VAR cl_comments_count>
			<td class=resume><TMPL_VAR cl_votes_count>
	</TMPL_LOOP>
	</table>
	</div>
</TMPL_IF>

<TMPL_IF selected_creo_list>
	<div class="user_list" id="b_favorite">
	<table class=creo_list>
		<tr>
			<th class=date>Дата
			<th class=user>Пациэнт
			<th class=title>Название
			<th class=comments>Диаг
			<th class=resume>Голоса
			<TMPL_IF can_delete><th class=action>...</TMPL_IF>
	<TMPL_LOOP selected_creo_list>
		<tr>
			<td class=date>
				<TMPL_VAR scl_post_date>
			<td class=user>
				<TMPL_IF scl_user_id>
					<a href="/users/<TMPL_VAR scl_user_id>.html"><TMPL_VAR scl_alias></a>
				<TMPL_ELSE>
					<TMPL_VAR scl_alias>
				</TMPL_IF>
			<td class=title>
				<TMPL_IF scl_quarantine><s></TMPL_IF>
				<a href="/creos/<TMPL_VAR ESCAPE=URL NAME=scl_id>.html"><TMPL_VAR scl_title></a>
				<TMPL_IF scl_quarantine></s></TMPL_IF>
			<td class=comments>
				<TMPL_VAR scl_comments_count>
			<td class=resume><TMPL_VAR scl_votes_count>
			<TMPL_IF scl_can_delete>
				<td class=action><a href='/select/del/<TMPL_VAR scl_id>'>[X]</a>
			</TMPL_IF>
	</TMPL_LOOP>
	</table>
	</div>
</TMPL_IF>

<TMPL_IF words_cloud>
	<div class="user_list" id="b_lexicon">
	<TMPL_LOOP words_cloud>
			<h2><TMPL_VAR wc_title></h2>
			<p>
			<TMPL_LOOP wc_data>
				<span style='font-size: <TMPL_VAR font_size>px;'><TMPL_VAR word></span>&nbsp;&nbsp;
			</TMPL_LOOP>
			</p>
	</TMPL_LOOP>
	</div>
</TMPL_IF>

<TMPL_IF ad_votes>
	<table class=creo_votes>
	<TMPL_LOOP ad_votes>
			<tr>
			<td class=creo_title><a href="/creosa/<TMPL_VAR uv_creo_id>.html"><TMPL_VAR uv_user_name> - <TMPL_VAR uv_creo_title></a>
		<td class=gray><TMPL_VAR uv_ip>
		<td><TMPL_VAR uv_vote>
		<td class=gray><TMPL_VAR uv_date>
		<td><TMPL_VAR uv_delta>

	</TMPL_LOOP>
	</table>
</TMPL_IF>



<script language="javascript" type="text/javascript">

var plot_conf_total = {
	series: {
		lines: {
			show: true,
			lineWidth: 1
		}
	},
	colors: ["#00ff00"],
	xaxis: {
		ticks: 4,
		mode: "time",
		timeformat: "%Y"
	},
	yaxis: {
		ticks: 0
	},
	grid: {
		borderWidth: 0
	}
};

$.plot(
	$("#user_activity_plot"), 
	[{ data: <TMPL_VAR NAME=u_activity_chart_data ESCAPE="JS"> }], 
	plot_conf_total
);

function select_block(id) {
	var blocks = ['b_creos', 'b_favorite', 'b_lexicon'];
	for (var i = 0; i < blocks.length; i++) {
		var b = document.getElementById(blocks[i]);
		if (b) {
			if (blocks[i] == id) {
				b.style.display = "block";
				document.getElementById("m_" + blocks[i]).setAttribute("class", "selected");
			}
			else {
				b.style.display = "none";
				document.getElementById("m_" + blocks[i]).setAttribute("class", "");
			}
		}
	}
}
</script>
