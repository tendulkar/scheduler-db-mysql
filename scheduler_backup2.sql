-- MySQL dump 10.13  Distrib 5.1.68, for unknown-linux-gnu (x86_64)
--
-- Host: localhost    Database: scheduler
-- ------------------------------------------------------
-- Server version	5.1.68.0-Yahoo-SMP-log-ssl

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `type` bigint(20) unsigned DEFAULT NULL,
  `trigger_at` bigint(20) unsigned NOT NULL,
  `user_id` char(255) COLLATE utf8_unicode_ci NOT NULL,
  `item_parent_id` bigint(20) unsigned NOT NULL,
  `item_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `metadata` text COLLATE utf8_unicode_ci,
  `mod_metadata` char(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` char(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'RDY_TRIGGER',
  `next_trigger_at` bigint(20) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `_ix_type_trigger_at_user_id_parent_id_id` (`type`,`trigger_at`,`user_id`,`item_parent_id`,`item_id`),
  KEY `_i_trigger_at` (`trigger_at`),
  KEY `_i_status` (`status`),
  KEY `_i_trigger_status` (`trigger_at`,`status`),
  KEY `_i_next_trigger_at` (`next_trigger_at`),
  KEY `_i_type_trigger_at` (`type`,`trigger_at`),
  KEY `_i_type_trigger_status` (`type`,`trigger_at`,`status`),
  KEY `_i_type_status` (`type`,`status`),
  CONSTRAINT `jobs_ibfk_1` FOREIGN KEY (`type`) REFERENCES `type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=314973 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER jobs_add_trigger BEFORE INSERT ON `jobs` FOR EACH ROW BEGIN SET NEW.mod_metadata = MD5(NEW.metadata); END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `jobs_archive`
--

DROP TABLE IF EXISTS `jobs_archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jobs_archive` (
  `job_id` bigint(20) unsigned NOT NULL,
  `type` bigint(20) unsigned DEFAULT NULL,
  `trigger_at` bigint(20) unsigned NOT NULL,
  `user_id` char(255) COLLATE utf8_unicode_ci NOT NULL,
  `item_parent_id` bigint(20) unsigned NOT NULL,
  `item_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `metadata` text COLLATE utf8_unicode_ci,
  `mod_metadata` char(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` char(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'RDY_TRIGGER',
  `next_trigger_at` bigint(20) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=ARCHIVE AUTO_INCREMENT=2048 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `make_jobs`
--

DROP TABLE IF EXISTS `make_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `make_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `job_id` bigint(20) unsigned DEFAULT NULL,
  `type` bigint(20) unsigned DEFAULT NULL,
  `type_name` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `trigger_at` bigint(20) unsigned DEFAULT NULL,
  `user_id` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `item_parent_id` bigint(20) unsigned DEFAULT NULL,
  `item_id` bigint(20) unsigned DEFAULT NULL,
  `metadata` text COLLATE utf8_unicode_ci,
  `mod_metadata` char(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` char(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'RDY_TRIGGER',
  `next_trigger_at` bigint(20) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `operation` char(255) COLLATE utf8_unicode_ci DEFAULT 'INSERT',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=163484 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `type`
--

DROP TABLE IF EXISTS `type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `type` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` bigint(20) unsigned DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `metadata` mediumtext COLLATE utf8_unicode_ci,
  `mod_metadata` char(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `accesskey_hash` char(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_ts` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'ACTIVE',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `_i_name` (`name`),
  KEY `_i_parent_id` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2057 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER type_add_trigger BEFORE INSERT ON `type` FOR EACH ROW BEGIN SET NEW.mod_metadata = MD5(NEW.metadata); SET NEW.created_ts = CURRENT_TIMESTAMP(); SET NEW.accesskey_hash = SHA1(CONCAT(NEW.accesskey_hash, '--ALICE-ALEN--')); END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER type_update_trigger BEFORE UPDATE ON `type` FOR EACH ROW BEGIN SET NEW.mod_metadata = MD5(NEW.metadata); IF (NEW.accesskey_hash IS NOT NULL AND NEW.accesskey_hash <> OLD.accesskey_hash) THEN SET NEW.accesskey_hash = SHA1(CONCAT(NEW.accesskey_hash, '--ALICE-ALEN--')); END IF; END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'scheduler'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `move_jobs` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8 */ ;;
/*!50003 SET character_set_results = utf8 */ ;;
/*!50003 SET collation_connection  = utf8_general_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = '' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE EVENT `move_jobs` ON SCHEDULE EVERY 20 SECOND STARTS '2014-11-07 05:00:01' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN 
        DECLARE v_id, v_job_id, v_type, v_trigger_at, v_item_parent_id, v_item_id, v_next_trigger_at BIGINT UNSIGNED DEFAULT NULL;
        DECLARE v_type_name, v_user_id, v_status, v_operation CHAR(255) DEFAULT NULL;
        DECLARE v_metadata MEDIUMTEXT;
        DECLARE v_last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP();
        DECLARE finished BOOLEAN DEFAULT false;
        DECLARE insertJobsStmt, updateJobsStmt, deleteJobsStmt, deleteMakeJobsStmt VARCHAR(4096);
        DECLARE readyJobs CURSOR FOR 
            SELECT id, job_id, type, type_name, trigger_at, user_id, item_parent_id, item_id, metadata, status, 
                next_trigger_at, last_updated, operation FROM scheduler.make_jobs; 
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = true; 
        
        CALL makePreparedStatements();        
        
        
        SET finished = false;
        OPEN readyJobs; 
        move_job: LOOP 
            
            FETCH readyJobs INTO v_id, v_job_id, v_type, v_type_name, v_trigger_at, v_user_id, v_item_parent_id, v_item_id, 
                v_metadata, v_status, v_next_trigger_at, v_last_updated, v_operation; 
            IF finished IS NOT false THEN LEAVE move_job; END IF; 
            call move_one_job(v_id, v_job_id, v_type, v_type_name, v_trigger_at, v_user_id, v_item_parent_id, v_item_id, v_metadata, 
                            v_status, v_next_trigger_at, v_last_updated, v_operation);

            
         END LOOP;
         
         CLOSE readyJobs; 
         CALL deletePreparedStatements();
    END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'scheduler'
--
/*!50003 DROP FUNCTION IF EXISTS `getJobIdByKey` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 FUNCTION `getJobIdByKey`(v_type BIGINT UNSIGNED, v_trigger_at BIGINT UNSIGNED, v_user_id CHAR(255), 
                    v_item_id BIGINT UNSIGNED, v_item_parent_id BIGINT UNSIGNED) RETURNS bigint(20) unsigned
    READS SQL DATA
BEGIN
     DECLARE v_id, v_next_trigger_at BIGINT UNSIGNED DEFAULT NULL;
     DECLARE v_type_name, v_status, v_operation CHAR(255) DEFAULT NULL;
     DECLARE v_metadata MEDIUMTEXT;

     SELECT id INTO v_id
         FROM scheduler.jobs
         WHERE type = v_type AND trigger_at = v_trigger_at AND user_id = v_user_id AND item_parent_id = v_item_parent_id AND item_id = v_item_id;
     RETURN v_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `insertDeleteJobsMultiple` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 FUNCTION `insertDeleteJobsMultiple`(v_count BIGINT UNSIGNED, v_start_job_id BIGINT UNSIGNED) RETURNS bigint(20) unsigned
    READS SQL DATA
BEGIN
    DECLARE ret_v_count BIGINT UNSIGNED DEFAULT v_count;
    delete_multiple: LOOP
        SET v_count = v_count -1;
        CALL insertDeleteJobById(v_start_job_id);
        SET v_start_job_id = v_start_job_id + 1;

        IF (v_count = 0) THEN
             LEAVE delete_multiple;
        END IF;
    END LOOP;
    RETURN ret_v_count;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `insertUpdateJobsMultiple` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 FUNCTION `insertUpdateJobsMultiple`(v_count BIGINT UNSIGNED, v_start_job_id BIGINT UNSIGNED) RETURNS bigint(20) unsigned
    READS SQL DATA
BEGIN
    DECLARE ret_v_count BIGINT UNSIGNED DEFAULT v_count;
    update_multiple: LOOP
        SET v_count = v_count -1;    
        CALL insertUpdateJobById(v_start_job_id);
        SET v_start_job_id = v_start_job_id + 1;

        IF (v_count = 0) THEN
            LEAVE update_multiple;
        END IF;
    END LOOP;
    RETURN ret_v_count;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deletePreparedStatements` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `deletePreparedStatements`()
BEGIN
    DEALLOCATE PREPARE insertJobsStmt;
    DEALLOCATE PREPARE updateJobsStmt;
    DEALLOCATE PREPARE deleteJobsStmt;
    DEALLOCATE PREPARE deleteMakeJobsStmt;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insertDeleteJobById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `insertDeleteJobById`(IN v_id BIGINT UNSIGNED)
BEGIN
    INSERT INTO scheduler.make_jobs(job_id, operation)
        VALUES (v_id, 'DELETE'); 
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insertJob` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `insertJob`()
BEGIN
   INSERT INTO scheduler.make_jobs(type, user_id, item_parent_id, item_id, trigger_at, next_trigger_at, metadata, status)
        VALUES(2054, CONCAT('user_random_example', ROUND(1000000000.0 * RAND())), 1000, 999, UNIX_TIMESTAMP() + ROUND(100000.0 * RAND()), 
        UNIX_TIMESTAMP() + 100000 + ROUND(1000000.0 * RAND()), '{\"glossary\":{\"title\":\"example glossary\",\"GlossDiv\":{\"title\":\"S\",\"GlossList\":{\"GlossEntry\":{\"ID\":\"SGML\",\"SortAs\":\"SGML\",\"GlossTerm\":\"Standard Generalized Markup Language\",\"Acronym\":\"SGML\",\"Abbrev\":\"ISO 8879:1986\",\"GlossDef\":{\"para\":\"A meta-markup language, used to create markup languages such as DocBook.\",\"GlossSeeAlso\":[\"GML\",\"XML\"]},\"GlossSee\":\"markup\"}}}}}', 'RDY_TRIGGER_SAMPLE'); 
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insertJobs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `insertJobs`(IN cnt BIGINT UNSIGNED)
BEGIN
    job_insert: LOOP
        SET cnt = cnt - 1;
        CALL insertJob();        
        IF cnt <> 0 THEN ITERATE job_insert; END IF;
        LEAVE job_insert;
    END LOOP job_insert;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insertUpdateJob` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `insertUpdateJob`(v_id BIGINT UNSIGNED, v_type BIGINT UNSIGNED, v_item_parent_id BIGINT UNSIGNED, v_item_id BIGINT UNSIGNED, 
                v_trigger_at BIGINT UNSIGNED, v_next_trigger_at  BIGINT UNSIGNED, v_user_id CHAR(255), v_status CHAR(255), v_metadata MEDIUMTEXT)
BEGIN

    INSERT INTO scheduler.make_jobs(job_id, type, user_id, item_parent_id, item_id, trigger_at, next_trigger_at, metadata, status, operation)
        VALUES(v_id, v_type, v_user_id, v_item_parent_id, v_item_id, v_trigger_at, v_next_trigger_at, v_metadata, v_status, 'UPDATE');    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insertUpdateJobById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `insertUpdateJobById`(v_id BIGINT UNSIGNED)
BEGIN
     DECLARE v_job_id, v_type, v_trigger_at, v_item_parent_id, v_item_id, v_next_trigger_at BIGINT UNSIGNED DEFAULT NULL;
     DECLARE v_type_name, v_user_id, v_status, v_operation CHAR(255) DEFAULT NULL;
     DECLARE v_metadata MEDIUMTEXT;
     
     SELECT type, trigger_at, user_id, item_parent_id, item_id, metadata, next_trigger_at, status
        INTO v_type, v_trigger_at, v_user_id, v_item_parent_id, v_item_id, v_metadata, v_next_trigger_at, v_status
        FROM scheduler.jobs
        WHERE id = v_id;
    SET v_item_id = ROUND(1000 + 10000.0*RAND());
    CALL insertUpdateJob(v_id, v_type, v_item_parent_id, v_item_id, v_trigger_at, v_next_trigger_at, v_user_id, v_status, v_metadata);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insertUpdateJobByUniqueKey` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `insertUpdateJobByUniqueKey`(v_type BIGINT UNSIGNED, v_trigger_at BIGINT UNSIGNED, v_user_id CHAR(255), 
                    v_item_id BIGINT UNSIGNED, v_item_parent_id BIGINT UNSIGNED)
BEGIN
     DECLARE v_id, v_next_trigger_at BIGINT UNSIGNED DEFAULT NULL;
     DECLARE v_type_name, v_status, v_operation CHAR(255) DEFAULT NULL;
     DECLARE v_metadata MEDIUMTEXT;
     
     SELECT id, metadata, next_trigger_at, status
        INTO v_id, v_metadata, v_next_trigger_at, v_status
        FROM scheduler.jobs
        WHERE type = v_type AND trigger_at = v_trigger_at AND user_id = v_user_id AND item_parent_id = v_item_parent_id AND item_id = v_item_id;
    SET v_item_id = ROUND(1000 + 10000.0*RAND());
    CALL insertUpdateJob(v_id, v_type, v_item_parent_id, v_item_id, v_trigger_at, v_next_trigger_at, v_user_id, v_status, v_metadata);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `makePreparedStatements` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `makePreparedStatements`()
BEGIN
    PREPARE insertJobsStmt FROM 'INSERT INTO scheduler.jobs (type, trigger_at, user_id, item_parent_id, item_id, metadata, next_trigger_at, status)
                            VALUES (?, ?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE last_updated = CURRENT_TIMESTAMP()';
    PREPARE updateJobsStmt FROM 'UPDATE scheduler.jobs
                            SET type = ?, trigger_at = ?, user_id = ?, item_parent_id = ?, item_id = ?,  metadata = ?, next_trigger_at = ?, status = ?
                            WHERE id = ?';
    PREPARE deleteJobsStmt FROM 'DELETE FROM scheduler.jobs WHERE id = ?';
    PREPARE deleteMakeJobsStmt FROM 'DELETE FROM scheduler.make_jobs WHERE id = ?';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `move_one_job` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `move_one_job`(v_id BIGINT UNSIGNED, v_job_id BIGINT UNSIGNED, v_type BIGINT UNSIGNED, v_type_name CHAR(255), v_trigger_at BIGINT UNSIGNED,
                                 v_user_id CHAR(255), v_item_parent_id BIGINT UNSIGNED, v_item_id BIGINT UNSIGNED, v_metadata MEDIUMTEXT, 
                              v_status CHAR(255), v_next_trigger_at BIGINT UNSIGNED, v_last_updated TIMESTAMP, v_operation CHAR(255))
BEGIN
    DECLARE tempId BIGINT UNSIGNED;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
        BEGIN 
            ROLLBACK; 
            IF(v_last_updated < NOW() - INTERVAL 20 MINUTE) THEN 
                SET autocommit = true;
                SET @s_temp_id = v_id;
                EXECUTE deleteMakeJobsStmt USING @s_temp_id;
            END IF;
        END;
            
            SET @s_v_id = v_id, @s_v_type = v_type, @s_v_trigger_at = v_trigger_at, @s_v_user_id = v_user_id, @s_v_item_parent_id = v_item_parent_id,
                @s_v_item_id = v_item_id, @s_v_metadata = v_metadata, @s_v_next_trigger_at = v_next_trigger_at, @s_v_status = v_status;
            SET autocommit = false;
            START TRANSACTION;
                SELECT id INTO tempId FROM scheduler.make_jobs WHERE id = v_id FOR UPDATE;

                IF (v_operation <> 'DELETE' AND v_type IS NULL OR v_type = 0) THEN 
                    SELECT id INTO v_type FROM scheduler.type WHERE name = v_type_name LIMIT 1; 
                END IF; 
          
                IF (v_operation <> 'INSERT' AND v_job_id IS NULL OR v_job_id = 0) THEN 
                    SELECT id INTO v_job_id FROM scheduler.jobs 
                        WHERE type = v_type AND trigger_at = v_trigger_at AND user_id = v_user_id AND item_parent_id = v_item_parent_id AND item_id = v_item_id LIMIT 1; 
                END IF ;  
                SET @s_v_job_id = v_job_id;
                 
                IF (v_type IS NOT NULL AND v_type <> 0  AND v_operation = 'INSERT') THEN 
                   EXECUTE insertJobsStmt USING @s_v_type, @s_v_trigger_at, @s_v_user_id, @s_v_item_parent_id, @s_v_item_id, @s_v_metadata, @s_v_next_trigger_at, @s_v_status;
                END IF; 
            
                
                IF (v_type IS NOT NULL AND v_type <> 0 AND v_job_id IS NOT NULL AND v_job_id <> 0) THEN 
                    IF (v_operation = 'UPDATE') THEN 
                        
                        EXECUTE updateJobsStmt USING @s_v_type, @s_v_trigger_at, @s_v_user_id, @s_v_item_parent_id, @s_v_item_id, 
                        @s_v_metadata, @s_v_next_trigger_at, @s_v_status, @s_v_job_id;
                    END IF ; 
                END IF;

                IF (v_job_id IS NOT NULL AND v_job_id > 0 AND v_operation = 'DELETE') THEN 
                    EXECUTE deleteJobsStmt USING @s_v_job_id ;
                END IF;  
                EXECUTE deleteMakeJobsStmt USING @s_v_id ;
            COMMIT;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-11-07  9:05:11
