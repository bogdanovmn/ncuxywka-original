CREATE TABLE creo_history (

	id         int unsigned      NOT NULL AUTO_INCREMENT,
	creo_id    smallint unsigned NOT NULL,
	editor_id  smallint unsigned DEFAULT NULL,
	edit_date  timestamp         NOT NULL DEFAULT CURRENT_TIMESTAMP,
	title      varchar(250)      NOT NULL,
	body       text              NOT NULL,

	PRIMARY KEY (id),

	KEY i_creo_history__by_creo_id (creo_id),

	FOREIGN KEY (editor_id) REFERENCES users (id) ON DELETE SET NULL,
	FOREIGN KEY (creo_id)   REFERENCES creo  (id) ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8
