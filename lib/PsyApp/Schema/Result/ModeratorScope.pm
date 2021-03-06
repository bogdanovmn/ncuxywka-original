use utf8;
package PsyApp::Schema::Result::ModeratorScope;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table("moderator_scope");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "smallint",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "moderator_id",
  {
    data_type => "smallint",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "init_date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "scope",
  {
    data_type => "enum",
    extra => {
      list => [
        "creo_edit",
        "user_ban",
        "quarantine",
        "creo_delete",
        "plagiarism",
        "neofuturism",
        "profiler",
      ],
    },
    is_nullable => 0,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(
  "moderator",
  "PsyApp::Schema::Result::Moderator",
  { id => "moderator_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-02-24 15:55:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TIOhApXrd6dofNQXWbDD+w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
