<TMPL_INCLUDE NAME="top.tpl">

<!-- ���������� Flot -->


<!-- Content -->
<td class=content> 
	<center><h1>�<span class=letter>�</span>����� ��<span class=letter>�</span>���<span class=letter>�</span>��</h1></center>

<!-- ��� ����� ��������� ������ -->
<h1>��������� ���������</h1>
<div id="plot_total" class=maindocotor_plot></div>

<script language="javascript" type="text/javascript">

var plot_conf_total = {
	series: {
		lines: {
			show: true,
			lineWidth: 1
		}
	},
	xaxis: {
		ticks: 6,
		mode: "time",
		timeformat: "%Y-%m"
	},
	yaxes: [
		{ },
		{ position: "right" }
	],
	legend: {
		position: "ne"
	}
};

$.plot(
	$("#plot_total"), 
	[
		{ data: <TMPL_VAR NAME="chart_new_users" ESCAPE="JS">, yaxis: 1, label: "��������" },
		{ data: <TMPL_VAR NAME="chart_creos" ESCAPE="JS">, yaxis: 1, label: "�������" },
		{ data: <TMPL_VAR NAME="chart_comments" ESCAPE="JS">, yaxis: 2, label: "��������" },
		{ data: <TMPL_VAR NAME="chart_votes" ESCAPE="JS">, yaxis: 2, label: "������" },
	], 
	plot_conf_total
);
</script>

<!-- Bottom -->
<TMPL_INCLUDE NAME="bottom.tpl">
