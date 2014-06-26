


----- ban -----

CREATE TABLE `ban` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ip` varchar(15) NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `begin` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `end` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment` varchar(255) NOT NULL,
  `type` smallint(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `i_ban_ip` (`ip`),
  KEY `i_ban_user_id` (`user_id`),
  KEY `i_ban_begin_end` (`begin`,`end`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8


----- bot_comment_template -----

CREATE TABLE `bot_comment_template` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` tinyint(3) unsigned NOT NULL,
  `character_id` tinyint(3) unsigned NOT NULL,
  `template` varchar(250) NOT NULL,
  `author_id` int(10) unsigned NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `i_bct__category_character` (`category_id`,`character_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8


----- bots -----

CREATE TABLE `bots` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `type` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8


----- bots_log -----

CREATE TABLE `bots_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bot_id` int(10) unsigned NOT NULL,
  `action` enum('creo_comment','gb_comment') NOT NULL DEFAULT 'creo_comment',
  `action_id` int(10) unsigned NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8


----- calendar -----

CREATE TABLE `calendar` (
  `value` datetime NOT NULL,
  PRIMARY KEY (`value`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8


----- comments -----

CREATE TABLE `comments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `creo_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `alias` varchar(255) NOT NULL,
  `post_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` varchar(15) NOT NULL,
  `msg` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `i_comments__creo_id` (`creo_id`,`post_date`),
  KEY `i_comments__post_date` (`post_date`),
  KEY `i_comments__user_id` (`post_date`,`user_id`,`creo_id`),
  KEY `i_comments__user-creo` (`user_id`,`creo_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Комменты к креосам'


----- creo -----

CREATE TABLE `creo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL DEFAULT '0',
  `post_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `title` varchar(250) NOT NULL,
  `body` text NOT NULL,
  `edit_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `alias` varchar(50) NOT NULL,
  `type` tinyint(4) NOT NULL,
  `ip` varchar(15) NOT NULL,
  `neofuturism` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_creo__id-type` (`id`,`type`),
  KEY `i_creo__user_id` (`type`,`user_id`),
  KEY `i_creo__type` (`type`,`post_date`),
  KEY `i_creo__post_date` (`post_date`),
  FULLTEXT KEY `title` (`title`,`body`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Креативы'


----- creo_history -----

CREATE TABLE `creo_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `creo_id` int(10) unsigned NOT NULL,
  `editor_id` int(10) unsigned NOT NULL DEFAULT '0',
  `edit_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `title` varchar(250) NOT NULL,
  `body` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `i_creo_history__by_creo_id` (`creo_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8


----- creo_stats -----

CREATE TABLE `creo_stats` (
  `creo_id` int(11) NOT NULL,
  `votes_rank` int(1) DEFAULT NULL,
  `views` int(10) NOT NULL DEFAULT '0',
  `votes` int(10) NOT NULL DEFAULT '0',
  `comments` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`creo_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8


----- gb -----

CREATE TABLE `gb` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL DEFAULT '0',
  `post_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `msg` text NOT NULL,
  `alias` varchar(255) NOT NULL,
  `ip` varchar(15) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `i_gb_post_date` (`post_date`),
  KEY `i_gb__user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Гостевая книга'


----- group -----

CREATE TABLE `group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `type` tinyint(3) unsigned NOT NULL,
  `comment_phrase` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8


----- logins -----

CREATE TABLE `logins` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `event_type` enum('in','out') NOT NULL,
  `event_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` varchar(15) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `i_logins__by_date` (`event_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8


----- moderation_log -----

CREATE TABLE `moderation_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `moderator_id` int(10) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `event_type` enum('creo_edit','creo_delete','to_quarantine','from_quarantine','to_plagiarism','from_plagiarism','user_ban','creo_recover','to_neofuturism','from_neofuturism') NOT NULL,
  `event_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` varchar(15) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `i_views_log__by_object` (`event_date`,`event_type`,`object_id`),
  KEY `i_views_log__by_type` (`event_date`,`event_type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8


----- moderator -----

CREATE TABLE `moderator` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `init_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8


----- moderator_scope -----

CREATE TABLE `moderator_scope` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `moderator_id` int(10) unsigned NOT NULL,
  `scope` enum('creo_edit','user_ban','quarantine','creo_delete','plagiarism','neofuturism','profiler') NOT NULL,
  `init_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `i_moderator_scope__by_moderator_id` (`moderator_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8


----- news -----

CREATE TABLE `news` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `post_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `msg` varchar(255) NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `i_news__post_date` (`post_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8


----- personal_messages -----

CREATE TABLE `personal_messages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `from_user_id` int(10) unsigned NOT NULL,
  `to_user_id` int(10) unsigned NOT NULL,
  `msg` text NOT NULL,
  `post_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `new` tinyint(1) NOT NULL DEFAULT '1',
  UNIQUE KEY `id` (`id`),
  KEY `i_personal_messages_post_date` (`post_date`),
  KEY `i_personal_messages_from_user_id` (`from_user_id`),
  KEY `i_personal_messages_to_user_id` (`to_user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8


----- selected_creo -----

CREATE TABLE `selected_creo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `creo_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`creo_id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8


----- session -----

CREATE TABLE `session` (
  `id` char(40) NOT NULL,
  `session_data` text,
  `last_active` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8


----- spec_comments -----

CREATE TABLE `spec_comments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `alias` varchar(255) NOT NULL,
  `post_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` varchar(15) NOT NULL,
  `msg` text NOT NULL,
  `type` varchar(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `i_spec_comments__user_id` (`user_id`,`type`),
  KEY `i_spec_comments__type` (`type`,`post_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Комменты к спецразделам'


----- user_group -----

CREATE TABLE `user_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `group_id` int(10) unsigned NOT NULL,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `i_user_group__user_id` (`user_id`,`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8


----- user_stats -----

CREATE TABLE `user_stats` (
  `user_id` int(11) NOT NULL,
  `votes_in` int(10) unsigned NOT NULL DEFAULT '0',
  `votes_out` int(10) unsigned NOT NULL DEFAULT '0',
  `votes_in_rank` int(3) DEFAULT NULL,
  `votes_out_rank` int(3) DEFAULT NULL,
  `comments_in` int(10) unsigned NOT NULL DEFAULT '0',
  `comments_out` int(10) unsigned NOT NULL DEFAULT '0',
  `comments_in_by_self` int(10) unsigned NOT NULL DEFAULT '0',
  `spec_comments` int(10) unsigned NOT NULL DEFAULT '0',
  `gb_comments` int(10) unsigned NOT NULL DEFAULT '0',
  `creo_post` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8


----- users -----

CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `email` varchar(40) NOT NULL,
  `about` text NOT NULL,
  `loves` text NOT NULL,
  `hates` text NOT NULL,
  `city` varchar(50) NOT NULL,
  `reg_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `edit_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `illness` text NOT NULL,
  `pass_hash` varchar(32) NOT NULL,
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `ip` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_users__name` (`name`),
  KEY `i_users__reg_date` (`reg_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='описание пользователей'


----- views_log -----

CREATE TABLE `views_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `object_type` enum('creo','user') NOT NULL,
  `view_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` varchar(15) NOT NULL,
  `user_agent` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `i_views_log__by_object` (`object_id`,`object_type`,`view_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8


----- vote -----

CREATE TABLE `vote` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `creo_id` int(11) NOT NULL,
  `vote` tinyint(4) NOT NULL,
  `ip` varchar(15) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_vote` (`user_id`,`creo_id`),
  KEY `i_vote__creo_id` (`creo_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Голосование'