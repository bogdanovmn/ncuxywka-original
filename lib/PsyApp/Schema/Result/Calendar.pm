use utf8;
package PsyApp::Schema::Result::Calendar;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table("calendar");
__PACKAGE__->add_columns(
  "value",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
);
__PACKAGE__->set_primary_key("value");


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-02-24 15:55:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:L3T63+q4puBORYfSRINVqQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
