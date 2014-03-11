<TMPL_INCLUDE NAME="top.tpl">
<!-- Content -->
<td class=content> 
	<center>
	<h1>ИСТОРИ<span class=letter>Я</span> БОЛЕ<span class=letter>Z</span>НИ</h1>
	</center>


	<TMPL_IF NAME="avatar">
		<p><img src='/<TMPL_VAR NAME="avatar">_thumb'><br><br>
	</TMPL_IF>

	<p><b>Имя:</b><br><TMPL_VAR NAME="u_name"><br><br>
	<TMPL_IF NAME="u_city"><p><b>Город:</b><br><TMPL_VAR NAME="u_city"><br><br></TMPL_IF>
	<TMPL_IF NAME="u_hates"><p><b>Жалуется:</b><br><TMPL_VAR ESCAPE="NONE" NAME="u_hates"><br><br></TMPL_IF>
	<TMPL_IF NAME="u_loves"><p><b>Отношение к лекарствам:</b><br><TMPL_VAR ESCAPE="NONE" NAME="u_loves"><br><br></TMPL_IF>
	<TMPL_IF NAME="u_about"><p><b>О себе:</b><br><TMPL_VAR ESCAPE="NONE" NAME="u_about"><br><br></TMPL_IF>
	
	<table class=user_info>
	<tr>
	<td class=about>
		<p><b>Дата регистрации:</b><br><TMPL_VAR NAME="u_reg_date"><br><br>
		<p><b>Дата изменения данных:</b><br><TMPL_VAR NAME="u_edit_date"><br><br>
	<td class=statistic>
		Пульс пациэнта
		<div id=user_activity_plot class=user_activity_plot></div>
	</table>
	
	<p><b>Диагнозы:</b><br>
	<a href='/talks/from/<TMPL_VAR NAME="u_id">'>Отправленные пациэнтом (<TMPL_VAR NAME="u_from_comments_count">)</a><br>
	<a href='/talks/for/<TMPL_VAR NAME="u_id">'>Полученные пациэнтом (<TMPL_VAR NAME="u_for_comments_count">)</a><br>
	<br>
	<p><b>Отношение к окружающим пациэнтам:</b><br>
	<TMPL_VAR NAME="user_votes_out_rank_title">
	
	<TMPL_IF NAME="user_auth">
		<br>
		<br>
		<TMPL_UNLESS NAME="can_delete">
			[ <a href="/pm/dialog/<TMPL_VAR NAME='u_id'>/">Отправить этому пациэнту личное сообщение</a> ]
		</TMPL_UNLESS>
	</TMPL_IF>


	<TMPL_IF NAME="creo_list">
	<center><h1>АНАЛИ<span class=letter>Z</span>Ы:</h1></center>
	<table class=user_creo_list>
		<tr>
		<th class=date>Дата<th class=title>Название<th class=comments>Диаг<th class=resume>Голоса
    <TMPL_LOOP NAME="creo_list">
        <tr>
            <td class=date>
                <TMPL_VAR NAME="cl_post_date">
            <td class=title>
				<TMPL_IF NAME="cl_quarantine"><s></TMPL_IF>
                <a href="/creos/<TMPL_VAR ESCAPE=URL NAME='cl_id'>.html"><TMPL_VAR NAME="cl_title"></a>
				<TMPL_IF NAME="cl_quarantine"></s></TMPL_IF>
				<TMPL_UNLESS NAME="cl_self_vote">
					<span class=subnote>?</span>
				</TMPL_UNLESS>
            <td class=comments>
				<TMPL_VAR NAME="cl_comments_count">
			<td class=resume><TMPL_VAR NAME="cl_votes_count">
    </TMPL_LOOP>
    </table>
	</TMPL_IF>

	<TMPL_IF NAME="selected_creo_list">
	<center><h1>И<span class=letter>Z</span>БРАН<span class=letter>Н</span>ОE:</h1></center>
	<table class=creo_list>
		<tr>
			<th class=date>Дата
			<th class=user>Пациэнт
			<th class=title>Название
			<th class=comments>Диаг
			<th class=resume>Голоса
			<TMPL_IF NAME="can_delete"><th class=action>...</TMPL_IF>
    <TMPL_LOOP NAME="selected_creo_list">
        <tr>
            <td class=date>
                <TMPL_VAR NAME="scl_post_date">
			<td class=user>
				<TMPL_IF NAME="scl_user_id">
					<a href="/users/<TMPL_VAR NAME='scl_user_id'>.html"><TMPL_VAR NAME="scl_alias"></a>
				<TMPL_ELSE>
					<TMPL_VAR NAME="scl_alias">
				</TMPL_IF>
            <td class=title>
				<TMPL_IF NAME="scl_quarantine"><s></TMPL_IF>
                <a href="/creos/<TMPL_VAR ESCAPE=URL NAME='scl_id'>.html"><TMPL_VAR NAME="scl_title"></a>
				<TMPL_IF NAME="scl_quarantine"></s></TMPL_IF>
            <td class=comments>
				<TMPL_VAR NAME="scl_comments_count">
			<td class=resume><TMPL_VAR NAME="scl_votes_count">
			<TMPL_IF NAME="scl_can_delete">
				<td class=action><a href='/select/del/<TMPL_VAR NAME="scl_id">'>[X]</a>
			</TMPL_IF>
    </TMPL_LOOP>
    </table>
	</TMPL_IF>
	
	<TMPL_IF NAME="ad_votes">
		<table class=creo_votes>
		<TMPL_LOOP NAME="ad_votes">
			<tr>
			<td class=creo_title><a href="/creosa/<TMPL_VAR NAME='uv_creo_id'>.html"><TMPL_VAR NAME="uv_user_name"> - <TMPL_VAR NAME="uv_creo_title"></a>
			<td class=gray><TMPL_VAR NAME="uv_ip">
			<td><TMPL_VAR NAME="uv_vote">
			<td class=gray><TMPL_VAR NAME="uv_date">
			<td><TMPL_VAR NAME="uv_delta">

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
	[{ data: <TMPL_VAR NAME="u_activity_chart_data" ESCAPE="JS"> }], 
	plot_conf_total
);

</script>
<!-- Bottom -->
<TMPL_INCLUDE NAME="bottom.tpl">
