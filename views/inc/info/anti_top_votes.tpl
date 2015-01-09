<TMPL_IF anti_top_votes>

<table class=info>
	<tr>
	<td class=title>ПРОГОЛОСУЙ!
	<tr>
	<td>
	<TMPL_LOOP anti_top_votes>
		<p class=user_creo_list>
		<a href="/creos/<TMPL_VAR vs_creo_id>.html"><b><TMPL_VAR vs_title></b></a>
		<br><span class=subnote><TMPL_VAR vs_alias></span>
		<!--span class=subnote> [Голосов: <TMPL_VAR vs_cnt>] </span-->
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
