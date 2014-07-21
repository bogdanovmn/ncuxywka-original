CREATE TABLE creo_stats (

	creo_id     smallint unsigned NOT NULL,
	votes_rank  tinyint unsigned  DEFAULT NULL,
	views       int unsigned      NOT NULL DEFAULT '0',
	votes       int unsigned      NOT NULL DEFAULT '0',
	comments    int unsigned      NOT NULL DEFAULT '0',

	PRIMARY KEY (creo_id),
	
	KEY i_creo_stats__votes    (votes),
	KEY i_creo_stats__comments (comments),
	KEY i_creo_stats__views    (views),
	
	FOREIGN KEY (creo_id) REFERENCES creo (id) ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8
