CREATE TABLE vote (
	
	id         int unsigned      NOT NULL AUTO_INCREMENT,
	user_id    smallint unsigned NOT NULL,
	creo_id    smallint unsigned NOT NULL,
	vote       tinyint           NOT NULL,
	ip         char(15)          NOT NULL,
	init_date  timestamp         NOT NULL DEFAULT CURRENT_TIMESTAMP,

	PRIMARY KEY (id),
	
	UNIQUE KEY uk_vote (creo_id, user_id),

	FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
	FOREIGN KEY (creo_id) REFERENCES creo  (id) ON DELETE CASCADE


) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Голосование'
