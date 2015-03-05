use utf8;
package PsyApp::Schema::Result::News;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table("news");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "post_date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "msg",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "user_id",
  {
    data_type => "smallint",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "visible",
  { data_type => "tinyint", default_value => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(
  "user",
  "PsyApp::Schema::Result::User",
  { id => "user_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "SET NULL",
    on_update     => "RESTRICT",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-02-24 15:55:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:stygxPpIpTIVwXCSYKnv3w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
