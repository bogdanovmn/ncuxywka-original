use utf8;
package PsyApp::Schema::Result::Creo;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table("creo");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "smallint",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "user_id",
  {
    data_type => "smallint",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "post_date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 250 },
  "body",
  { data_type => "text", is_nullable => 0 },
  "edit_date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "type",
  { data_type => "tinyint", is_nullable => 0 },
  "ip",
  { data_type => "char", is_nullable => 0, size => 15 },
  "neofuturism",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "comments",
  "PsyApp::Schema::Result::Comment",
  { "foreign.creo_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "creo_histories",
  "PsyApp::Schema::Result::CreoHistory",
  { "foreign.creo_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->might_have(
  "creo_stat",
  "PsyApp::Schema::Result::CreoStat",
  { "foreign.creo_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "selected_creos",
  "PsyApp::Schema::Result::SelectedCreo",
  { "foreign.creo_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "user",
  "PsyApp::Schema::Result::User",
  { id => "user_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);
__PACKAGE__->has_many(
  "votes",
  "PsyApp::Schema::Result::Vote",
  { "foreign.creo_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-02-24 15:55:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hpvAdeqQUymEas0HNXhDSQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
