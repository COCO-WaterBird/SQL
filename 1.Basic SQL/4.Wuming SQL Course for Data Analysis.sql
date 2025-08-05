create DATABASE chapter03;

use chapter03;

create table employee(
	EmployeeID CHAR(9),
	Name VARCHAR(50),
	Gender Enum('男','女'),
	Age Int UNSIGNED,
	JobPosition Enum('业务经理','开发人员','顾问'),
	Salary Decimal(10,2),
	JoinedAt DATETIME,
	Address text
);

-- 查看表结构
Desc employee;
-- 显示名为 chapter03 的数据库是如何创建的（包括创建语句和选项）,
show create DATABASE chapter03;
-- 查看表创建语句
show CREATE table employee;

CREATE TABLE `employee` (
  `EmployeeID` char(9) DEFAULT NULL,
  `Name` varchar(50) DEFAULT NULL,
  `Gender` enum('男','女') DEFAULT NULL,
  `Age` int unsigned DEFAULT NULL,
  `JobPosition` enum('业务经理','开发人员','顾问') DEFAULT NULL,
  `Salary` decimal(10,2) DEFAULT NULL,
  `JoinedAt` datetime DEFAULT NULL,
  `Address` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

;
-- 删除表
drop table employee;

