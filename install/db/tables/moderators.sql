CREATE TABLE moderator (

	id         smallint unsigned NOT NULL AUTO_INCREMENT,
	user_id    smallint unsigned NOT NULL,
	init_date  timestamp         NOT NULL DEFAULT CURRENT_TIMESTAMP,

	PRIMARY KEY (id),
	
	FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE RESTRICT

) ENGINE=InnoDB DEFAULT CHARSET=utf8
