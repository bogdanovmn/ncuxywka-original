CREATE TABLE bots_log (

	id         int unsigned      NOT NULL AUTO_INCREMENT,
	bot_id     smallint unsigned NOT NULL,
	action_id  int unsigned      NOT NULL,
	`date`     timestamp         NOT NULL DEFAULT CURRENT_TIMESTAMP,
	action     enum(
		'creo_comment',
		'gb_comment'
	) NOT NULL,

	PRIMARY KEY (id),
	
	FOREIGN KEY (bot_id) REFERENCES bots (id) ON DELETE RESTRICT

) ENGINE=InnoDB DEFAULT CHARSET=utf8
