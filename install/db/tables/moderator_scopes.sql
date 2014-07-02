CREATE TABLE moderator_scope (

	id            smallint unsigned NOT NULL AUTO_INCREMENT,
	moderator_id  smallint unsigned NOT NULL,
	init_date     timestamp         NOT NULL DEFAULT CURRENT_TIMESTAMP,
	scope         enum(
		'creo_edit',
		'user_ban',
		'quarantine',
		'creo_delete',
		'plagiarism',
		'neofuturism',
		'profiler'
	) NOT NULL,

	PRIMARY KEY (id),

	KEY i_moderator_scope__by_moderator_id (moderator_id),
	
	FOREIGN KEY (moderator_id) REFERENCES moderators (id) ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8
