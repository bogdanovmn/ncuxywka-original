CREATE TABLE bots (

	id                smallint unsigned NOT NULL AUTO_INCREMENT,
	user_id           smallint unsigned NOT NULL,
	bot_character_id  tinyint unsigned  NOT NULL,

	PRIMARY KEY (id),

	FOREIGN KEY (bot_character_id) REFERENCES bot_character (id) ON DELETE RESTRICT

) ENGINE=InnoDB DEFAULT CHARSET=utf8
