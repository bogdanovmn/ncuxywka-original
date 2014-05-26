<TMPL_INCLUDE NAME="../inc/header.tpl">

<tr>
	<!-- LOGO -->
	<td class=lozung>
		<img alt='ПСИХУЮШКА.COM' height=48px src='/img/<TMPL_VAR NAME=skin_pic_lozung>'>
	<td class=logo>
		<img alt='ПСИХУЮШКА.COM' src='/img/<TMPL_VAR NAME=skin_pic_logo>'>
</tr>

<tr>
	<!-- Navigation -->
	<td class=menu>
		<TMPL_INCLUDE NAME="../inc/navigation.tpl">
	<!-- Content -->
	<td class=content> 
		<TMPL_VAR ESCAPE=NONE NAME=content>
	<!-- Info blocks -->
	<td class=info> 
		<TMPL_INCLUDE NAME="../inc/info_blocks.tpl">
</tr>

<TMPL_INCLUDE NAME="../inc/footer.tpl">
