<TMPL_IF NAME="creo_edit_menu">

<table class=info_red>
	<tr>
	<td class=title>Особые процедуры
	<tr>
	<td>
		<TMPL_IF NAME="ms_neofuturism">
			<TMPL_IF NAME="neofuturism">
				<p class=submenu>&#149;&nbsp;
					<a href='/creo_edit/from_neofuturism/<TMPL_VAR NAME="creo_id">/'>Исключить из неофутуризма</a>
				</p>
			<TMPL_ELSE>
				<p class=submenu>&#149;&nbsp;
					<a href='/creo_edit/to_neofuturism/<TMPL_VAR NAME="creo_id">/'>Это неофутуризм!</a>
				</p>
			</TMPL_IF>
		</TMPL_IF>

		<TMPL_IF NAME="ms_quarantine">
			<TMPL_IF NAME="quarantine">
				<p class=submenu>&#149;&nbsp;
					<a href='/creo_edit/from_quarantine/<TMPL_VAR NAME="creo_id">/'>Реанимация...</a>
				</p>
			<TMPL_ELSE>
				<p class=submenu>&#149;&nbsp;
					<a href='/creo_edit/to_quarantine/<TMPL_VAR NAME="creo_id">/'>В карантин!</a>
				</p>
			</TMPL_IF>
		</TMPL_IF>
		
		<TMPL_UNLESS NAME="deleted">
			<TMPL_IF NAME="ms_creo_edit">
				<p class=submenu>&#149;&nbsp;
					<a href='/creo_edit/full_edit/<TMPL_VAR NAME="creo_id">/'>Исправить анализ</a>
				</p>
			</TMPL_IF>
		</TMPL_UNLESS>

		<TMPL_UNLESS NAME="deleted">
			<TMPL_IF NAME="ms_creo_delete">
				<p class=submenu>&#149;&nbsp;
					<a href='/creo_edit/delete/<TMPL_VAR NAME="creo_id">/'>Удалить!</a>
				</p>
			</TMPL_IF>
		</TMPL_UNLESS>

		<TMPL_IF NAME="ms_plagiarism">
			<TMPL_IF NAME="plagiarist">
				<p class=submenu>&#149;&nbsp;
					<a href='/creo_edit/from_plagiarism/<TMPL_VAR NAME="creo_id">/'>Реалибитировать (не плагиат)</a>
				</p>
			<TMPL_ELSE>
				<p class=submenu>&#149;&nbsp;
					<a href='/creo_edit/to_plagiarism/<TMPL_VAR NAME="creo_id">/'>Плагиат!!</a>
				</p>
			</TMPL_IF>
		</TMPL_IF>
</table>

</TMPL_IF>
