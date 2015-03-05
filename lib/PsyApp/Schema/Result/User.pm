use utf8;
package PsyApp::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table("users");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "smallint",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "email",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "about",
  { data_type => "text", is_nullable => 0 },
  "loves",
  { data_type => "text", is_nullable => 0 },
  "hates",
  { data_type => "text", is_nullable => 0 },
  "city",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "reg_date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "edit_date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "illness",
  { data_type => "text", is_nullable => 0 },
  "pass_hash",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "type",
  {
    data_type => "tinyint",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "ip",
  { data_type => "char", is_nullable => 0, size => 15 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("name", ["name"]);
__PACKAGE__->has_many(
  "bans",
  "PsyApp::Schema::Result::Ban",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "bot_comment_templates",
  "PsyApp::Schema::Result::BotCommentTemplate",
  { "foreign.author_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "comments",
  "PsyApp::Schema::Result::Comment",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "creo_histories",
  "PsyApp::Schema::Result::CreoHistory",
  { "foreign.editor_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "creos",
  "PsyApp::Schema::Result::Creo",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "gbs",
  "PsyApp::Schema::Result::Gb",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "logins",
  "PsyApp::Schema::Result::Login",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "moderators",
  "PsyApp::Schema::Result::Moderator",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "news",
  "PsyApp::Schema::Result::News",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "personal_messages_from_user",
  "PsyApp::Schema::Result::PersonalMessage",
  { "foreign.from_user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "personal_messages_to_users",
  "PsyApp::Schema::Result::PersonalMessage",
  { "foreign.to_user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "selected_creos",
  "PsyApp::Schema::Result::SelectedCreo",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "spec_comments",
  "PsyApp::Schema::Result::SpecComment",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "user_groups",
  "PsyApp::Schema::Result::UserGroup",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->might_have(
  "user_stat",
  "PsyApp::Schema::Result::UserStat",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "views_logs",
  "PsyApp::Schema::Result::ViewsLog",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "votes",
  "PsyApp::Schema::Result::Vote",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-02-24 15:55:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:27cM/cJFGhqXUwX/5rco9A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
