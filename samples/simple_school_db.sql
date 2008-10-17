
--
-- Create schema getna
--

-- CREATE DATABASE IF NOT EXISTS getna;
-- USE getna;
CREATE TABLE  `getna`.`classrooms` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `start` date default NULL,
  `end` date default NULL,
  `course_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE  `getna`.`classrooms_students` (
  `classroom_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  UNIQUE KEY `index_classrooms_students_on_classroom_id_and_student_id` (`classroom_id`,`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE  `getna`.`courses` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `description` text,
  `duration` float default NULL,
  `content` text,
  `instructor_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE  `getna`.`instructors` (
  `id` int(11) NOT NULL auto_increment,
  `firstname` varchar(255) default NULL,
  `lastname` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `phone` varchar(255) default NULL,
  `birth` date default NULL,
  `address` varchar(255) default NULL,
  `district` varchar(255) default NULL,
  `city` varchar(255) default NULL,
  `state` varchar(255) default NULL,
  `zip` varchar(9) default NULL,
  `resume` text,
  `linkedin` varchar(255) default NULL,
  `lattes` varchar(255) default NULL,
  `comment` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE  `getna`.`lessons` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `date` date default NULL,
  `duration` float default NULL,
  `classroom_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE  `getna`.`presences` (
  `id` int(11) NOT NULL auto_increment,
  `lesson_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE  `getna`.`schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE  `getna`.`students` (
  `id` int(11) NOT NULL auto_increment,
  `firstname` varchar(255) default NULL,
  `lastname` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `phone` varchar(255) default NULL,
  `birth` date default NULL,
  `address` varchar(255) default NULL,
  `district` varchar(255) default NULL,
  `city` varchar(255) default NULL,
  `state` varchar(255) default NULL,
  `zip` varchar(9) default NULL,
  `resume` text,
  `comment` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE  `getna`.`users` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `login` varchar(255) default NULL,
  `password` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



