<TMPL_IF user_edit_menu>

<table class=info_red>
	<tr>
	<td class=title>Особые процедуры
	<tr>
	<td>
		<TMPL_IF ms_user_ban>
			<p class=submenu>&#149;&nbsp;
			<TMPL_IF user_ban_left_time>
				До окончания процедур осталось
				<span class=note><TMPL_VAR user_ban_left_time></span>
			<TMPL_ELSE>
				<a href="/procedure/user/<TMPL_VAR u_id>">Назначить процедуры</a>
				<br>
				<span class=note>Продолжительность: 6 часов</span>
			</TMPL_IF>
			</p>
		</TMPL_IF>
		
		<TMPL_IF god>
			<p class=submenu>&#149;&nbsp;
				<a target=_blank href="http://ip-whois.net/ip_geo.php?ip=<TMPL_VAR u_ip>">География</a>
			</p>
		</TMPL_IF>
</table>

</TMPL_IF>
