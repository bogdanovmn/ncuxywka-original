<TMPL_IF user_favorites>

<table class=info>
	<tr>
	<td class=title>Пациэнты под надзором
	<tr>
	<td>
	<TMPL_LOOP user_favorites>
		<p class=user_creo_list>
		<span class=subnote>[<a href="/talks/for/<TMPL_VAR uf_uid>/from/<TMPL_VAR uf_master_id>"><TMPL_VAR uf_cnt> диаг.</a>]</span>
		<a href="/users/<TMPL_VAR uf_uid>.html"><b><TMPL_VAR uf_name></b></a>
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
