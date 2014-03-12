#!/usr/bin/perl

use strict;
use warnings;

use lib 'inc';

use PSY;
use PSY::ERRORS;
use PSY::USER;
use PSY::NAVIGATION;

use CGI;
use TEMPLATE;
use Digest::MD5 qw| md5_hex |;

my $cgi = CGI->new;
my $action = $cgi->param('action') || 'read';
my $old_password = $cgi->param('old_password');
my $new_password = $cgi->param('new_password');
my $new_password_check = $cgi->param('new_password_check');
my $about = $cgi->param('about');
my $email = $cgi->param('email');
my $loves = $cgi->param('loves');
my $hates = $cgi->param('hates');
my $city = $cgi->param('city');
my $avatar = $cgi->param('avatar');
my $delete_avatar = $cgi->param('delete_avatar');

my $psy = PSY->enter;

error("Вы не заблудились, голубчик?") if $psy->is_annonimus;

my $user = PSY::USER->choose($psy->user_id);
my $user_info = $user->info;

if ($action eq 'add') {
	if ($new_password) {
		my $md5_old_pass = md5_hex($old_password);
		my $md5_new_pass = md5_hex($new_password);
		my $md5_cur_pass = $user_info->{u_pass_hash};
		
		if ($md5_old_pass ne $md5_cur_pass) {
			error("Старый пароль введен неверно!");
		}

		error("Повторный ввод пароля неверен!") if ($new_password ne $new_password_check);
	}
}

#
# Case action
#
if ($action eq 'add') {
	$user->update(
		about => $about,
		email => $email,
		loves => $loves,
		hates => $hates,
		city => $city,
		password => $new_password
	);
	#
	# Upload avatar
	#
	if ($avatar) {
		my $img_file_h = $cgi->upload('avatar');
        my $img_file_type = $avatar =~ /^.*\.(\w+)$/ ? $1 : "image";	
		my $img_file_name = PSY::USER::PATH_AVATARS."/". $psy->user_id;
        my $data;
		while (<$img_file_h>) {
			$data .= $_;
			if (length $data > (PSY::USER::AVATAR_SIZE * 1024)) {
				error("Размер изображения не должен превышать ".PSY::USER::AVATAR_SIZE."kb");
			}
		}
		open(AVATAR_FILE, ">".$img_file_name) or error("Гардероб закрыт по техническим причинам!");
		print AVATAR_FILE $data;
		close(AVATAR_FILE);
		#
		# Create thumb
		#
		img_thumb($img_file_name);

	}
	elsif ($delete_avatar) {
		unlink $user->avatar_file_name or error("Аватар не удаляется =)");
	}
	pn_goto(URL_MAIN);
}
#
# Set template params
#
my $tpl = TEMPLATE->new('user_edit');
$tpl->params(
	city => $user_info->{u_city},
	loves => $user_info->{u_loves},
	hates => $user_info->{u_hates},
	email => $user_info->{u_email},
	about => $user_info->{u_about},
	avatar => $user->avatar_file_name,
	%{$psy->common_info}
);

$tpl->show;


sub img_thumb {
	my $img_file = shift;

	use Image::Magick;
	use Image::Magick::Thumbnail;
	my $src = Image::Magick->new;
	eval {
		$src->Read($img_file);
		my ($thumb, $x, $y) = Image::Magick::Thumbnail::create($src, 134);
		$thumb->Write($img_file.'_thumb');
	};
	error("Только jpeg формат") if $@;
}
