-- MySQL dump 10.13  Distrib 8.0.21, for osx10.14 (x86_64)
--
-- Host: xxxxxx.dblayer.com    Database: prometeo
-- ------------------------------------------------------
-- Server version	5.7.29-log

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
-- Current Database: `prometeo`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `prometeo` /*!40100 DEFAULT CHARACTER SET latin1 */ character set UTF8mb4 collate utf8mb4_unicode_ci;

USE `prometeo`;

--
-- Table structure for table `copy`
--

DROP TABLE IF EXISTS `copy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `copy` (
  `clau` text,
  `SensorID` text,
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
-- Table structure for table `firefighters`
--

DROP TABLE IF EXISTS `firefighters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `firefighters` (
  `firefighter_id` int(11) NOT NULL AUTO_INCREMENT,
  `firefighter_code` varchar(20) DEFAULT NULL,
  `name` varchar(20) DEFAULT NULL,
  `surname` varchar(50) DEFAULT NULL,
  `email` varchar(40) DEFAULT NULL,
  `deleted_at` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`firefighter_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
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
-- Table structure for table `metrics`
--

DROP TABLE IF EXISTS `metrics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `metrics` (
  `clau` varchar(80) NOT NULL,
  `SensorID` varchar(20) NOT NULL,
  `timestamp` bigint(20) DEFAULT NULL,
  `temperature` int(11) DEFAULT NULL,
  `humidity` int(11) DEFAULT NULL,
  `CO` int(11) DEFAULT NULL,
  PRIMARY KEY (`clau`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `metrics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sensors`
--

DROP TABLE IF EXISTS `sensors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sensors` (
  `IntSensorID` int(11) NOT NULL AUTO_INCREMENT,
  `SensorID` varchar(20) NOT NULL,
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

