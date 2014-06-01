<h1>К<span class=letter>А</span>БИНЕТ ГЛ<span class=letter>А</span>ВВР<span class=letter>А</span>ЧА</h1>

<!-- тут будет выводится график -->
<h1>Пульсация Психуюшки</h1>
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
		{ data: <TMPL_VAR NAME="chart_new_users" ESCAPE="JS">, yaxis: 1, label: "Пациэнты" },
		{ data: <TMPL_VAR NAME="chart_creos" ESCAPE="JS">, yaxis: 1, label: "Анализы" },
		{ data: <TMPL_VAR NAME="chart_comments" ESCAPE="JS">, yaxis: 2, label: "Диагнозы" },
		{ data: <TMPL_VAR NAME="chart_votes" ESCAPE="JS">, yaxis: 2, label: "Голоса" },
	], 
	plot_conf_total
);
</script>
