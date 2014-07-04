CREATE TABLE user_group (

	id           int unsigned      NOT NULL AUTO_INCREMENT,
	user_id      smallint unsigned NOT NULL,
	group_id     tinyint unsigned  NOT NULL,
	update_time  timestamp         NOT NULL DEFAULT CURRENT_TIMESTAMP,
	
	PRIMARY KEY (id),
	UNIQUE  KEY (user_id, group_id),
	
	FOREIGN KEY (user_id)  REFERENCES users   (id) ON DELETE CASCADE,
	FOREIGN KEY (group_id) REFERENCES `group` (id) ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8
