-- MySQL dump 10.13  Distrib 8.0.23, for osx10.15 (x86_64)
--
-- Host: 159.122.237.4    Database: prometeo
-- ------------------------------------------------------
-- Server version	5.5.5-10.3.23-MariaDB-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `copy`
--

DROP TABLE IF EXISTS `copy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `copy` (
  `clau` text DEFAULT NULL,
  `SensorID` text DEFAULT NULL,
  `timestamp` bigint(20) DEFAULT NULL,
  `temperature` int(11) DEFAULT NULL,
  `humidity` int(11) DEFAULT NULL,
  `CO` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event_types`
--

DROP TABLE IF EXISTS `event_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `event_types` (
  `event_type` int(11) NOT NULL,
  `event_description` varchar(20) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `event_internal_id` int(11) NOT NULL AUTO_INCREMENT,
  `event_code` varchar(20) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `event_type` int(11) DEFAULT NULL,
  `fuel_type` int(11) DEFAULT NULL,
  `event_date` date DEFAULT NULL,
  `init_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `extra_info` varchar(200) DEFAULT NULL,
  `location` point DEFAULT NULL,
  `deleted_at` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`event_internal_id`),
  KEY `fk_event_type_idx` (`event_type`),
  KEY `fk_event_type_idx1` (`fuel_type`),
  KEY `fk_status_idx` (`status`),
  CONSTRAINT `fk_event_type` FOREIGN KEY (`event_type`) REFERENCES `event_types` (`event_type`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_fuel_type` FOREIGN KEY (`fuel_type`) REFERENCES `fuel_types` (`fuel_type`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_status` FOREIGN KEY (`status`) REFERENCES `status` (`statusid`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `events_firefighters_devices`
--

DROP TABLE IF EXISTS `events_firefighters_devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `events_firefighters_devices` (
  `event_internal_id` int(11) NOT NULL,
  `firefighter_id` int(11) NOT NULL,
  `IntSensorID` int(11) NOT NULL,
  PRIMARY KEY (`event_internal_id`,`firefighter_id`,`IntSensorID`),
  KEY `fk_firefighters_idx` (`firefighter_id`),
  KEY `fk_sensors_idx` (`IntSensorID`),
  CONSTRAINT `fk_events` FOREIGN KEY (`event_internal_id`) REFERENCES `events` (`event_internal_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_firefighters` FOREIGN KEY (`firefighter_id`) REFERENCES `firefighters` (`firefighter_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_sensors` FOREIGN KEY (`IntSensorID`) REFERENCES `sensors` (`IntSensorID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feedback` (
  `firefighter_id` int(11) NOT NULL,
  `fire_id` int(11) NOT NULL,
  `answer1` int(11) DEFAULT NULL,
  `answer2` int(11) DEFAULT NULL,
  `answer3` int(11) DEFAULT NULL,
  `answer4` int(11) DEFAULT NULL,
  `deleted_at` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`firefighter_id`,`fire_id`),
  CONSTRAINT `feedback_ibfk_2` FOREIGN KEY (`firefighter_id`) REFERENCES `firefighters` (`firefighter_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `firefighter_sensor_log`
--

DROP TABLE IF EXISTS `firefighter_sensor_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `firefighter_sensor_log` (
  `timestamp_mins` timestamp NOT NULL,
  `firefighter_id` varchar(40) NOT NULL,
  `device_id` varchar(30) DEFAULT NULL,
  `device_battery_level` float DEFAULT NULL,
  `temperature` smallint(6) DEFAULT NULL,
  `humidity` smallint(6) DEFAULT NULL,
  `carbon_monoxide` float DEFAULT NULL,
  `nitrogen_dioxide` float DEFAULT NULL,
  `formaldehyde` float DEFAULT NULL,
  `acrolein` float DEFAULT NULL,
  `benzene` float DEFAULT NULL,
  `device_timestamp` timestamp NULL DEFAULT NULL,
  `device_status_LED` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`timestamp_mins`,`firefighter_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `firefighter_status_analytics`
--

DROP TABLE IF EXISTS `firefighter_status_analytics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `firefighter_status_analytics` (
  `timestamp_mins` timestamp NOT NULL,
  `firefighter_id` varchar(40) NOT NULL,
  `device_id` varchar(30) DEFAULT NULL,
  `device_battery_level` float DEFAULT NULL,
  `temperature` smallint(6) DEFAULT NULL,
  `humidity` smallint(6) DEFAULT NULL,
  `carbon_monoxide` float DEFAULT NULL,
  `nitrogen_dioxide` float DEFAULT NULL,
  `formaldehyde` float DEFAULT NULL,
  `acrolein` float DEFAULT NULL,
  `benzene` float DEFAULT NULL,
  `device_timestamp` timestamp NULL DEFAULT NULL,
  `device_status_LED` smallint(6) DEFAULT NULL,
  `analytics_status_LED` smallint(6) DEFAULT NULL,
  `carbon_monoxide_twa_10min` float DEFAULT NULL,
  `carbon_monoxide_twa_30min` float DEFAULT NULL,
  `carbon_monoxide_twa_60min` float DEFAULT NULL,
  `carbon_monoxide_twa_240min` float DEFAULT NULL,
  `carbon_monoxide_twa_480min` float DEFAULT NULL,
  `carbon_monoxide_gauge_10min` smallint(6) DEFAULT NULL,
  `carbon_monoxide_gauge_30min` smallint(6) DEFAULT NULL,
  `carbon_monoxide_gauge_60min` smallint(6) DEFAULT NULL,
  `carbon_monoxide_gauge_240min` smallint(6) DEFAULT NULL,
  `carbon_monoxide_gauge_480min` smallint(6) DEFAULT NULL,
  `nitrogen_dioxide_twa_10min` float DEFAULT NULL,
  `nitrogen_dioxide_twa_30min` float DEFAULT NULL,
  `nitrogen_dioxide_twa_60min` float DEFAULT NULL,
  `nitrogen_dioxide_twa_240min` float DEFAULT NULL,
  `nitrogen_dioxide_twa_480min` float DEFAULT NULL,
  `nitrogen_dioxide_gauge_10min` smallint(6) DEFAULT NULL,
  `nitrogen_dioxide_gauge_30min` smallint(6) DEFAULT NULL,
  `nitrogen_dioxide_gauge_60min` smallint(6) DEFAULT NULL,
  `nitrogen_dioxide_gauge_240min` smallint(6) DEFAULT NULL,
  `nitrogen_dioxide_gauge_480min` smallint(6) DEFAULT NULL,
  `formaldehyde_twa_10min` float DEFAULT NULL,
  `formaldehyde_twa_30min` float DEFAULT NULL,
  `formaldehyde_twa_60min` float DEFAULT NULL,
  `formaldehyde_twa_240min` float DEFAULT NULL,
  `formaldehyde_twa_480min` float DEFAULT NULL,
  `formaldehyde_gauge_10min` smallint(6) DEFAULT NULL,
  `formaldehyde_gauge_30min` smallint(6) DEFAULT NULL,
  `formaldehyde_gauge_60min` smallint(6) DEFAULT NULL,
  `formaldehyde_gauge_240min` smallint(6) DEFAULT NULL,
  `formaldehyde_gauge_480min` smallint(6) DEFAULT NULL,
  `acrolein_twa_10min` float DEFAULT NULL,
  `acrolein_twa_30min` float DEFAULT NULL,
  `acrolein_twa_60min` float DEFAULT NULL,
  `acrolein_twa_240min` float DEFAULT NULL,
  `acrolein_twa_480min` float DEFAULT NULL,
  `acrolein_gauge_10min` smallint(6) DEFAULT NULL,
  `acrolein_gauge_30min` smallint(6) DEFAULT NULL,
  `acrolein_gauge_60min` smallint(6) DEFAULT NULL,
  `acrolein_gauge_240min` smallint(6) DEFAULT NULL,
  `acrolein_gauge_480min` smallint(6) DEFAULT NULL,
  `benzene_twa_10min` float DEFAULT NULL,
  `benzene_twa_30min` float DEFAULT NULL,
  `benzene_twa_60min` float DEFAULT NULL,
  `benzene_twa_240min` float DEFAULT NULL,
  `benzene_twa_480min` float DEFAULT NULL,
  `benzene_gauge_10min` smallint(6) DEFAULT NULL,
  `benzene_gauge_30min` smallint(6) DEFAULT NULL,
  `benzene_gauge_60min` smallint(6) DEFAULT NULL,
  `benzene_gauge_240min` smallint(6) DEFAULT NULL,
  `benzene_gauge_480min` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`timestamp_mins`,`firefighter_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `firefighters`
--

DROP TABLE IF EXISTS `firefighters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `firefighters` (
  `firefighter_id` int(11) NOT NULL AUTO_INCREMENT,
  `firefighter_code` varchar(40) DEFAULT NULL,
  `name` varchar(20) DEFAULT NULL,
  `surname` varchar(50) DEFAULT NULL,
  `email` varchar(40) DEFAULT NULL,
  `deleted_at` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`firefighter_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fuel_types`
--

DROP TABLE IF EXISTS `fuel_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fuel_types` (
  `fuel_type` int(11) NOT NULL,
  `fuel_description` varchar(20) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`fuel_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jstest`
--

DROP TABLE IF EXISTS `jstest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jstest` (
  `jskey` int(11) NOT NULL,
  `jsrow` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`jskey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `metrics`
--

DROP TABLE IF EXISTS `metrics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `metrics` (
  `clau` varchar(80) NOT NULL,
  `SensorID` varchar(30) NOT NULL,
  `timestamp` bigint(20) DEFAULT NULL,
  `temperature` int(11) DEFAULT NULL,
  `humidity` int(11) DEFAULT NULL,
  `CO` int(11) DEFAULT NULL,
  PRIMARY KEY (`clau`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `metrics_dev`
--

DROP TABLE IF EXISTS `metrics_dev`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `metrics_dev` (
  `metrics_timestamp` timestamp NOT NULL,
  `firefighter_id` varchar(40) NOT NULL,
  `temperature` smallint(6) DEFAULT NULL,
  `humidity` smallint(6) DEFAULT NULL,
  `carbon_monoxide` float DEFAULT NULL,
  `carbon_monoxide_twa_10min` float DEFAULT NULL,
  `carbon_monoxide_twa_30min` float DEFAULT NULL,
  `carbon_monoxide_twa_60min` float DEFAULT NULL,
  `carbon_monoxide_twa_4hr` float DEFAULT NULL,
  `carbon_monoxide_twa_8hr` float DEFAULT NULL,
  `carbon_monoxide_gauge_10min` smallint(6) DEFAULT NULL,
  `carbon_monoxide_gauge_30min` smallint(6) DEFAULT NULL,
  `carbon_monoxide_gauge_60min` smallint(6) DEFAULT NULL,
  `carbon_monoxide_gauge_4hr` smallint(6) DEFAULT NULL,
  `carbon_monoxide_gauge_8hr` smallint(6) DEFAULT NULL,
  `nitrogen_dioxide` float DEFAULT NULL,
  `nitrogen_dioxide_twa_10min` float DEFAULT NULL,
  `nitrogen_dioxide_twa_30min` float DEFAULT NULL,
  `nitrogen_dioxide_twa_60min` float DEFAULT NULL,
  `nitrogen_dioxide_twa_4hr` float DEFAULT NULL,
  `nitrogen_dioxide_twa_8hr` float DEFAULT NULL,
  `nitrogen_dioxide_gauge_10min` smallint(6) DEFAULT NULL,
  `nitrogen_dioxide_gauge_30min` smallint(6) DEFAULT NULL,
  `nitrogen_dioxide_gauge_60min` smallint(6) DEFAULT NULL,
  `nitrogen_dioxide_gauge_4hr` smallint(6) DEFAULT NULL,
  `nitrogen_dioxide_gauge_8hr` smallint(6) DEFAULT NULL,
  `formaldehyde` float DEFAULT NULL,
  `formaldehyde_twa_10min` float DEFAULT NULL,
  `formaldehyde_twa_30min` float DEFAULT NULL,
  `formaldehyde_twa_60min` float DEFAULT NULL,
  `formaldehyde_twa_4hr` float DEFAULT NULL,
  `formaldehyde_twa_8hr` float DEFAULT NULL,
  `formaldehyde_gauge_10min` smallint(6) DEFAULT NULL,
  `formaldehyde_gauge_30min` smallint(6) DEFAULT NULL,
  `formaldehyde_gauge_60min` smallint(6) DEFAULT NULL,
  `formaldehyde_gauge_4hr` smallint(6) DEFAULT NULL,
  `formaldehyde_gauge_8hr` smallint(6) DEFAULT NULL,
  `acrolein` float DEFAULT NULL,
  `acrolein_twa_10min` float DEFAULT NULL,
  `acrolein_twa_30min` float DEFAULT NULL,
  `acrolein_twa_60min` float DEFAULT NULL,
  `acrolein_twa_4hr` float DEFAULT NULL,
  `acrolein_twa_8hr` float DEFAULT NULL,
  `acrolein_gauge_10min` smallint(6) DEFAULT NULL,
  `acrolein_gauge_30min` smallint(6) DEFAULT NULL,
  `acrolein_gauge_60min` smallint(6) DEFAULT NULL,
  `acrolein_gauge_4hr` smallint(6) DEFAULT NULL,
  `acrolein_gauge_8hr` smallint(6) DEFAULT NULL,
  `benzene` float DEFAULT NULL,
  `benzene_twa_10min` float DEFAULT NULL,
  `benzene_twa_30min` float DEFAULT NULL,
  `benzene_twa_60min` float DEFAULT NULL,
  `benzene_twa_4hr` float DEFAULT NULL,
  `benzene_twa_8hr` float DEFAULT NULL,
  `benzene_gauge_10min` smallint(6) DEFAULT NULL,
  `benzene_gauge_30min` smallint(6) DEFAULT NULL,
  `benzene_gauge_60min` smallint(6) DEFAULT NULL,
  `benzene_gauge_4hr` smallint(6) DEFAULT NULL,
  `benzene_gauge_8hr` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`metrics_timestamp`,`firefighter_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sensors`
--

DROP TABLE IF EXISTS `sensors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sensors` (
  `IntSensorID` int(11) NOT NULL AUTO_INCREMENT,
  `SensorID` varchar(30) NOT NULL,
  `model` varchar(20) DEFAULT NULL,
  `version` varchar(20) DEFAULT NULL,
  `deleted_at` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`IntSensorID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `status`
--

DROP TABLE IF EXISTS `status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status` (
  `statusid` int(11) NOT NULL,
  `status_description` varchar(20) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`statusid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_types`
--

DROP TABLE IF EXISTS `user_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_types` (
  `user_type` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(20) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`user_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL,
  `surname` varchar(40) DEFAULT NULL,
  `user_type` int(11) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  KEY `user_type` (`user_type`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`user_type`) REFERENCES `user_types` (`user_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'prometeo'
--
/*!50003 DROP FUNCTION IF EXISTS `sp_count_event_firefighters_devices` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `sp_count_event_firefighters_devices`(
	event_internal_id int(11)
 ) RETURNS int(11)
BEGIN

   DECLARE done INT DEFAULT FALSE;
   DECLARE cuenta INT DEFAULT 0;

   DECLARE c1 CURSOR FOR select count(distinct firefighter_id) from events_firefighters_devices t where t.event_internal_id = event_internal_id;

   DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

   OPEN c1;
   FETCH c1 INTO cuenta;

   CLOSE c1;
	return cuenta;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_select_all_devices` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_select_all_devices`( )
BEGIN

    select * from sensors where deleted_at is null;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_select_all_events` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_select_all_events`(
 )
BEGIN

    select e.event_internal_id, e.event_code, e.status, s.status_description, e.event_type,t.event_description, e.fuel_type, f.fuel_description, DATE_FORMAT(e.event_date, '%m/%d/%Y'), e.init_time, e.end_time, e.extra_info, ST_x(e.location),  ST_y(e.location),
		`prometeo`.`sp_count_event_firefighters_devices`(e.event_internal_id)
			from events e, status s, event_types t, fuel_types f where e.deleted_at is null and e.status=s.statusid and e.event_type=t.event_type and e.fuel_type=f.fuel_type;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_select_all_event_types` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_select_all_event_types`( )
BEGIN

    select * from event_types where deleted_at is null;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_select_all_firefighters` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_select_all_firefighters`( )
BEGIN

    select * from firefighters where deleted_at is null;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_select_all_fuel_types` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_select_all_fuel_types`( )
BEGIN

    select * from fuel_types where deleted_at is null;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_select_all_status` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_select_all_status`( )
BEGIN

    select * from status where deleted_at is null;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_select_device` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_select_device`(
    IN IntSensorID VARCHAR(30)
    )
BEGIN

    select * from sensors where IntSensorID = IntSensorID;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_select_event` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_select_event`(
    IN eventid int
    )
BEGIN

    select event_internal_id, event_code, status, event_type, fuel_type, DATE_FORMAT(event_date, '%m/%d/%Y'), init_time, end_time, extra_info, ST_x(location),  ST_y(location) from events where event_internal_id = eventid;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_select_event_firefighters_devices` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_select_event_firefighters_devices`(
	IN event_internal_id int(11)
 )
BEGIN

    select t.firefighter_id,  f.firefighter_code, t.IntSensorID, s.SensorID from events_firefighters_devices t, sensors s, firefighters f where t.event_internal_id = event_internal_id and t.IntSensorID=s.IntSensorID and t.firefighter_id = f.firefighter_id;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_select_metrics` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_select_metrics`(
    IN sensor_id VARCHAR(30),
    IN event_date VARCHAR(20),
    IN max INT
    )
BEGIN

	select FROM_UNIXTIME(floor(m.timestamp/1000),'%Y-%m-%d'), FROM_UNIXTIME(floor(m.timestamp/1000),'%T'), m.SensorID, m.temperature, m.humidity, m.CO   from metrics   m where m.SensorID = sensor_id and FROM_UNIXTIME(floor(m.timestamp/1000),'%Y-%m-%d') = STR_TO_DATE(event_date,'%d,%m,%Y')   order by timestamp desc limit max;

    END ;;
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

-- Dump completed on 2021-04-09  8:54:01
