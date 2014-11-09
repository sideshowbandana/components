CREATE TABLE `component_event` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `component` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `component_version` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `recorded_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `received_timestamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `type` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `data` blob,
  PRIMARY KEY (`id`),
  KEY `component` (`component`,`component_version`,`type`,`recorded_timestamp`),
  CONSTRAINT `component_event_ibfk_1` FOREIGN KEY (`component`, `component_version`) REFERENCES `component_version` (`component`, `version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `component_version` (
  `component` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `version` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `version_code` int(11) NOT NULL,
  PRIMARY KEY (`component`,`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

