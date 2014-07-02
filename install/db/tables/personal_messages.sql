CREATE TABLE personal_messages (

	id            int unsigned      NOT NULL AUTO_INCREMENT,
	from_user_id  smallint unsigned NOT NULL,
	to_user_id    smallint unsigned NOT NULL,
	msg           text              NOT NULL,
	post_date     timestamp         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	new           tinyint           NOT NULL DEFAULT '1',
	
	PRIMARY KEY (id),

	KEY i_personal_messages__from_user_id (from_user_id, post_date),
	KEY i_personal_messages__to_user_id   (to_user_id, post_date)

	FOREIGN KEY (from_user_id) REFERENCES users (id) ON DELETE CASCADE,
	FOREIGN KEY (to_user_id)   REFERENCES users (id) ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8
