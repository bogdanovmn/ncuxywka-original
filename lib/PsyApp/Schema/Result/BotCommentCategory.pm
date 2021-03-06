use utf8;
package PsyApp::Schema::Result::BotCommentCategory;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table("bot_comment_category");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "tinyint",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 20 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "bot_comment_templates",
  "PsyApp::Schema::Result::BotCommentTemplate",
  { "foreign.bot_comment_category_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-02-24 15:55:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pqgzM87xzsipbsxExtnULw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
