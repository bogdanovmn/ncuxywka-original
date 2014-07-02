CREATE TABLE news (

	id         int unsigned      NOT NULL AUTO_INCREMENT,
	post_date  timestamp         NOT NULL DEFAULT CURRENT_TIMESTAMP,
	msg        varchar(255)      NOT NULL,
	user_id    smallint unsigned DEFAULT NULL,
	visible    tinyint           NOT NULL DEFAULT '1',

	PRIMARY KEY (id),

	KEY i_news__post_date (post_date),
	
	FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL

) ENGINE=InnoDB DEFAULT CHARSET=utf8
