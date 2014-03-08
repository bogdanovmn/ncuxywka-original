<TMPL_IF NAME="anti_top_votes">

<table class=info>
	<tr>
	<td class=title>опнцнкняси!
	<tr>
	<td>
	<TMPL_LOOP NAME="anti_top_votes">
		<p class=user_creo_list>
		<a href="/creos/<TMPL_VAR NAME='vs_creo_id'>.html"><b><TMPL_VAR NAME="vs_title"></b></a>
		<br><span class=subnote><TMPL_VAR NAME="vs_alias"></span>
		<!--span class=subnote> [цНКНЯНБ: <TMPL_VAR NAME="vs_cnt">] </span-->
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
