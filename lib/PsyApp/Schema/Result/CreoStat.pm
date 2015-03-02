use utf8;
package PsyApp::Schema::Result::CreoStat;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table("creo_stats");
__PACKAGE__->add_columns(
  "creo_id",
  {
    data_type => "smallint",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "votes_rank",
  { data_type => "tinyint", extra => { unsigned => 1 }, is_nullable => 1 },
  "views",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "votes",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "comments",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
);
__PACKAGE__->set_primary_key("creo_id");
__PACKAGE__->belongs_to(
  "creo",
  "PsyApp::Schema::Result::Creo",
  { id => "creo_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-02-24 15:55:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mc723pWn+rVM6d/lNFpQ8Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
