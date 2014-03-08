<TMPL_IF NAME="user_favorites">

<table class=info>
	<tr>
	<td class=title>Пациэнты под надзором
	<tr>
	<td>
	<TMPL_LOOP NAME="user_favorites">
		<p class=user_creo_list>
		<span class=subnote>[<a href="/talks/for/<TMPL_VAR NAME='uf_uid'>/from/<TMPL_VAR NAME='uf_master_id'>"><TMPL_VAR NAME="uf_cnt"> диаг.</a>]</span>
		<a href="/users/<TMPL_VAR NAME='uf_uid'>.html"><b><TMPL_VAR NAME="uf_name"></b></a>
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
