<TMPL_INCLUDE NAME="inc/header.tpl">

<tr>
	<!-- LOGO -->
	<td class=lozung>
		<img alt='ÏÑÈÕÓÞØÊÀ.COM' height=48px src='/img/<TMPL_VAR NAME=skin_pic_lozung>'>
	<td class=logo>
		<img alt='ÏÑÈÕÓÞØÊÀ.COM' src='/img/<TMPL_VAR NAME=skin_pic_logo>'>
</tr>

<tr>
	<!-- Navigation -->
	<td class=menu>
		<TMPL_INCLUDE NAME="inc/navigation.tpl">
	<!-- Content -->
	<td class=content> 
		<TMPL_VAR NAME=content>
	<!-- Info blocks -->
	<td class=info> 
		<TMPL_INCLUDE NAME="info_blocks.tpl">
</tr>

<TMPL_INCLUDE NAME="footer.tpl">
