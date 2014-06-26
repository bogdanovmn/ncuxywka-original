CREATE TABLE bot_character (

	id    tinyint unsigned NOT NULL AUTO_INCREMENT,
	name  varchar(20)      NOT NULL,

	PRIMARY KEY (id)

) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO bot_character (id, name) VALUES (1, 'Доброжелательный'), (2, 'Злой'), (3, 'Нейтральный');
