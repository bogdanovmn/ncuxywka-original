CREATE TABLE user_stats (

	user_id             smallint unsigned NOT NULL,
	votes_in            int unsigned      NOT NULL DEFAULT '0',
	votes_out           int unsigned      NOT NULL DEFAULT '0',
	votes_in_rank       tinyint unsigned  DEFAULT NULL,
	votes_out_rank      tinyint unsigned  DEFAULT NULL,
	comments_in         int unsigned      NOT NULL DEFAULT '0',
	comments_out        int unsigned      NOT NULL DEFAULT '0',
	comments_in_by_self int unsigned      NOT NULL DEFAULT '0',
	spec_comments       int unsigned      NOT NULL DEFAULT '0',
	gb_comments         int unsigned      NOT NULL DEFAULT '0',
	creo_post           int unsigned      NOT NULL DEFAULT '0',

	PRIMARY KEY (user_id)
	
	FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8
