<TMPL_INCLUDE NAME="top.tpl">

<td class=content>
	<div class=error>
	<center><p class=error_title><TMPL_VAR NAME="msg"></p></center>
	<TMPL_LOOP NAME="explains">
		<p>Caller: <b><TMPL_VAR NAME="caller"></b>
		<br>Предполагается обработать ~<b><TMPL_VAR NAME="nice_total_rows"></b> строк
		</p>
		<table class=sql_explain>
			<tr>
			<td class=short>id
			<td>select_type
			<td>table
			<td>type
			<td>possible_keys
			<td>key
			<td class=short>key len
			<td>ref
			<td  class=rows>rows
			<td>Extra
		<TMPL_LOOP NAME="details">
			<tr>
			<td><TMPL_VAR NAME="id">
			<td><TMPL_VAR NAME="select_type">
			<td><TMPL_VAR NAME="table">
			<td><TMPL_VAR NAME="type">
			<td><TMPL_VAR NAME="possible_keys">
			<td><TMPL_VAR NAME="key">
			<td><TMPL_VAR NAME="key_len">
			<td><TMPL_VAR NAME="ref">
			<td><TMPL_VAR NAME="rows">
			<td><TMPL_VAR NAME="Extra">
		</TMPL_LOOP>
		</table>
		<br>
		<br>
	</TMPL_LOOP>
	</div>

<!-- Bottom -->
<TMPL_INCLUDE NAME="bottom.tpl">
