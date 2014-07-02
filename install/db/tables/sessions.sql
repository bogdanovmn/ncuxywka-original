CREATE TABLE session (

	id           char(40)  NOT NULL,
	session_data text,
	last_active  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

	PRIMARY KEY (id),
	
	KEY i_session__last_active (last_active)

) ENGINE=InnoDB DEFAULT CHARSET=utf8
