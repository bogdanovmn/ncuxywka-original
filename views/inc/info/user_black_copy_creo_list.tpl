<TMPL_IF NAME="user_black_copy_creo_list">

<table class=info>
	<tr>
	<td class=title>Черновик
	<tr>
	<td>
	<TMPL_LOOP NAME="user_black_copy_creo_list">
		<p class=user_creo_list>
			<a href="/black_copy/preview/<TMPL_VAR NAME='bccl_id'>.html">
				<TMPL_VAR NAME="bccl_title">
			</a>
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
