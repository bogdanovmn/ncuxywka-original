<TMPL_IF most_commented_creo_list>

<table class=info>
	<tr>
	<td class=title>Мало диагнозов
	<tr>
	<td>
	<TMPL_LOOP most_commented_creo_list_revert>
		<p class=user_creo_list>
		<span class=note>[<TMPL_VAR mccl_cnt>] </span>
		<a href="/creos/<TMPL_VAR mccl_id>.html"><b><TMPL_VAR mccl_title></b></a>
		<br><span class=subnote><TMPL_VAR mccl_alias></span>
		</p>
	</TMPL_LOOP>
</table>

<table class=info>
	<tr>
	<td class=title>Самое обсуждаемое
	<tr>
	<td>
	<TMPL_LOOP most_commented_creo_list>
		<p class=user_creo_list>
		<span class=note>[<TMPL_VAR mccl_cnt>] </span>
		<a href="/creos/<TMPL_VAR mccl_id>.html"><b><TMPL_VAR mccl_title></b></a>
		<br><span class=subnote><TMPL_VAR mccl_alias></span>
		</p>
	</TMPL_LOOP>
</table>

</TMPL_IF>
