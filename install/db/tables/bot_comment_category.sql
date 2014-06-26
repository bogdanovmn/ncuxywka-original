CREATE TABLE bot_comment_category (

	id    tinyint unsigned NOT NULL AUTO_INCREMENT,
	name  varchar(20)      NOT NULL,

	PRIMARY KEY (id)

) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO bot_comment_category (id, name) VALUES (1, 'Понравилось'), (2, 'Не понравилось'), (3, 'Нейтрально');
