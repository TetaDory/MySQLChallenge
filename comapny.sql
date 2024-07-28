DROP TABLE IF EXISTS `ArchivedProjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ArchivedProjects` (
  `ProjectID` int NOT NULL AUTO_INCREMENT,
  `ProjectName` varchar(100) NOT NULL,
  `Requirements` text,
  `Deadline` date DEFAULT NULL,
  `ClientID` int DEFAULT NULL,
  PRIMARY KEY (`ProjectID`),
  KEY `ClientID` (`ClientID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES `ArchivedProjects` WRITE;
UNLOCK TABLES;