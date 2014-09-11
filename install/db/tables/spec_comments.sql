CREATE TABLE spec_comments (
	id         int unsigned      NOT NULL AUTO_INCREMENT,
	user_id    smallint unsigned DEFAULT NULL,
	alias      varchar(100)      NOT NULL,
	post_date  timestamp         NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ip         char(15)          NOT NULL,
	msg        text              NOT NULL,
	type       varchar(10)       NOT NULL,
	
	PRIMARY KEY (id),
	
	KEY i_spec_comments__user_id (user_id, type),
	KEY i_spec_comments__type    (type, post_date),

	FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Комменты к спецразделам'
