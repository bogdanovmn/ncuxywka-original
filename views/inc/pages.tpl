
<table class=pages <TMPL_IF NAME="width">style='width:<TMPL_VAR NAME="width">px'</TMPL_IF>>
<tr>
<TMPL_IF NAME="no_empty">
<td class=pages_navigation><span class=note>Страницы:&nbsp;&nbsp;</span>
<TMPL_IF NAME="prev_page">
	<a href='<TMPL_VAR NAME="uri">page<TMPL_VAR NAME="prev_page">.html'>< сюда</a> |
</TMPL_IF>

<TMPL_IF NAME="many">

	<TMPL_IF NAME="first">
		<a href='<TMPL_VAR NAME="uri">page1.html'>1</a>
		<a href='<TMPL_VAR NAME="uri">page<TMPL_VAR NAME="left_jump">.html'>...</a>
	</TMPL_IF>

	<TMPL_LOOP NAME="left">
		<a href='<TMPL_VAR NAME="p_uri">page<TMPL_VAR NAME="page">.html'><TMPL_VAR NAME="page"></a>
	</TMPL_LOOP>

	<b><TMPL_VAR NAME="current_page"></b>

	<TMPL_LOOP NAME="right">
		<a href='<TMPL_VAR NAME="p_uri">page<TMPL_VAR NAME="page">.html'><TMPL_VAR NAME="page"></a>
	</TMPL_LOOP>

	<TMPL_IF NAME="last">
		<a href='<TMPL_VAR NAME="uri">page<TMPL_VAR NAME="right_jump">.html'>...</a>
		<a href='<TMPL_VAR NAME="uri">page<TMPL_VAR NAME="last">.html'><TMPL_VAR NAME="last"></a>
	</TMPL_IF>

<TMPL_ELSE>

	<TMPL_LOOP NAME="left">
		<a href='<TMPL_VAR NAME="p_uri">page<TMPL_VAR NAME="page">.html'><TMPL_VAR NAME="page"></a>
	</TMPL_LOOP>

	<b><TMPL_VAR NAME="current_page"></b>

	<TMPL_LOOP NAME="right">
		<a href='<TMPL_VAR NAME="p_uri">page<TMPL_VAR NAME="page">.html'><TMPL_VAR NAME="page"></a>
	</TMPL_LOOP>

</TMPL_IF>

<TMPL_IF NAME="next_page">
	| <a href='<TMPL_VAR NAME="uri">page<TMPL_VAR NAME="next_page">.html'>туда ></a>
</TMPL_IF>

<TMPL_ELSE>
	<td class=pages_empty>&nbsp;
</TMPL_IF>

<TMPL_IF NAME="show_pages_count">
	<td class=pages_rows_count>Записей: <TMPL_VAR NAME="rows_count">
</TMPL_IF>

</table>
