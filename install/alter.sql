alter table creo_stats add key i_creo_stats__creo_votes (creo_id, votes);
alter table creo add column post_year year not null;
alter table creo add key i_creo__type_year (type, post_year, post_date);

-- alter table personal_messages change new is_new tinyint not null default 1;
