CREATE TABLE views_log (

	id          int unsigned        NOT NULL AUTO_INCREMENT,
	user_id     smallint unsigned   DEFAULT NULL,
	object_id   smallint unsigned   NOT NULL,
	object_type enum('creo','user') NOT NULL,
	view_date   timestamp           NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ip          char(15)            NOT NULL,
	user_agent  varchar(100)        DEFAULT NULL,

	PRIMARY KEY (id),

	KEY i_views_log__by_object (object_id, object_type, view_date),
	
	FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL

) ENGINE=InnoDB DEFAULT CHARSET=utf8
