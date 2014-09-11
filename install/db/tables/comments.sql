CREATE TABLE comments (

	id        int unsigned      NOT NULL AUTO_INCREMENT,
	creo_id   smallint unsigned NOT NULL,
	user_id   smallint unsigned DEFAULT NULL,
	alias     varchar(255)      NOT NULL,
	post_date timestamp         NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ip        char(15)          NOT NULL,
	msg       text              NOT NULL,
	
	PRIMARY KEY (id),
	
	KEY i_comments__creo_id   (creo_id, post_date),
	KEY i_comments__user_id   (post_date, user_id, creo_id),
	KEY i_comments__user_creo (user_id, creo_id),

	FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
	FOREIGN KEY (creo_id) REFERENCES creo  (id) ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Комменты к креосам'
