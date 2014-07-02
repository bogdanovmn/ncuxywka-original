CREATE TABLE vote (
	
	id       int unsigned      NOT NULL AUTO_INCREMENT,
	user_id  smallint unsigned NOT NULL,
	creo_id  smallint unsigned NOT NULL,
	vote     tinyint           NOT NULL,
	ip       char(15)          NOT NULL,
	`date`   timestamp         NOT NULL DEFAULT CURRENT_TIMESTAMP,

	PRIMARY KEY (id),
	
	UNIQUE KEY uk_vote (user_id, creo_id),

	KEY i_vote__creo_id (creo_id),

	FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
	FOREIGN KEY (creo_id) REFERENCES creos (id) ON DELETE CASCADE


) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Голосование'
