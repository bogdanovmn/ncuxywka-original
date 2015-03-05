use utf8;
package PsyApp::Schema::Result::UserStat;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table("user_stats");
__PACKAGE__->add_columns(
  "user_id",
  {
    data_type => "smallint",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "votes_in",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "votes_out",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "votes_in_rank",
  { data_type => "tinyint", extra => { unsigned => 1 }, is_nullable => 1 },
  "votes_out_rank",
  { data_type => "tinyint", extra => { unsigned => 1 }, is_nullable => 1 },
  "comments_in",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "comments_out",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "comments_in_by_self",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "spec_comments",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "gb_comments",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "creo_post",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
);
__PACKAGE__->set_primary_key("user_id");
__PACKAGE__->belongs_to(
  "user",
  "PsyApp::Schema::Result::User",
  { id => "user_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-02-24 15:55:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rTiLtGFOmgFmU1UKSLPetg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
