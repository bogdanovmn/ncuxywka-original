CREATE TABLE moderation_log (

	id            int unsigned      NOT NULL AUTO_INCREMENT,
	moderator_id  smallint unsigned NOT NULL,
	object_id     smallint unsigned NOT NULL,
	event_date    timestamp         NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ip            char(15)          NOT NULL,
	event_type    enum(
		'creo_edit',
		'creo_delete',
		'to_quarantine',
		'from_quarantine',
		'to_plagiarism',
		'from_plagiarism',
		'user_ban',
		'creo_recover',
		'to_neofuturism',
		'from_neofuturism'
	) NOT NULL,

	PRIMARY KEY (id),
	
	KEY i_views_log__by_object (event_date, event_type, object_id),
	KEY i_views_log__by_type   (event_date, event_type),

	FOREIGN KEY (moderator_id) REFERENCES moderators (id) ON DELETE RESTRICT

) ENGINE=InnoDB DEFAULT CHARSET=utf8
