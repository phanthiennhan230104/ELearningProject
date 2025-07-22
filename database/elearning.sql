CREATE DATABASE  IF NOT EXISTS `elearning` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `elearning`;
-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: elearning
-- ------------------------------------------------------
-- Server version	9.1.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Assignments`
--

DROP TABLE IF EXISTS `Assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Assignments` (
  `assignment_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `description` longtext,
  `content` longtext,
  `start_date` datetime(6) DEFAULT NULL,
  `due` datetime(6) DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  `lesson_id` int NOT NULL,
  PRIMARY KEY (`assignment_id`),
  KEY `Assignments_lesson_id_0973368f_fk_Lessons_lesson_id` (`lesson_id`),
  CONSTRAINT `Assignments_lesson_id_0973368f_fk_Lessons_lesson_id` FOREIGN KEY (`lesson_id`) REFERENCES `Lessons` (`lesson_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Assignments`
--

LOCK TABLES `Assignments` WRITE;
/*!40000 ALTER TABLE `Assignments` DISABLE KEYS */;
INSERT INTO `Assignments` VALUES (1,'Python Test','None','Test 1','2025-07-19 00:00:00.000000','2025-07-20 00:00:00.000000','assignments/Test1.pdf',1);
/*!40000 ALTER TABLE `Assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Course_Feedback`
--

DROP TABLE IF EXISTS `Course_Feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Course_Feedback` (
  `cf_id` int NOT NULL AUTO_INCREMENT,
  `rating` int DEFAULT NULL,
  `comment` longtext,
  `submitted_at` datetime(6) NOT NULL,
  `course_id` int NOT NULL,
  `student_id` int NOT NULL,
  PRIMARY KEY (`cf_id`),
  UNIQUE KEY `Course_Feedback_course_id_student_id_56ed403d_uniq` (`course_id`,`student_id`),
  KEY `Course_Feedback_student_id_8e6a8737_fk_Users_user_id` (`student_id`),
  CONSTRAINT `Course_Feedback_course_id_c0449463_fk_Courses_course_id` FOREIGN KEY (`course_id`) REFERENCES `Courses` (`course_id`),
  CONSTRAINT `Course_Feedback_student_id_8e6a8737_fk_Users_user_id` FOREIGN KEY (`student_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Course_Feedback`
--

LOCK TABLES `Course_Feedback` WRITE;
/*!40000 ALTER TABLE `Course_Feedback` DISABLE KEYS */;
/*!40000 ALTER TABLE `Course_Feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Course_Student`
--

DROP TABLE IF EXISTS `Course_Student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Course_Student` (
  `cs_id` int NOT NULL AUTO_INCREMENT,
  `enrolled_at` datetime(6) NOT NULL,
  `course_id` int NOT NULL,
  `student_id` int NOT NULL,
  PRIMARY KEY (`cs_id`),
  UNIQUE KEY `Course_Student_course_id_student_id_9309e0d3_uniq` (`course_id`,`student_id`),
  KEY `Course_Student_student_id_34ee3238_fk_Users_user_id` (`student_id`),
  CONSTRAINT `Course_Student_course_id_721eff73_fk_Courses_course_id` FOREIGN KEY (`course_id`) REFERENCES `Courses` (`course_id`),
  CONSTRAINT `Course_Student_student_id_34ee3238_fk_Users_user_id` FOREIGN KEY (`student_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Course_Student`
--

LOCK TABLES `Course_Student` WRITE;
/*!40000 ALTER TABLE `Course_Student` DISABLE KEYS */;
/*!40000 ALTER TABLE `Course_Student` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Course_Subject`
--

DROP TABLE IF EXISTS `Course_Subject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Course_Subject` (
  `course_sub_id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `subject_id` int NOT NULL,
  PRIMARY KEY (`course_sub_id`),
  UNIQUE KEY `Course_Subject_course_id_subject_id_8f93c016_uniq` (`course_id`,`subject_id`),
  KEY `Course_Subject_subject_id_82efc97b_fk_Subjects_subject_id` (`subject_id`),
  CONSTRAINT `Course_Subject_course_id_f855d998_fk_Courses_course_id` FOREIGN KEY (`course_id`) REFERENCES `Courses` (`course_id`),
  CONSTRAINT `Course_Subject_subject_id_82efc97b_fk_Subjects_subject_id` FOREIGN KEY (`subject_id`) REFERENCES `Subjects` (`subject_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Course_Subject`
--

LOCK TABLES `Course_Subject` WRITE;
/*!40000 ALTER TABLE `Course_Subject` DISABLE KEYS */;
INSERT INTO `Course_Subject` VALUES (1,1,1),(2,2,2);
/*!40000 ALTER TABLE `Course_Subject` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Courses`
--

DROP TABLE IF EXISTS `Courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Courses` (
  `course_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` longtext,
  `created_date` datetime(6) NOT NULL,
  `year` int DEFAULT NULL,
  `teacher_id` int NOT NULL,
  PRIMARY KEY (`course_id`),
  KEY `Courses_teacher_id_8beca2ea_fk_Users_user_id` (`teacher_id`),
  CONSTRAINT `Courses_teacher_id_8beca2ea_fk_Users_user_id` FOREIGN KEY (`teacher_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Courses`
--

LOCK TABLES `Courses` WRITE;
/*!40000 ALTER TABLE `Courses` DISABLE KEYS */;
INSERT INTO `Courses` VALUES (1,'Python Basic Course','First Course For Learner','2025-07-19 15:30:47.663493',2025,3),(2,'Perl Basic Course','First Course','2025-07-19 15:36:58.632465',2025,3);
/*!40000 ALTER TABLE `Courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Lessons`
--

DROP TABLE IF EXISTS `Lessons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Lessons` (
  `lesson_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` longtext,
  `content` longtext,
  `course_sub_id` int NOT NULL,
  PRIMARY KEY (`lesson_id`),
  KEY `Lessons_course_sub_id_5ecf1a3f_fk_Course_Subject_course_sub_id` (`course_sub_id`),
  CONSTRAINT `Lessons_course_sub_id_5ecf1a3f_fk_Course_Subject_course_sub_id` FOREIGN KEY (`course_sub_id`) REFERENCES `Course_Subject` (`course_sub_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Lessons`
--

LOCK TABLES `Lessons` WRITE;
/*!40000 ALTER TABLE `Lessons` DISABLE KEYS */;
INSERT INTO `Lessons` VALUES (1,'Giới thiệu Python và ứng dụng thực tế','Tổng quan về ngôn ngữ lập trình Python và các ứng dụng phổ biến.','## 1. Python là gì?\nPython là một ngôn ngữ lập trình thông dịch, hướng đối tượng, rất phổ biến hiện nay.\n\n## 2. Ứng dụng của Python:\n- Phân tích dữ liệu (Data Analysis)\n- Trí tuệ nhân tạo (AI/ML)\n- Phát triển web (Django, Flask)\n- Tự động hóa\n- Lập trình trò chơi\n\n## 3. Vì sao học Python?\n- Cú pháp đơn giản\n- Dễ đọc, dễ viết\n- Cộng đồng lớn, thư viện phong phú',1),(2,'Giới thiệu ngôn ngữ Perl','Tổng quan về lịch sử, đặc điểm và ứng dụng của Perl.','## 1. Perl là gì?\nPerl (Practical Extraction and Report Language) là một ngôn ngữ lập trình được Larry Wall phát triển năm 1987.\n\n## 2. Đặc điểm nổi bật:\n- Mạnh mẽ trong xử lý văn bản\n- Hỗ trợ biểu thức chính quy mạnh mẽ\n- Cú pháp linh hoạt, hỗ trợ lập trình thủ tục và hướng đối tượng\n\n## 3. Ứng dụng phổ biến:\n- Tự động hóa hệ thống (Sysadmin scripts)\n- Phân tích log và dữ liệu\n- CGI scripting cho web\n- Bioinformatics',2);
/*!40000 ALTER TABLE `Lessons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Notification_User`
--

DROP TABLE IF EXISTS `Notification_User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Notification_User` (
  `noti_user_id` int NOT NULL AUTO_INCREMENT,
  `is_read` tinyint(1) NOT NULL,
  `notification_id` int NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`noti_user_id`),
  UNIQUE KEY `Notification_User_notification_id_user_id_c5eee09c_uniq` (`notification_id`,`user_id`),
  KEY `Notification_User_user_id_422e5bb8_fk_Users_user_id` (`user_id`),
  CONSTRAINT `Notification_User_notification_id_6450a6a0_fk_Notificat` FOREIGN KEY (`notification_id`) REFERENCES `Notifications` (`notification_id`),
  CONSTRAINT `Notification_User_user_id_422e5bb8_fk_Users_user_id` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Notification_User`
--

LOCK TABLES `Notification_User` WRITE;
/*!40000 ALTER TABLE `Notification_User` DISABLE KEYS */;
/*!40000 ALTER TABLE `Notification_User` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Notifications`
--

DROP TABLE IF EXISTS `Notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Notifications` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `message` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `is_global` tinyint(1) NOT NULL,
  `assignment_id` int DEFAULT NULL,
  `course_id` int DEFAULT NULL,
  `sender_id` int DEFAULT NULL,
  PRIMARY KEY (`notification_id`),
  KEY `Notifications_assignment_id_3641c292_fk_Assignmen` (`assignment_id`),
  KEY `Notifications_course_id_e8b2a240_fk_Courses_course_id` (`course_id`),
  KEY `Notifications_sender_id_b39735f8_fk_Users_user_id` (`sender_id`),
  CONSTRAINT `Notifications_assignment_id_3641c292_fk_Assignmen` FOREIGN KEY (`assignment_id`) REFERENCES `Assignments` (`assignment_id`),
  CONSTRAINT `Notifications_course_id_e8b2a240_fk_Courses_course_id` FOREIGN KEY (`course_id`) REFERENCES `Courses` (`course_id`),
  CONSTRAINT `Notifications_sender_id_b39735f8_fk_Users_user_id` FOREIGN KEY (`sender_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Notifications`
--

LOCK TABLES `Notifications` WRITE;
/*!40000 ALTER TABLE `Notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `Notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Profiles`
--

DROP TABLE IF EXISTS `Profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Profiles` (
  `user_id` int NOT NULL,
  `fullname` varchar(255) NOT NULL,
  `dob` date NOT NULL,
  `gender` varchar(10) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `Profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Profiles`
--

LOCK TABLES `Profiles` WRITE;
/*!40000 ALTER TABLE `Profiles` DISABLE KEYS */;
INSERT INTO `Profiles` VALUES (2,'Le Trung Nguyen','2004-04-10','Male','0867656419','Quang Tri Province'),(3,'Nguyen Tan Tin','2004-04-22','Male','0398931209','Da Nang City'),(4,'Le Minh Hoang','2000-01-01','Other',NULL,NULL);
/*!40000 ALTER TABLE `Profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Roles`
--

DROP TABLE IF EXISTS `Roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Roles` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` longtext,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Roles`
--

LOCK TABLES `Roles` WRITE;
/*!40000 ALTER TABLE `Roles` DISABLE KEYS */;
INSERT INTO `Roles` VALUES (1,'Student',''),(2,'Admin','Superuser'),(3,'Teacher',NULL);
/*!40000 ALTER TABLE `Roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Subjects`
--

DROP TABLE IF EXISTS `Subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Subjects` (
  `subject_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `desc` longtext,
  PRIMARY KEY (`subject_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Subjects`
--

LOCK TABLES `Subjects` WRITE;
/*!40000 ALTER TABLE `Subjects` DISABLE KEYS */;
INSERT INTO `Subjects` VALUES (1,'Python','Python from Beginner to Expert'),(2,'Perl','Perl from Beginner to Expert');
/*!40000 ALTER TABLE `Subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Submissions`
--

DROP TABLE IF EXISTS `Submissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Submissions` (
  `sub_id` int NOT NULL AUTO_INCREMENT,
  `submitted_at` datetime(6) NOT NULL,
  `point` double DEFAULT NULL,
  `assignment_id` int NOT NULL,
  `student_id` int NOT NULL,
  `file` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`sub_id`),
  UNIQUE KEY `Submissions_student_id_assignment_id_74d6be8f_uniq` (`student_id`,`assignment_id`),
  KEY `Submissions_assignment_id_219bdc3d_fk_Assignments_assignment_id` (`assignment_id`),
  CONSTRAINT `Submissions_assignment_id_219bdc3d_fk_Assignments_assignment_id` FOREIGN KEY (`assignment_id`) REFERENCES `Assignments` (`assignment_id`),
  CONSTRAINT `Submissions_student_id_a87eb99e_fk_Users_user_id` FOREIGN KEY (`student_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Submissions`
--

LOCK TABLES `Submissions` WRITE;
/*!40000 ALTER TABLE `Submissions` DISABLE KEYS */;
INSERT INTO `Submissions` VALUES (1,'2025-07-19 16:04:43.475284',8,1,2,'submissions/Test1_Answer_LeTrungNguyen.pdf'),(3,'2025-07-19 16:12:37.299790',2,1,4,'submissions/Test1_Answer2_LeMinhHoang.pdf');
/*!40000 ALTER TABLE `Submissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Users` (
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(150) NOT NULL,
  `password` varchar(128) NOT NULL,
  `email` varchar(254) NOT NULL,
  `created_date` datetime(6) NOT NULL,
  `is_email_verified` tinyint(1) NOT NULL,
  `role_id` int NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  KEY `Users_role_id_8e3bb598_fk_Roles_role_id` (`role_id`),
  CONSTRAINT `Users_role_id_8e3bb598_fk_Roles_role_id` FOREIGN KEY (`role_id`) REFERENCES `Roles` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES ('2025-07-19 16:34:22.512870',1,1,'admin','pbkdf2_sha256$1000000$YrfMEERAKr6Nf8SvIY0Z00$Yp5kI52SV42GptgfVOhJ2NL7t4jwa4vSqHM+WLjzGtI=','phanthiennhan230104@gmail.com','2025-07-19 15:14:24.495692',1,2,1),('2025-07-19 16:32:21.959724',0,2,'hs1','pbkdf2_sha256$1000000$QOvds1GqFJ33pzJ9EN6GzA$Nf6+/pNr+ASuXQf8aKgyUsRJ9KoWBCTmkmXF+Z/Lv0U=','letrungnguyen1004@gmail.com','2025-07-19 15:16:57.689547',1,1,0),('2025-07-19 16:15:17.865718',0,3,'gv1','pbkdf2_sha256$1000000$am6HgeM84ZSt3YCjUGcWQh$TLgGsd1eVZiFXb7UWYHh6myyBdOV8qmu9Ge6Hgt9Xsg=','nguyentin.22042004@gmail.com','2025-07-19 15:18:11.438653',1,3,0),('2025-07-19 16:12:19.688409',0,4,'hs2','pbkdf2_sha256$1000000$2i8JbQFadvAp5rzmfX9oRs$1+QV+ZcacY9i21gckzYdnUrGIKq7lUs1l4iO7ouP0sk=','leeminhhoang2409@gmail.com','2025-07-19 16:12:12.453984',1,1,0);
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Users_groups`
--

DROP TABLE IF EXISTS `Users_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Users_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customuser_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Users_groups_customuser_id_group_id_58b380ea_uniq` (`customuser_id`,`group_id`),
  KEY `Users_groups_group_id_2ddde7ed_fk_auth_group_id` (`group_id`),
  CONSTRAINT `Users_groups_customuser_id_79b5ce10_fk_Users_user_id` FOREIGN KEY (`customuser_id`) REFERENCES `Users` (`user_id`),
  CONSTRAINT `Users_groups_group_id_2ddde7ed_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users_groups`
--

LOCK TABLES `Users_groups` WRITE;
/*!40000 ALTER TABLE `Users_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `Users_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Users_user_permissions`
--

DROP TABLE IF EXISTS `Users_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Users_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customuser_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Users_user_permissions_customuser_id_permission_id_6fd8bfec_uniq` (`customuser_id`,`permission_id`),
  KEY `Users_user_permissio_permission_id_7995fa19_fk_auth_perm` (`permission_id`),
  CONSTRAINT `Users_user_permissio_permission_id_7995fa19_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `Users_user_permissions_customuser_id_49b115f6_fk_Users_user_id` FOREIGN KEY (`customuser_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users_user_permissions`
--

LOCK TABLES `Users_user_permissions` WRITE;
/*!40000 ALTER TABLE `Users_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `Users_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add content type',4,'add_contenttype'),(14,'Can change content type',4,'change_contenttype'),(15,'Can delete content type',4,'delete_contenttype'),(16,'Can view content type',4,'view_contenttype'),(17,'Can add session',5,'add_session'),(18,'Can change session',5,'change_session'),(19,'Can delete session',5,'delete_session'),(20,'Can view session',5,'view_session'),(21,'Can add role',6,'add_role'),(22,'Can change role',6,'change_role'),(23,'Can delete role',6,'delete_role'),(24,'Can view role',6,'view_role'),(25,'Can add subject',7,'add_subject'),(26,'Can change subject',7,'change_subject'),(27,'Can delete subject',7,'delete_subject'),(28,'Can view subject',7,'view_subject'),(29,'Can add custom user',8,'add_customuser'),(30,'Can change custom user',8,'change_customuser'),(31,'Can delete custom user',8,'delete_customuser'),(32,'Can view custom user',8,'view_customuser'),(33,'Can add course',9,'add_course'),(34,'Can change course',9,'change_course'),(35,'Can delete course',9,'delete_course'),(36,'Can view course',9,'view_course'),(37,'Can add course subject',10,'add_coursesubject'),(38,'Can change course subject',10,'change_coursesubject'),(39,'Can delete course subject',10,'delete_coursesubject'),(40,'Can view course subject',10,'view_coursesubject'),(41,'Can add lesson',11,'add_lesson'),(42,'Can change lesson',11,'change_lesson'),(43,'Can delete lesson',11,'delete_lesson'),(44,'Can view lesson',11,'view_lesson'),(45,'Can add assignment',12,'add_assignment'),(46,'Can change assignment',12,'change_assignment'),(47,'Can delete assignment',12,'delete_assignment'),(48,'Can view assignment',12,'view_assignment'),(49,'Can add notification',13,'add_notification'),(50,'Can change notification',13,'change_notification'),(51,'Can delete notification',13,'delete_notification'),(52,'Can view notification',13,'view_notification'),(53,'Can add course feedback',14,'add_coursefeedback'),(54,'Can change course feedback',14,'change_coursefeedback'),(55,'Can delete course feedback',14,'delete_coursefeedback'),(56,'Can view course feedback',14,'view_coursefeedback'),(57,'Can add course student',15,'add_coursestudent'),(58,'Can change course student',15,'change_coursestudent'),(59,'Can delete course student',15,'delete_coursestudent'),(60,'Can view course student',15,'view_coursestudent'),(61,'Can add notification user',16,'add_notificationuser'),(62,'Can change notification user',16,'change_notificationuser'),(63,'Can delete notification user',16,'delete_notificationuser'),(64,'Can view notification user',16,'view_notificationuser'),(65,'Can add submission',17,'add_submission'),(66,'Can change submission',17,'change_submission'),(67,'Can delete submission',17,'delete_submission'),(68,'Can view submission',17,'view_submission'),(69,'Can add account',18,'add_account'),(70,'Can change account',18,'change_account'),(71,'Can delete account',18,'delete_account'),(72,'Can view account',18,'view_account'),(73,'Can add account',19,'add_account'),(74,'Can change account',19,'change_account'),(75,'Can delete account',19,'delete_account'),(76,'Can view account',19,'view_account'),(77,'Can add profile',20,'add_profile'),(78,'Can change profile',20,'change_profile'),(79,'Can delete profile',20,'delete_profile'),(80,'Can view profile',20,'view_profile');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_Users_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_Users_user_id` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(18,'authentication','account'),(4,'contenttypes','contenttype'),(19,'mainapp','account'),(12,'mainapp','assignment'),(9,'mainapp','course'),(14,'mainapp','coursefeedback'),(15,'mainapp','coursestudent'),(10,'mainapp','coursesubject'),(8,'mainapp','customuser'),(11,'mainapp','lesson'),(13,'mainapp','notification'),(16,'mainapp','notificationuser'),(20,'mainapp','profile'),(6,'mainapp','role'),(7,'mainapp','subject'),(17,'mainapp','submission'),(5,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2025-06-29 15:47:17.124559'),(2,'contenttypes','0002_remove_content_type_name','2025-06-29 15:47:17.254690'),(3,'auth','0001_initial','2025-06-29 15:47:17.728305'),(4,'auth','0002_alter_permission_name_max_length','2025-06-29 15:47:17.812407'),(5,'auth','0003_alter_user_email_max_length','2025-06-29 15:47:17.825043'),(6,'auth','0004_alter_user_username_opts','2025-06-29 15:47:17.837855'),(7,'auth','0005_alter_user_last_login_null','2025-06-29 15:47:17.851833'),(8,'auth','0006_require_contenttypes_0002','2025-06-29 15:47:17.859050'),(9,'auth','0007_alter_validators_add_error_messages','2025-06-29 15:47:17.870863'),(10,'auth','0008_alter_user_username_max_length','2025-06-29 15:47:17.884219'),(11,'auth','0009_alter_user_last_name_max_length','2025-06-29 15:47:17.896082'),(12,'auth','0010_alter_group_name_max_length','2025-06-29 15:47:17.927969'),(13,'auth','0011_update_proxy_permissions','2025-06-29 15:47:17.946774'),(14,'auth','0012_alter_user_first_name_max_length','2025-06-29 15:47:17.959443'),(15,'mainapp','0001_initial','2025-06-29 15:47:20.292919'),(16,'admin','0001_initial','2025-06-29 15:47:20.617819'),(17,'admin','0002_logentry_remove_auto_add','2025-06-29 15:47:20.636609'),(18,'admin','0003_logentry_add_action_flag_choices','2025-06-29 15:47:20.659157'),(19,'sessions','0001_initial','2025-06-29 15:47:20.728117'),(20,'authentication','0001_initial','2025-06-30 07:25:04.402402'),(21,'authentication','0002_account_is_teacher','2025-06-30 07:32:38.814503'),(22,'authentication','0003_delete_account','2025-06-30 10:36:07.413978'),(23,'mainapp','0002_account','2025-06-30 10:36:07.566259'),(24,'mainapp','0003_customuser_is_staff','2025-07-01 16:16:52.497653');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('1npsrbskwkt0sm6sbpjwm9a5ehpubhiz','.eJxVjEEOwiAQRe_C2pCOKAMu3XsGMgyDVA0kpV0Z726bdKHb_977bxVomUtYukxhTOqirDr8bpH4KXUD6UH13jS3Ok9j1Juid9r1rSV5XXf376BQL2sdkb31DiwhZAPAmVGSPdozE8GQ3ckAikcHK0NhSuIsk0FAGEwU9fkC4Yw31g:1uWlSq:oFWIBTkAwk82l6RDAkqArICvih7TgzFWhuqruN8g9b8','2025-07-16 00:36:40.079442'),('7adrgl6w0febr0zyyyjr9xwc8hx9j6z4','.eJxVjDsOwjAQRO_iGln4t44p6TmDtfZucADZUpxUiLuTSCmgnHlv5i0irkuJa-c5TiQuYhCn3y5hfnLdAT2w3pvMrS7zlOSuyIN2eWvEr-vh_h0U7GVbcx5CIpvAWMWonYfs2HoPI6ktWKWtJ0zGQ3BBKybwIySDxI7gTCg-X-HpN-s:1uYz6z:2QTAfefAe4XtwxB5TvMr3EU3caB61gwu561y-IFiI4o','2025-07-22 03:35:17.811387'),('aakv4xk4lugyb53dz1r1ig4v2iaoy06t','.eJxVjEEOwiAQRe_C2pCOKAMu3XsGMgyDVA0kpV0Z726bdKHb_977bxVomUtYukxhTOqirDr8bpH4KXUD6UH13jS3Ok9j1Juid9r1rSV5XXf376BQL2sdkb31DiwhZAPAmVGSPdozE8GQ3ckAikcHK0NhSuIsk0FAGEwU9fkC4Yw31g:1uWlQh:EKY4ycqR-48cEwY7HeJ1qYl5yF1RcztvtRtme6itjC4','2025-07-16 00:34:27.607878'),('bs58bbrso4vq3k34dspv71avwvq6z53s','.eJxVjDsOwjAQBe_iGln-JOssJT1nsHbtNQ4gR8qnQtwdIqWA9s3Me6lI21rjtsgcx6zOKqjT78aUHtJ2kO_UbpNOU1vnkfWu6IMu-jpleV4O9--g0lK_NaHjDEWCg8Ey9JIE3ZBIAK0H0zEAI5XSl96jC51HNACOnbG5cPLq_QHsHze6:1uWnTD:xYSihwmjXeceoEuNwO9rp8pr0NX_2Y_8JXz9yGYgUbc','2025-07-16 02:45:11.280385'),('dmppwxbwnkcd3xeovlfiaytu7v4twwws','.eJxVjDsOwjAQBe_iGln-JOssJT1nsHbtNQ4gR8qnQtwdIqWA9s3Me6lI21rjtsgcx6zOKqjT78aUHtJ2kO_UbpNOU1vnkfWu6IMu-jpleV4O9--g0lK_NaHjDEWCg8Ey9JIE3ZBIAK0H0zEAI5XSl96jC51HNACOnbG5cPLq_QHsHze6:1uWnmo:P_F3TCsc2zIRb9TjBEu_Bm4ICMl0PqWqsveKDN7waVY','2025-07-16 03:05:26.392132'),('ueg2yxj159jjlnn5ad8b7ms1tb3w5okf','.eJxVjMsOwiAQRf-FtSEML8Gle7-BwMxgq6YkpV0Z_92QdKHbe865b5Hyvk1p77ymmcRFgBGn37FkfPIyCD3ycm8S27Ktc5FDkQft8taIX9fD_TuYcp9GTQqzdlSK1zV6iMBgfeUKNhrkULzVOlpSWhnLnhEI1TkAmeCcRyc-XxJEN9E:1uZntN:hxC62s43nwRfqUK8VoNTBYQWO39AFyIPjFk0nKCDRoQ','2025-07-24 09:48:37.887820'),('wc7qgliqy4pds5khz2iqp65do5jdjhl1','.eJxVjEEOwiAQRe_C2pCOKAMu3XsGMgyDVA0kpV0Z726bdKHb_977bxVomUtYukxhTOqirDr8bpH4KXUD6UH13jS3Ok9j1Juid9r1rSV5XXf376BQL2sdkb31DiwhZAPAmVGSPdozE8GQ3ckAikcHK0NhSuIsk0FAGEwU9fkC4Yw31g:1uWcl1:VtWofXERinUHUn8ax2A7ugTAzPFLQ9QhMMzIX1Ibg1A','2025-07-15 15:18:51.355372'),('x798cro9ac0w2phxvm2clej9xd9wq9he','.eJxVjMEOwiAQRP-FsyHSwtL26N0vMIYs7FaqBpJCD8b477ZJD3qcmTfvLRwuNbql8OwmEoPoxOG38xgenLaB7phuWYac6jx5uSFyX4s8Z-LnaWf_BBFLXN8cut6T9tBqxdgYC8GwthZGUmvQqtGW0LcWetM3ignsCL5FYkNwJFylIWJ1cSo1zy8xXK6fLwpDPl4:1uXtba:eikxTZ87Xr-D7kRvxOO4TsrmcMbFBybMUtTpeNk24pc','2025-07-19 03:30:22.370193');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mainapp_account`
--

DROP TABLE IF EXISTS `mainapp_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mainapp_account` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `is_email_verified` tinyint(1) NOT NULL,
  `is_teacher` tinyint(1) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `mainapp_account_user_id_87afef7e_fk_Users_user_id` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mainapp_account`
--

LOCK TABLES `mainapp_account` WRITE;
/*!40000 ALTER TABLE `mainapp_account` DISABLE KEYS */;
INSERT INTO `mainapp_account` VALUES (1,1,0,2),(2,1,1,3),(3,1,0,4);
/*!40000 ALTER TABLE `mainapp_account` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-20 20:45:30
