-- MySQL dump 10.14  Distrib 5.5.52-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: ctf
-- ------------------------------------------------------
-- Server version	5.5.52-MariaDB

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
-- Table structure for table `cat_task`
--

DROP TABLE IF EXISTS `cat_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_task` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cat_id` int(11) DEFAULT NULL,
  `task_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=673 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_task`
--

LOCK TABLES `cat_task` WRITE;
/*!40000 ALTER TABLE `cat_task` DISABLE KEYS */;
INSERT INTO `cat_task` VALUES (655,7,0),(656,7,10),(657,7,20),(658,1,11),(659,1,12),(660,1,13),(661,1,14),(662,1,15),(663,2,21),(664,2,22),(665,2,23),(666,2,24),(667,2,25),(668,4,41),(669,4,42),(670,5,51),(671,6,61),(672,6,62);
/*!40000 ALTER TABLE `cat_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `short_name` text,
  `name` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Web','Web'),(2,'Rev','Reversing'),(4,'Crypto','Crypto'),(5,'Test','Test'),(6,'Pwn','Pwn'),(7,'Misc','Misc');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flags`
--

DROP TABLE IF EXISTS `flags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `flags` (
  `task_id` int(11) NOT NULL DEFAULT '0',
  `user_id` int(11) NOT NULL DEFAULT '0',
  `score` int(11) DEFAULT NULL,
  `timestamp` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`task_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flags`
--

LOCK TABLES `flags` WRITE;
/*!40000 ALTER TABLE `flags` DISABLE KEYS */;
INSERT INTO `flags` VALUES (1,1,100,1502257516421),(2,1,100,1501233693407),(2,4,100,1502257552904),(3,1,100,1501245665339),(3,2,100,1502327743875),(4,1,200,1501810816816),(4,2,200,1502327791373),(6,4,200,1501812285699),(10,6,60,1502434767397),(11,1,50,1502433753039),(20,1,70,1502433783500),(21,1,50,1502433763315),(41,4,50,1502437972034),(42,1,60,1502433771556),(51,1,50,1502846567859);
/*!40000 ALTER TABLE `flags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` mediumtext,
  `flag` mediumtext,
  `score` mediumtext,
  `file` mediumtext,
  `row` int(11) DEFAULT NULL,
  `desc` mediumtext,
  `service` mediumtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks`
--

LOCK TABLES `tasks` WRITE;
/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;
INSERT INTO `tasks` VALUES (10,'The misc test_2','flag{test_misc_2}','60','misc60.zip',1,'This is a description of the problem. The Subject test, the flag is flag{test_misc_2}',NULL),(11,'The web test_1','flag{test_web_1}','50','web50.zip',0,'This is a description of the problem. The Subject test, the flag is flag{test_web_1} ','https://www.w2n1ck.com/'),(12,'The web test_2','flag{test_web_2}','60',NULL,1,'This is a description of the problem. The Subject test, the flag is flag{test_web_2}','https://byd.dropsec.xyz/'),(13,'The web test_3','flag{test_web_3}','70',NULL,2,'This is a description of the problem. The Subject test, the flag is flag{test_web_3}','https://www.baidu.com/?id=1/'),(14,'The web test_4','flag{test_web_4}','80',NULL,3,'This is a description of the problem. The Subject test, the flag is flag{test_web_4}','https://www.baidu.com/?id=1&id=2/'),(15,'The web test_5','flag{test_web_5}','90',NULL,4,'This is a description of the problem. The Subject test, the flag is flag{test_web_5}','https://byd.dropsec.xyz/'),(20,'The misc test_3','flag{test_misc_3}','70','misc70.zip',2,'这是关卡的描述. 测试关卡, the flag is flag{test_misc_3}',NULL),(21,'中文测试1','flag{test_reversing_1}','50','rev50.zip',0,'这是关卡的描述. 测试关卡,This is a description of the problem. The Subject test, the flag is flag{test_reversing_1}',NULL),(22,'中文测试2','flag{test_reversing_2}','60','rev60.zip',1,'这是关卡的描述. 测试关卡,This is a description of the problem. The Subject test, the flag is flag{test_reversing_2}',NULL),(23,'中文测试3','flag{test_reversing_3}','70','rev70.zip',2,'这是关卡的描述. 测试关卡,This is a description of the problem. The Subject test, the flag is flag{test_reversing_3}',NULL),(24,'中文测试4','flag{test_reversing_4}','80','rev80.zip',3,'这是关卡的描述. 测试关卡,This is a description of the problem. The Subject test, the flag is flag{test_reversing_4}',NULL),(25,'中文测试5','flag{test_reversing_5}','90','rev90.zip',4,'这是关卡的描述. 测试关卡,This is a description of the problem. The Subject test, the flag is flag{test_reversing_5}',NULL),(41,'The Crypto test_1','flag{crypto_test_1}','50','crypto50.zip',0,'This is a description of the problem. The Subject test, the flag is flag{crypto_test_1}',NULL),(42,'The Crypto test_2','flag{crypto_test_2}','60','crypto60.zip',1,'This is a description of the problem. The Subject test, the flag is flag{crypto_test_2}',NULL),(51,'Other Test !','flag{other_test_1*^)_123}','50',NULL,0,'This is a description of the problem. The Subject test, the flag is flag{other_test_1*^)_123}','https://byd.dropsec.xyz/'),(61,'Pwn_Test_1','flag{Pwn_Test_1}','80','exp80.zip',3,'This is a description of the problem. The Subject test, the flag is flag{Pwn_Test_1}','https://byd.dropsec.xyz/'),(62,'Pwn_Test_2','flag{Pwn_Test_2!}','90',NULL,4,'This is a description of the problem. The Subject test, the flag is flag{Pwn_Test_2!}','https://byd.dropsec.xyz/'),(94,'The misc test_1','flag{test_misc_1}','50','misc50.zip',0,'This is a description of the problem. The Subject test, the flag is flag{test_misc_1}',NULL);
/*!40000 ALTER TABLE `tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` text,
  `hidden` int(11) DEFAULT NULL,
  `password` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'w2n1ck',0,'pbkdf2:sha256:50000$1dU2KMGL$16a29e812120573f95ea72fad4e674064c5147d9e5685578db616b0dc641c0a0'),(2,'test',0,'pbkdf2:sha256:50000$gsRKzZ4X$11285a4c95ac64308a10e13db951a20be4620b81aed90cd4a98a1e99c6f2c81c'),(3,'admin',0,'pbkdf2:sha256:50000$Izgr4A4I$09bd48c901e8dae62928910b05dd93eb57e697340025eb82c3931dd6cd73b9df'),(4,'123',0,'pbkdf2:sha256:50000$6LrbvxOG$5a332fdec9e25143aef75d7f4ee62482309cbb0423effece2c0c3512b5ec056e'),(5,'123456',0,'pbkdf2:sha256:50000$RzKorcsf$39ee268b548e86a930c2ac966034bae49cce008ee31ea7fceeb2f2d61ef74012'),(6,'admin123',0,'pbkdf2:sha256:50000$6Y10AoSz$7535de4e5a5bb598f89a00ae2a0d93bad049bf64b2913df8b7183d00faa66d9b'),(7,'testtest',0,'pbkdf2:sha256:50000$rn4KAAkH$4e8fb8b8d9fe396d8cd9859fe35848a910d5351b57bc8f96c200c54134ad717c');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-08-28  9:54:18
