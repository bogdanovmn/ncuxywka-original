CREATE TABLE gb (
	id         int unsigned      NOT NULL AUTO_INCREMENT,
	user_id    smallint unsigned DEFAULT NULL,
	post_date  timestamp         NOT NULL DEFAULT CURRENT_TIMESTAMP,
	msg        text              NOT NULL,
	alias      varchar(100)      NOT NULL,
	ip         char(15)          NOT NULL,
	
	PRIMARY KEY (id),
	
	KEY i_gb_post_date (post_date),
	KEY i_gb__user_id (user_id),

	FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Гостевая книга'
