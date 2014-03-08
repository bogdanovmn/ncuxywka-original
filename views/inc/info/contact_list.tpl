<TMPL_IF NAME="contact_list">

<table class=info>
	<tr>
	<td class=title>Ваши диалоги с ...
	<tr>
	<td>
	<TMPL_LOOP NAME="contact_list">
		<p class=user_creo_list>
		<a href="/pm/dialog/<TMPL_VAR NAME='cl_user_id'>/"><b><TMPL_VAR NAME="cl_user_name"></b></a>
		<br><span class=subnote>Сообщений: <TMPL_VAR NAME="cl_cnt"></span>
		</p>
	</TMPL_LOOP>
	
</table>

</TMPL_IF>
