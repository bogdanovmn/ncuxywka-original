<TMPL_INCLUDE NAME="top.tpl">

<td class=content>
	<div class=error>
	<center><p class=error_title><TMPL_VAR msg></p></center>
	<TMPL_LOOP explains>
		<p>Caller: <b><TMPL_VAR caller></b>
		<br>Предполагается обработать ~<b><TMPL_VAR nice_total_rows></b> строк
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
		<TMPL_LOOP details>
			<tr>
			<td><TMPL_VAR id>
			<td><TMPL_VAR select_type>
			<td><TMPL_VAR table>
			<td><TMPL_VAR type>
			<td><TMPL_VAR possible_keys>
			<td><TMPL_VAR key>
			<td><TMPL_VAR key_len>
			<td><TMPL_VAR ref>
			<td><TMPL_VAR rows>
			<td><TMPL_VAR Extra>
		</TMPL_LOOP>
		</table>
		<br>
		<br>
	</TMPL_LOOP>
	</div>

<!-- Bottom -->
<TMPL_INCLUDE NAME="bottom.tpl">
