CREATE TABLE groups (
	id              tinyint unsigned  NOT NULL AUTO_INCREMENT,
	name            varchar(100)      NOT NULL,
	type            tinyint unsigned  NOT NULL,
	comment_phrase  varchar(255)      DEFAULT NULL,

	PRIMARY KEY (id)

) ENGINE=InnoDB DEFAULT CHARSET=utf8
