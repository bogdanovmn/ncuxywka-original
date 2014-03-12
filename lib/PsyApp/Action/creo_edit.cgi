#!/usr/bin/perl

use strict;
use warnings;

use lib 'inc';

use Psy;
use Psy::Errors;
use Psy::Creo;
use Psy::Navigation;

use CGI;
use TEMPLATE;

my $cgi = CGI->new;
my $action = $cgi->param('action');
my $title = $cgi->param('title');
my $body = $cgi->param('body');
my $alias = $cgi->param('alias');
my $err = $cgi->param('err');
my $creo_id = $cgi->param('id');
my $type = $cgi->param('type');
#debug($cgi);
my $psy = Psy->enter;
my $creo = Psy::Creo->choose($creo_id);

error("Врачей не наипешь!") unless ($psy->auditor->can_edit_creo);

if ($action eq 'to_quarantine' and $psy->auditor->is_moderator_scope(Psy::Auditor::MODERATOR_SCOPE_QUARANTINE)) {
	$creo->update_type(type => Psy::Creo::CT_QUARANTINE);
	$psy->auditor->log(
		event_type => Psy::Auditor::EVENT_TO_QUARANTINE,
		object_id => $creo_id
	);
	goto_back();	
}
elsif ($action eq 'from_quarantine' and $psy->auditor->is_moderator_scope(Psy::Auditor::MODERATOR_SCOPE_QUARANTINE)) {
	$creo->update_type(type => Psy::Creo::CT_CREO);
	$psy->auditor->log(
		event_type => Psy::Auditor::EVENT_FROM_QUARANTINE,
		object_id => $creo_id
	);
	goto_back();
}
elsif ($action eq 'to_neofuturism' and $psy->auditor->is_moderator_scope(Psy::Auditor::MODERATOR_SCOPE_NEOFUTURISM)) {
	$creo->add_to_neofuturism;
	$psy->auditor->log(
		event_type => Psy::Auditor::EVENT_TO_NEOFUTURISM,
		object_id => $creo_id
	);
	goto_back();
}
elsif ($action eq 'from_neofuturism' and $psy->auditor->is_moderator_scope(Psy::Auditor::MODERATOR_SCOPE_NEOFUTURISM)) {
	$creo->remove_from_neofuturism;
	$psy->auditor->log(
		event_type => Psy::Auditor::EVENT_FROM_NEOFUTURISM,
		object_id => $creo_id
	);
	goto_back();
}
elsif ($action eq 'full_edit' and $psy->auditor->is_moderator_scope(Psy::Auditor::MODERATOR_SCOPE_CREO_EDIT)) {
	my $creo_data = $creo->load(
		with_comments => 0,
		for_edit => 1
	);
	pn_goto(URL_404) unless ($creo_data);

	my $tpl = TEMPLATE->new('creo_edit');
	#
	# Set template params
	#
	$tpl->params(
		%$creo_data,
		%{$psy->common_info}
	);
	$tpl->show;
}
elsif ($action eq 'edit_save' and $psy->auditor->is_moderator_scope(Psy::Auditor::MODERATOR_SCOPE_CREO_EDIT)) {
	if (!$title or !$body) {
		goto_back();
	}
	$creo->update(
		title => $title,
		body => $body
	);
	$psy->auditor->log(
		event_type => Psy::Auditor::EVENT_CREO_EDIT,
		object_id => $creo_id
	);
	pn_goto(sprintf("/creos/%d.html", $creo_id));
}
elsif ($action eq 'delete' and $psy->auditor->is_moderator_scope(Psy::Auditor::MODERATOR_SCOPE_CREO_DELETE)) {
	$creo->update_type(type => Psy::Creo::CT_DELETE);
	$psy->auditor->log(
		event_type => Psy::Auditor::EVENT_CREO_DELETE,
		object_id => $creo_id
	);
	goto_back();
}
elsif ($action eq 'to_plagiarism' and $psy->auditor->is_moderator_scope(Psy::Auditor::MODERATOR_SCOPE_PLAGIARISM)) {
	$creo->update_type(type => Psy::Creo::CT_PLAGIARISM);
	
	my $creo_info = $creo->load_headers;
	my $author = Psy::User->choose($creo_info->{c_user_id});
	$author->set_group(Psy::G_PLAGIARIST);
	
	$psy->auditor->log(
		event_type => Psy::Auditor::EVENT_TO_PLAGIARISM,
		object_id => $creo_id
	);
	goto_back();
}
else {
	error("Очередь на лоботомию в другой палате!");
}

exit;

