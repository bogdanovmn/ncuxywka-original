CREATE TABLE creo (

	id          smallint unsigned NOT NULL AUTO_INCREMENT,
	user_id     smallint unsigned NOT NULL,
	post_date   timestamp         NOT NULL DEFAULT CURRENT_TIMESTAMP,
	title       varchar(250)      NOT NULL,
	body        text              NOT NULL,
	edit_date   timestamp         NOT NULL DEFAULT '0000-00-00 00:00:00',
	type        tinyint           NOT NULL,
	ip          char(15)          NOT NULL,
	neofuturism tinyint           NOT NULL DEFAULT '0',
	
	PRIMARY KEY (id),
	
	KEY i_creo__user_id   (type, user_id),
	KEY i_creo__type      (type, post_date),
	KEY i_creo__post_date (post_date),
	
	FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
	
--	FULLTEXT KEY title (title,body)

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Креативы'

