CREATE TABLE bot_comment_template (

	id                       int unsigned     NOT NULL AUTO_INCREMENT,
	bot_comment_category_id  tinyint unsigned NOT NULL,
	bot_character_id         tinyint unsigned NOT NULL,
	template                 varchar(250)     NOT NULL,
	author_id                int unsigned     NOT NULL,
	`date`                   timestamp        NOT NULL DEFAULT CURRENT_TIMESTAMP,

	PRIMARY KEY (id),

	KEY i_bct__category_character (bot_comment_category_id, bot_character_id),
	KEY i_bct__category           (bot_comment_category_id),
	KEY i_bct__character          (bot_character_id),
	KEY i_bct__author             (author_id),

	CONSTRAINT FOREIGN KEY (bot_comment_category_id) REFERENCES bot_comment_category  (id) ON DELETE RESTRICT,
	CONSTRAINT FOREIGN KEY (bot_character_id)        REFERENCES bot_character         (id) ON DELETE RESTRICT
	-- CONSTRAINT FOREIGN KEY (author_id)               REFERENCES users                 (id) ON DELETE RESTRICT

) ENGINE=InnoDB DEFAULT CHARSET=utf8

