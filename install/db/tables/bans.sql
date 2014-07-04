CREATE TABLE ban (
	
	id        int unsigned         NOT NULL AUTO_INCREMENT,
	ip        char(15)             NOT NULL,
	user_id   smallint unsigned    DEFAULT NULL,
	begin     timestamp            NOT NULL DEFAULT CURRENT_TIMESTAMP,
	end       timestamp            NOT NULL DEFAULT '0000-00-00 00:00:00',
	`comment` varchar(255)         NOT NULL,
	type      tinyint              NOT NULL,
	
	PRIMARY KEY (id),
	
	KEY i_ban_ip        (ip),
	KEY i_ban_user_id   (user_id),
	KEY i_ban_begin_end (begin,end),

	FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8
