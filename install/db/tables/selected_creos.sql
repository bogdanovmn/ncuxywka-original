CREATE TABLE selected_creo (

	id         int unsigned      NOT NULL AUTO_INCREMENT,
	user_id    smallint unsigned NOT NULL,
	creo_id    smallint unsigned NOT NULL,
	`date`     timestamp         NOT NULL DEFAULT CURRENT_TIMESTAMP,

	PRIMARY KEY (id),
	UNIQUE  KEY (user_id, creo_id),

	FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
	FOREIGN KEY (creo_id) REFERENCES creo  (id) ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8
