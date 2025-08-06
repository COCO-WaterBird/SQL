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

-- 全字段数据插入(插入值必须与表字段顺序完全一致)
INSERT INTO employee values('EMP-00001','张三','男',34,'业务经理',20000,'2000-01-15 15:00:00','上海市');

-- 全字段数据插入(插入值必须与表字段顺序完全一致)
INSERT INTO employee
values(
	'EMP-00001',
	'张三',
	'男',
	34,
	'业务经理',
	20000,
	'2000-01-15 15:00:00',
	'上海市'
	);

-- shift + TAB 回到初始位置

-- 部分字段插入
INSERT INTO employee(EmployeeID,Name,Gender,Age,JobPosition,Salary)
Values('EMP-00002','李四','女',28,'开发人员',15000);

-- 部分字段插入,颠倒顺序
INSERT INTO employee(EmployeeID,Gender,Name,Age,JobPosition,Salary)
Values('EMP-00002','女','李四',28,'开发人员',15000);

-- 全字段一次插入多行
INSERT 	into employee VALUES
	('EMP-00003','王五','男',25,'开发人员',10000,'2015-07-28 13:00:00','北京市'),
	('EMP-00004','赵六','女',32,'顾问',8000,'2019-11-12','杭州市'),
	('EMP-00005','孙七','女',29,'顾问',9000,'2021-10-13','南京市');

-- 部分字段一次插入多行
INSERT INTO employee(EmployeeID,Name,Gender,Age,JobPosition,Salary)
Values
	('EMP-00006','周八','男',28,'开发人员',20000),
	('EMP-00007','杨九','女',33,'顾问',7500);

-- 测试数据,验证数据类型对字段内容的限制
insert INTO employee VALUES
	('EMP-00008','郑十','男',34,'业务经理',23000,'2012-01-18','上海市');
insert INTO employee VALUES
	('EMP-000089','郑十','男',-34,'业务经理',23000,'2012-01-18','上海市');

drop table employee;


-- 数据表的约束规则
create table employee(
	EmployeeID CHAR(9)Not null,
	Name VARCHAR(50)Not null,
	Gender Enum('男','女'),
	Age Int UNSIGNED,
	JobPosition Enum('业务经理','开发人员','顾问')Not null,
	Salary Decimal(10,2)Not null,
	JoinedAt DATETIME,
	Address text
);

INSERT INTO employee values('EMP-00001','张三',null,null,'业务经理',20000,null,null);
INSERT INTO employee (EmployeeID,Name,JobPosition,Salary)values('EMP-00002','张四','业务经理',20000);

drop table employee;

-- 数据表的约束规则,使用默认值default
create table employee(
	EmployeeID CHAR(9)Not null,
	Name VARCHAR(50)Not null,
	Gender Enum('男','女'),
	Age Int UNSIGNED,
	JobPosition Enum('业务经理','开发人员','顾问')Not null,
	Salary Decimal(10,2)Not null Default 0,
	JoinedAt DATETIME,
	Address text
);

-- salary 没有写,就会自动填充0
INSERT INTO employee (EmployeeID,Name,JobPosition)values('EMP-00002','张四','业务经理');

drop table employee;

-- 数据表的约束规则,唯一性 unique

create table employee(
	EmployeeID CHAR(9)Not null Unique, #unique 也可以写在not null前
	Name VARCHAR(50)Not null,
	Gender Enum('男','女'),
	Age Int UNSIGNED,
	JobPosition Enum('业务经理','开发人员','顾问')Not null,
	Salary Decimal(10,2)Not null Default 0,
	JoinedAt DATETIME,
	Address text
);

INSERT INTO employee (EmployeeID,Name,JobPosition)values
	('EMP-00001','张三','业务经理'),
	('EMP-00002','李四','开发人员');

-- 数据表的约束规则,自动增长 auto_increment

drop table employee;

create table employee(
	EmployeeID Int Not null Unique Auto_increment,#这里就不能再写char(9)
	Name VARCHAR(50)Not null,
	Gender Enum('男','女'),
	Age Int UNSIGNED,
	JobPosition Enum('业务经理','开发人员','顾问')Not null,
	Salary Decimal(10,2)Not null Default 0,
	JoinedAt DATETIME,
	Address text
);

INSERT INTO employee (Name,JobPosition)values
	('张三','业务经理'),
	('李四','开发人员');

INSERT INTO employee (Name,JobPosition)values
	('王五','顾问');

DROP TABLE Employee;
-- 设置主键:非空且唯一
create table employee(
	EmployeeID Int Primary key Auto_increment,#直接写Primary key
	Name VARCHAR(50)Not null,
	Gender Enum('男','女'),
	Age Int UNSIGNED,
	JobPosition Enum('业务经理','开发人员','顾问')Not null,
	Salary Decimal(10,2)Not null Default 0,
	JoinedAt DATETIME,
	Address text
);

Desc employee;

create table employee(
	EmployeeID Int Auto_increment,
	Name VARCHAR(50)Not null,
	Gender Enum('男','女'),
	Age Int UNSIGNED,
	JobPosition Enum('业务经理','开发人员','顾问')Not null,
	Salary Decimal(10,2)Not null Default 0,
	JoinedAt DATETIME,
	Address text,
	PRIMARY KEY(EmployeeID)#直接写Primary key
);

主键插入数据,使用null占位,也可以直接忽略字段
insert into Employee(EmployeeID,Name,JobPosition) VALUES
(null,'张三','业务经理');

insert into Employee(Name,JobPosition) VALUES
('李四','开发人员'),
('王五','顾问');

-- 主键与外键
Drop table if exists employee;
Drop table if exists department;

create table if not exists Department(
					DeptID INT Primary Key AUTO_INCREMENT,
					DeptName VARCHAR(50) Not Null UNIQUE #DeptName VARCHAR(50) UNIQUE Not Null
);

Insert Into Department(DeptName) VALUES
('管理部'),('开发部'),('咨询部'); #代表3行数据

create table if not exists employee(
	EmployeeID Int Primary key Auto_increment,#直接写Primary key
	Name VARCHAR(50)Not null,
	Gender Enum('男','女'),
	Age Int UNSIGNED,
	JobPosition Enum('业务经理','开发人员','顾问')Not null,
	Salary Decimal(10,2)Not null Default 0,
	JoinedAt DATETIME,
	Address text,
	DeptID Int not null, #外键为非空
	Foreign Key(DeptID) REFERENCES Department(DeptID) #设置外键DeptID关联到Department(DeptID)
);

insert INTO Employee(Name,JobPosition,DeptID) VALUES
('张三','业务经理',1);

insert INTO Employee(Name,JobPosition,DeptID) VALUES
('李四','开发人员',2),
('王五','开发人员',2);


insert INTO Employee(Name,JobPosition,DeptID) VALUES
('赵六','顾问',3);

-- 二,SQL修改表结构

-- 修改表名称
alter  table Employee rename to Employees
-- 修改字段名称
alter table employees change column JoinedAt HireDate Datetime; #更改后的名称及类型