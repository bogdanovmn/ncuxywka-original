use utf8;
package PsyApp::Schema::Result::BotCommentTemplate;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table("bot_comment_template");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "bot_comment_category_id",
  {
    data_type => "tinyint",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "bot_character_id",
  {
    data_type => "tinyint",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "template",
  { data_type => "varchar", is_nullable => 0, size => 250 },
  "author_id",
  {
    data_type => "smallint",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(
  "author",
  "PsyApp::Schema::Result::User",
  { id => "author_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "SET NULL",
    on_update     => "RESTRICT",
  },
);
__PACKAGE__->belongs_to(
  "bot_character",
  "PsyApp::Schema::Result::BotCharacter",
  { id => "bot_character_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);
__PACKAGE__->belongs_to(
  "bot_comment_category",
  "PsyApp::Schema::Result::BotCommentCategory",
  { id => "bot_comment_category_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-02-24 15:55:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rYeol5ie5hD54wpLsy9VvA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
