CREATE DATABASE IF NOT EXISTS student_management
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE student_management;

CREATE TABLE IF NOT EXISTS users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_users_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS students (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  student_no VARCHAR(30) NOT NULL COMMENT '学号',
  name VARCHAR(50) NOT NULL COMMENT '姓名',
  grade VARCHAR(30) NOT NULL COMMENT '年级',
  class_name VARCHAR(50) NOT NULL COMMENT '班级',
  gender ENUM('男', '女') NOT NULL COMMENT '性别',
  major VARCHAR(100) NOT NULL COMMENT '专业',
  phone VARCHAR(30) NULL COMMENT '电话',
  email VARCHAR(120) NULL COMMENT '邮箱',
  exam_score INT NULL COMMENT '高考分数',
  province VARCHAR(50) NULL COMMENT '生源地',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_students_student_no (student_no),
  KEY idx_students_name (name),
  KEY idx_students_major (major)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
