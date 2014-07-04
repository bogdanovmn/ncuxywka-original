CREATE TABLE users (

	id        smallint unsigned NOT NULL AUTO_INCREMENT,
	name      varchar(50)       NOT NULL,
	email     varchar(40)       NOT NULL,
	about     text              NOT NULL,
	loves     text              NOT NULL,
	hates     text              NOT NULL,
	city      varchar(50)       NOT NULL,
	reg_date  timestamp         NOT NULL DEFAULT CURRENT_TIMESTAMP,
	edit_date timestamp         NOT NULL DEFAULT '0000-00-00 00:00:00',
	illness   text              NOT NULL,
	pass_hash varchar(32)       NOT NULL,
	type      tinyint unsigned  NOT NULL DEFAULT '0',
	ip        char(15)          NOT NULL,

	PRIMARY KEY (id),
	UNIQUE  KEY (name),
	
	KEY i_users__reg_date (reg_date)
	
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='описание пользователей'
