-- Getna - RubyOnRails Generator
--
-- ------------------------------------------------------
-- Simple Data Base 
---------------------------------------------------------
--
--
--This Simple Data Base for test of the GEtna
--
-- ;)

--
-- Create schema getna
--

-- na linha de comando digite:
-- > mysql -u seu_usuario -p
-- depois:
CREATE DATABASE IF NOT EXISTS getna;
--
-- depois 
USE getna;
--

-- então é só criar as tabelas

CREATE TABLE  `getna`.`group_permissions` (
  `id` int(11) NOT NULL auto_increment,
  `permission_id` int(11) default NULL,
  `group_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE  `getna`.`group_users` (
  `id` int(11) NOT NULL auto_increment,
  `group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE  `getna`.`groups` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) NOT NULL,
  `description` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE  `getna`.`permissions` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) NOT NULL,
  `resource` varchar(100) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE  `getna`.`schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `getna`.`schema_migrations` VALUES  ('20080804004129');

CREATE TABLE  `getna`.`users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(40) default NULL,
  `email` varchar(100) default NULL,
  `name` varchar(100) default NULL,
  `active` tinyint(1) default '1',
  `birthday` datetime NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

