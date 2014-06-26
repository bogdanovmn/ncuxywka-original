<form method=post>
	Type
	<select name=type>
		<TMPL_LOOP NAME=types>
			<option <TMPL_IF NAME=selected>selected</TMPL_IF> value='<TMPL_VAR NAME=type>'>
				<TMPL_VAR NAME=type>
			</option>
		</TMPL_LOOP>
	</select>
	Category
	<select name=category>
		<TMPL_LOOP NAME=categories>
			<option <TMPL_IF NAME=selected>selected</TMPL_IF> value='<TMPL_VAR NAME=category>'>
				<TMPL_VAR NAME=category>
			</option>
		</TMPL_LOOP>
	</select>

	<input type=text name=template>
</form>

<table>
<TMPL_LOOP NAME=templates>
	<tr>
		<td><TML_VAR NAME=bct_template>
		<td>...

</TMPL_LOOP>
</table>

