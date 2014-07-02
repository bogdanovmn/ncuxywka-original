CREATE TABLE selected_creos (

	id       int unsigned      NOT NULL AUTO_INCREMENT,
	user_id  smallint unsigned NOT NULL,
	creo_id  smallint unsigned NOT NULL,

	PRIMARY KEY (id),

	UNIQUE KEY (user_id, creo_id)

	FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
	FOREIGN KEY (creo_id) REFERENCES creos (id) ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8
