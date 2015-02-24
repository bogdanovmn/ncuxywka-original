use utf8;
package PsyApp::Schema::Result::CreoText;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table("creo_text");
__PACKAGE__->add_columns(
  "creo_id",
  { data_type => "smallint", extra => { unsigned => 1 }, is_nullable => 0 },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 250 },
  "body",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("creo_id");


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-02-24 15:55:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:O/l2skDcnerhfqYP238Y2Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
