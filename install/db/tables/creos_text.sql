CREATE TABLE creo_text (

	creo_id     smallint unsigned NOT NULL,
	title       varchar(250)      NOT NULL,
	body        text              NOT NULL,
	
	PRIMARY KEY (creo_id),
	
	FULLTEXT KEY title (title,body)

) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Креативы - тексты для поиска'

