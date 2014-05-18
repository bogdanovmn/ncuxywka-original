package PsyApp::Action::UserEdit::Post;

use strict;
use warnings;
use utf8;

use Psy::User;
use Digest::MD5 qw| md5_hex |;

sub main {
	my ($class, $params) = @_;

	my $old_password       = $params->{old_password};
	my $new_password       = $params->{new_password};
	my $new_password_check = $params->{new_password_check};
	my $delete_avatar      = $params->{delete_avatar};
	my $about  = $params->{about};
	my $email  = $params->{email};
	my $loves  = $params->{loves};
	my $hates  = $params->{hates};
	my $city   = $params->{city};
	my $avatar = $params->{avatar};
	my $psy    = $params->{psy};

	return $psy->error("Вы хакер?") if $psy->is_annonimus;

	my $user      = Psy::User->choose($psy->user_id);
	my $user_info = $user->info;

	if ($new_password) {
		my $md5_old_pass = md5_hex($old_password);
		my $md5_new_pass = md5_hex($new_password);
		my $md5_cur_pass = $user_info->{u_pass_hash};
		
		if ($md5_old_pass ne $md5_cur_pass) {
			return $psy->error("Старый пароль введен неверно!");
		}

		if ($new_password ne $new_password_check) {
			return $psy->error("Повторный ввод пароля неверен!");
		}
	}

	$user->update(
		about    => $about,
		email    => $email,
		loves    => $loves,
		hates    => $hates,
		city     => $city,
		password => $new_password
	);
	#
	# Upload avatar
	#
	if ($avatar) {
		my $raw_img_handle = $avatar;
		my $img_file_type  = $avatar =~ /^.*\.(\w+)$/ ? $1 : "image";	
		my $img_file_name  = Psy::User::FULL_PATH_AVATARS."/". $psy->user_id;

		binmode $raw_img_handle;
		my $data;
		while (<$raw_img_handle>) {
			$data .= $_;
			if (length $data > (Psy::User::AVATAR_SIZE * 1024)) {
				return $psy->error("Размер изображения не должен превышать ".Psy::User::AVATAR_SIZE."kb");
			}
		}
		open(AVATAR_FILE, ">".$img_file_name) or return $psy->error("Гардероб закрыт по техническим причинам!". $img_file_name. ' '. $!);
		print AVATAR_FILE $data;
		close(AVATAR_FILE);
		#
		# Create thumb
		#
		return $psy->error("Только jpeg формат") unless _img_thumb($img_file_name);

	}
	elsif ($delete_avatar) {
		unlink $user->avatar_file_name or return $psy->error("Аватар не удаляется =)");
	}
	
	return 1;
}

sub _img_thumb {
	my $img_file = shift;

	use Image::Magick;
	use Image::Magick::Thumbnail;
	my $src = Image::Magick->new;
	eval {
		$src->Read($img_file);
		my ($thumb, $x, $y) = Image::Magick::Thumbnail::create($src, 134);
		$thumb->Write($img_file.'_thumb');
	};
	return $@ ? 0 : 1;
}

1;
