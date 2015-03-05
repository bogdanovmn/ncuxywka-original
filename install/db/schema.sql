


----- ban -----

CREATE TABLE `ban` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ip` char(15) NOT NULL,
  `user_id` smallint(5) unsigned DEFAULT NULL,
  `begin` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `end` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment` varchar(255) NOT NULL,
  `type` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `i_ban_ip` (`ip`),
  KEY `i_ban_user_id` (`user_id`),
  KEY `i_ban_begin_end` (`begin`,`end`),
  CONSTRAINT `ban_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8


----- bot_character -----

CREATE TABLE `bot_character` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8


----- bot_comment_category -----

CREATE TABLE `bot_comment_category` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8


----- bot_comment_template -----

CREATE TABLE `bot_comment_template` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bot_comment_category_id` tinyint(3) unsigned NOT NULL,
  `bot_character_id` tinyint(3) unsigned NOT NULL,
  `template` varchar(250) NOT NULL,
  `author_id` smallint(5) unsigned DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `i_bct__category_character` (`bot_comment_category_id`,`bot_character_id`),
  KEY `i_bct__category` (`bot_comment_category_id`),
  KEY `i_bct__character` (`bot_character_id`),
  KEY `i_bct__author` (`author_id`),
  CONSTRAINT `bot_comment_template_ibfk_1` FOREIGN KEY (`bot_comment_category_id`) REFERENCES `bot_comment_category` (`id`),
  CONSTRAINT `bot_comment_template_ibfk_2` FOREIGN KEY (`bot_character_id`) REFERENCES `bot_character` (`id`),
  CONSTRAINT `bot_comment_template_ibfk_3` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8


----- bots -----

CREATE TABLE `bots` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` smallint(5) unsigned NOT NULL,
  `bot_character_id` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `bot_character_id` (`bot_character_id`),
  CONSTRAINT `bots_ibfk_1` FOREIGN KEY (`bot_character_id`) REFERENCES `bot_character` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8


----- bots_log -----

CREATE TABLE `bots_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bot_id` smallint(5) unsigned NOT NULL,
  `action_id` int(10) unsigned NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `action` enum('creo_comment','gb_comment') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `bot_id` (`bot_id`),
  CONSTRAINT `bots_log_ibfk_1` FOREIGN KEY (`bot_id`) REFERENCES `bots` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8


----- calendar -----

CREATE TABLE `calendar` (
  `value` datetime NOT NULL,
  PRIMARY KEY (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8


----- comments -----

CREATE TABLE `comments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `creo_id` smallint(5) unsigned NOT NULL,
  `user_id` smallint(5) unsigned DEFAULT NULL,
  `alias` varchar(255) NOT NULL,
  `post_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` char(15) NOT NULL,
  `msg` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `i_comments__creo_id` (`creo_id`,`post_date`),
  KEY `i_comments__user_id` (`post_date`,`user_id`,`creo_id`),
  KEY `i_comments__user_creo` (`user_id`,`creo_id`),
  CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`creo_id`) REFERENCES `creo` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='РљРѕРјРјРµРЅС‚С‹ Рє РєСЂРµРѕСЃР°Рј'


----- creo -----

CREATE TABLE `creo` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` smallint(5) unsigned NOT NULL,
  `post_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `title` varchar(250) NOT NULL,
  `body` text NOT NULL,
  `edit_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `type` tinyint(4) NOT NULL,
  `ip` char(15) NOT NULL,
  `neofuturism` tinyint(4) NOT NULL DEFAULT '0',
  `post_year` year(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `i_creo__user_id` (`type`,`user_id`),
  KEY `i_creo__type` (`type`,`post_date`),
  KEY `i_creo__post_date` (`post_date`),
  KEY `user_id` (`user_id`),
  KEY `i_creo__date` (`type`,`post_date`),
  KEY `i_creo__type_year` (`type`,`post_year`,`post_date`),
  CONSTRAINT `creo_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='РљСЂРµР°С‚РёРІС‹'


