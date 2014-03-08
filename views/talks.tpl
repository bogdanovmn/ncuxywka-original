<TMPL_INCLUDE NAME="top.tpl">
<!-- Content -->
<td class=content> 
	<center><h1>������<span class=letter>Z</span>�:</h1></center>
	
	<TMPL_IF NAME="multi_page">
		<TMPL_INCLUDE NAME="pages.tpl">
	</TMPL_IF>
	<TMPL_LOOP NAME="last_comments">
		<table class='<TMPL_IF NAME="lc_major">major_</TMPL_IF><TMPL_IF NAME="lc_group_name">group_<TMPL_VAR NAME="lc_group_type">_</TMPL_IF>comment talks_comment'>
			<tr>
				<td class=who>
					<TMPL_IF NAME="lc_group_name">
						<span class=group><TMPL_VAR NAME="lc_group_name"></span>
					</TMPL_IF>
					<TMPL_IF NAME="lc_user_id">
						<a class=user href='/users/<TMPL_VAR NAME="lc_user_id">.html'><span class=user_name><TMPL_VAR NAME="lc_user_name"></span></a>
					<TMPL_ELSE>
						<span class=anonim><TMPL_VAR NAME="lc_alias"></span> 
					</TMPL_IF>
					<span class=array>&rarr;</span> <TMPL_IF NAME='lc_quarantine'><s></TMPL_IF><a href="/creos/<TMPL_VAR ESCAPE=URL NAME='lc_creo_id'>.html"><TMPL_VAR NAME="lc_creo_alias">: <TMPL_VAR NAME="lc_creo_title"><TMPL_IF NAME='lc_quarantine'></s></TMPL_IF>
					</a>
				<td class="stamp">
					<span class=post_date><TMPL_VAR	NAME="lc_post_date"></span>
			<tr>
				<td class=msg colspan=3>
					<TMPL_IF NAME="lc_comment_phrase">
						<span class=group><TMPL_VAR NAME="lc_comment_phrase"></span><br><br>
					</TMPL_IF>
					<TMPL_VAR ESCAPE="NONE" NAME="lc_msg">
					<TMPL_IF NAME="lc_cuted">
						<br><span class=note>--> ������������ <--</span>
					</TMPL_IF>
		</table>
	</TMPL_LOOP>
	
	<TMPL_IF NAME="multi_page">
		<hr>
		<TMPL_INCLUDE NAME="pages.tpl">
	</TMPL_IF>

<!-- Bottom -->
<TMPL_INCLUDE NAME="bottom.tpl">
