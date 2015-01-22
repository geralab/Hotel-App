CREATE TABLE `green_hotels` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(32) NOT NULL,
  `address` varchar(32) default NULL,
  `city` varchar(32) default NULL,
  `state` varchar(32) default NULL,
  `zip` varchar(32) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `green_storages` (
  `id` int(11) NOT NULL auto_increment,
  `hotel_id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  `floor` varchar(32) default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_storage_hotel_id_idx` (`hotel_id`),
  CONSTRAINT `fk_storage_hotel_id` FOREIGN KEY (`hotel_id`) REFERENCES `green_hotels` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

CREATE TABLE `green_item_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(32) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

CREATE TABLE `green_items` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(32) NOT NULL,
  `type_id` int(11) NOT NULL,
  `description` text,
  PRIMARY KEY  (`id`),
  KEY `fk_items_type_id_idx` (`type_id`),
  CONSTRAINT `fk_items_type_id` FOREIGN KEY (`type_id`) REFERENCES `green_item_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

CREATE TABLE `green_stocks` (
  `id` int(11) NOT NULL auto_increment,
  `storage_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `total_amount` int(11) NOT NULL default '0',
  `in_stock` int(11) NOT NULL default '0',
  `in_room` int(11) NOT NULL default '0',
  `in_process` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `uniq_gstocks_item_storage` (`item_id`,`storage_id`),
  KEY `idx_gstocks_item_id` (`item_id`),
  KEY `fk_gstocks_storage_id` (`storage_id`),
  CONSTRAINT `fk_gstocks_item_id` FOREIGN KEY (`item_id`) REFERENCES `green_items` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_gstocks_storage_id` FOREIGN KEY (`storage_id`) REFERENCES `green_storages` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;


CREATE TABLE `green_users` (
  `id` int(11) NOT NULL auto_increment,
  `hotel_id` int(11) default NULL,
  `username` varchar(32) character set latin1 NOT NULL,
  `password` varchar(256) character set latin1 NOT NULL,
  `email` varchar(128) character set latin1 NOT NULL,
  `first_name` varchar(32) default NULL,
  `last_name` varchar(32) default NULL,
  `license_id` varchar(32) character set latin1 NOT NULL,
  `security_token` varchar(32) character set latin1 default NULL,
  `role` varchar(16) character set latin1 NOT NULL,
  `created_date` datetime NOT NULL,
  `modified_date` datetime default NULL,
  `modified_by` int(11) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  KEY `fk_gusers_modified_by_idx` (`modified_by`),
  KEY `fk_gusers_hotel_id_idx` (`hotel_id`),
  CONSTRAINT `fk_gusers_hotel_id` FOREIGN KEY (`hotel_id`) REFERENCES `green_hotels` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_gusers_modified_by` FOREIGN KEY (`modified_by`) REFERENCES `green_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