----- creo_history -----

CREATE TABLE `creo_history` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `creo_id` smallint(5) unsigned NOT NULL,
  `editor_id` smallint(5) unsigned DEFAULT NULL,
  `edit_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `title` varchar(250) NOT NULL,
  `body` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `i_creo_history__by_creo_id` (`creo_id`),
  KEY `editor_id` (`editor_id`),
  CONSTRAINT `creo_history_ibfk_1` FOREIGN KEY (`editor_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `creo_history_ibfk_2` FOREIGN KEY (`creo_id`) REFERENCES `creo` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8


----- creo_stats -----

CREATE TABLE `creo_stats` (
  `creo_id` smallint(5) unsigned NOT NULL,
  `votes_rank` tinyint(3) unsigned DEFAULT NULL,
  `views` int(10) unsigned NOT NULL DEFAULT '0',
  `votes` int(10) unsigned NOT NULL DEFAULT '0',
  `comments` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`creo_id`),
  KEY `i_creo_stats__votes` (`votes`),
  CONSTRAINT `creo_stats_ibfk_1` FOREIGN KEY (`creo_id`) REFERENCES `creo` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8


----- creo_text -----

CREATE TABLE `creo_text` (
  `creo_id` smallint(5) unsigned NOT NULL,
  `title` varchar(250) NOT NULL,
  `body` text NOT NULL,
  PRIMARY KEY (`creo_id`),
  FULLTEXT KEY `title` (`title`,`body`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Креативы - тексты для поиска'


----- gb -----

CREATE TABLE `gb` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` smallint(5) unsigned DEFAULT NULL,
  `post_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `msg` text NOT NULL,
  `alias` varchar(100) NOT NULL,
  `ip` char(15) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `i_gb_post_date` (`post_date`),
  KEY `i_gb__user_id` (`user_id`),
  CONSTRAINT `gb_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Р“РѕСЃС‚РµРІР°СЏ РєРЅРёРіР°'


----- group -----

CREATE TABLE `group` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `type` tinyint(3) unsigned NOT NULL,
  `comment_phrase` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8


----- logins -----

CREATE TABLE `logins` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` smallint(5) unsigned NOT NULL,
  `event_type` enum('in','out') NOT NULL,
  `event_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` char(15) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `i_logins__by_date` (`event_date`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `logins_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8


----- moderation_log -----

CREATE TABLE `moderation_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `moderator_id` smallint(5) unsigned NOT NULL,
  `object_id` smallint(5) unsigned NOT NULL,
  `event_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` char(15) NOT NULL,
  `event_type` enum('creo_edit','creo_delete','to_quarantine','from_quarantine','to_plagiarism','from_plagiarism','user_ban','creo_recover','to_neofuturism','from_neofuturism') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `i_views_log__by_object` (`event_date`,`event_type`,`object_id`),
  KEY `moderator_id` (`moderator_id`),
  CONSTRAINT `moderation_log_ibfk_1` FOREIGN KEY (`moderator_id`) REFERENCES `moderator` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8


----- moderator -----

CREATE TABLE `moderator` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` smallint(5) unsigned NOT NULL,
  `init_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `moderator_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8


----- moderator_scope -----

CREATE TABLE `moderator_scope` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `moderator_id` smallint(5) unsigned NOT NULL,
  `init_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `scope` enum('creo_edit','user_ban','quarantine','creo_delete','plagiarism','neofuturism','profiler') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `i_moderator_scope__by_moderator_id` (`moderator_id`),
  CONSTRAINT `moderator_scope_ibfk_1` FOREIGN KEY (`moderator_id`) REFERENCES `moderator` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8


----- news -----

CREATE TABLE `news` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `post_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `msg` varchar(255) NOT NULL,
  `user_id` smallint(5) unsigned DEFAULT NULL,
  `visible` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `i_news__post_date` (`post_date`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `news_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8


----- personal_messages -----

CREATE TABLE `personal_messages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `from_user_id` smallint(5) unsigned NOT NULL,
  `to_user_id` smallint(5) unsigned NOT NULL,
  `msg` text NOT NULL,
  `post_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_new` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `i_personal_messages__from_user_id` (`from_user_id`,`post_date`),
  KEY `i_personal_messages__to_user_id` (`to_user_id`,`post_date`),
  CONSTRAINT `personal_messages_ibfk_1` FOREIGN KEY (`from_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `personal_messages_ibfk_2` FOREIGN KEY (`to_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8


----- selected_creo -----

CREATE TABLE `selected_creo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` smallint(5) unsigned NOT NULL,
  `creo_id` smallint(5) unsigned NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`creo_id`),
  KEY `creo_id` (`creo_id`),
  CONSTRAINT `selected_creo_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `selected_creo_ibfk_2` FOREIGN KEY (`creo_id`) REFERENCES `creo` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8


----- session -----

CREATE TABLE `session` (
  `id` char(40) NOT NULL,
  `session_data` varchar(500) DEFAULT NULL,
  `last_active` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `i_session__last_active` (`last_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8


----- spec_comments -----

CREATE TABLE `spec_comments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` smallint(5) unsigned DEFAULT NULL,
  `alias` varchar(100) NOT NULL,
  `post_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` char(15) NOT NULL,
  `msg` text NOT NULL,
  `type` varchar(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `i_spec_comments__user_id` (`user_id`,`type`),
  KEY `i_spec_comments__type` (`type`,`post_date`),
  CONSTRAINT `spec_comments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='РљРѕРјРјРµРЅС‚С‹ Рє СЃРїРµС†СЂР°Р·РґРµР»Р°Рј'


----- user_group -----

CREATE TABLE `user_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` smallint(5) unsigned NOT NULL,
  `group_id` tinyint(3) unsigned NOT NULL,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`group_id`),
  KEY `group_id` (`group_id`),
  CONSTRAINT `user_group_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_group_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `group` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8


----- user_stats -----

CREATE TABLE `user_stats` (
  `user_id` smallint(5) unsigned NOT NULL,
  `votes_in` int(10) unsigned NOT NULL DEFAULT '0',
  `votes_out` int(10) unsigned NOT NULL DEFAULT '0',
  `votes_in_rank` tinyint(3) unsigned DEFAULT NULL,
  `votes_out_rank` tinyint(3) unsigned DEFAULT NULL,
  `comments_in` int(10) unsigned NOT NULL DEFAULT '0',
  `comments_out` int(10) unsigned NOT NULL DEFAULT '0',
  `comments_in_by_self` int(10) unsigned NOT NULL DEFAULT '0',
  `spec_comments` int(10) unsigned NOT NULL DEFAULT '0',
  `gb_comments` int(10) unsigned NOT NULL DEFAULT '0',
  `creo_post` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`),
  CONSTRAINT `user_stats_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8


----- users -----

CREATE TABLE `users` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
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
  `ip` char(15) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `i_users__reg_date` (`reg_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='РѕРїРёСЃР°РЅРёРµ РїРѕР»СЊР·РѕРІР°С‚РµР»РµР№'


----- views_log -----

CREATE TABLE `views_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` smallint(5) unsigned DEFAULT NULL,
  `object_id` smallint(5) unsigned NOT NULL,
  `object_type` enum('creo','user') NOT NULL,
  `view_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` char(15) NOT NULL,
  `user_agent` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `i_views_log__by_object` (`object_id`,`object_type`,`view_date`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `views_log_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8


----- vote -----

CREATE TABLE `vote` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` smallint(5) unsigned NOT NULL,
  `creo_id` smallint(5) unsigned NOT NULL,
  `vote` tinyint(4) NOT NULL,
  `ip` char(15) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_vote` (`creo_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `vote_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `vote_ibfk_2` FOREIGN KEY (`creo_id`) REFERENCES `creo` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Р“РѕР»РѕСЃРѕРІР°РЅРёРµ'