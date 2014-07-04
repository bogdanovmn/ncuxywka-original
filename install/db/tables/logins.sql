CREATE TABLE logins (
	id          int unsigned      NOT NULL AUTO_INCREMENT,
	user_id     smallint unsigned NOT NULL,
	event_type  enum('in','out')  NOT NULL,
	event_date  timestamp         NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ip          char(15)          NOT NULL,

	PRIMARY KEY (id),
	
	KEY i_logins__by_date (event_date),
	
	FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8
