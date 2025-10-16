
CREATE DATABASE chapter02;
-- 查看创建的数据库
show CREATE DATABASE chapter02;

-- 指定数据库
use chapter02;
-- 查询使用的是哪个数据库
select DATABASE();
-- 查询数据库中有哪些表
show TABLES;

-- 删除数据库
DROP DATABASE chapter03;

create DATABASE chapter03;

use chapter03;


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

DESC employees;

-- 修改字段数据类型和约束
alter table employees modify column Name VARCHAR(30);
-- 添加字段
alter table employees add column birthday DATE;
-- 删除字段
alter table employees drop COLUMN birthday;
-- 删除主键
alter table employees drop PRIMARY key;
-- 去除auto_increment限制
alter table employees MODIFY COLUMN employeeID Int;
-- 添加主键
alter table employees add primary key (EmployeeID);
-- 重新添加auto_increment
alter table employees modify column employeeID int auto_increment;#auto_increment 这个影响的字段必须是主键

-- 删除外键
alter table Employees drop foreign key employees_ibfk_1;

-- 添加外键 : 右键,设计表,查看外键
alter table employees add FOREIGN key(DeptID) REFERENCES Department(DeptID);

-- 方法二:如何查看外键
show create table employees;
CREATE TABLE `employees` (
  `employeeID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(30) DEFAULT NULL,
  `Gender` enum('男','女') DEFAULT NULL,
  `Age` int unsigned DEFAULT NULL,
  `JobPosition` enum('业务经理','开发人员','顾问') NOT NULL,
  `Salary` decimal(10,2) NOT NULL DEFAULT '0.00',
  `HireDate` datetime DEFAULT NULL,
  `Address` text,
  `DeptID` int NOT NULL,
  `birthday` date DEFAULT NULL,
  PRIMARY KEY (`employeeID`),
  KEY `DeptID` (`DeptID`),
  CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`DeptID`) REFERENCES `Department` (`DeptID`) #外键在这里
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


第四章 SQL操作数据

CREATE DATABASE chapter04;

USE chapter04;

DROP TABLE IF EXISTS Employee;

CREATE TABLE IF NOT EXISTS Employee (
	EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
	Name VARCHAR ( 50 ) NOT NULL,
	Gender ENUM ( '男', '女' ),
	Age INT UNSIGNED,
	JobPosition ENUM ( '业务经理', '开发人员', '顾问' ) NOT NULL,
	Salary DECIMAL ( 10, 2 ) NOT NULL DEFAULT 0,
	JoinedAt DATE
);

INSERT INTO Employee(Name,Gender,Age,JobPosition,Salary,JoinedAt)
VALUES
('张吉','男',29,'开发人员',19000,'2014-05-21'),
('林国','女',29,'顾问',14400,'2015-06-15'),
('陈家莲','女',30,'业务经理',23800,'2021-04-07');

-- 查询全字段
select * from chapter04.employee;
-- 先指定数据库
use chapter04;
select * from Employee;

select Name,Salary From Employee;
select Employee.Name, Employee.salary From Employee;

-- 为字段取名字
Select Name as "姓名", Salary as "月薪" From Employee;

-- 根据主键取某一条记录
Select
	EmployeeID as '工号',
	Name as "姓名",
	Age as '年龄',
	Salary as '月薪'
From employee
WHERE employeeID = 10;


-- 修改全部数据
Update Employee SET Salary = Salary + 1000;

-- 修改指定数据
Update Employee Set salary = Salary + 1000,Age = Age + 10 WHere EmployeeID = 10;

-- 删除全部数据
delete from Employee;

select * from Employee;
-- 删除一条数据
delete from employee Where EmployeeID = 10;

-- 数据拼接(CONCAT(str1,str2,...) with Seperator
select concat(Name,Gender,Age) From Employee;
select concat(Name,',',Gender,',',Age) AS '员工基本信息' From Employee;
select CONCAT_WS(',',Name,Gender,Age,JobPosition) AS '员工基本信息' From Employee;

-- 数据排序
select EmployeeID, Name, Salary From employee Order by salary asc;
select EmployeeID, Name, Salary, Age From employee Order by salary desc, Age asc; #先排序salary, 然后再排AGE

-- 限制行数
select EmployeeID, Name, Salary, Age From employee Order by salary desc, Age asc Limit 10;
-- 第一个数字:从某条数据开始,第二个数字表示展示多少行
select EmployeeID, Name, Salary, Age From employee Order by salary desc, Age asc Limit 1, 10;

-- 数据的去重
select Name, Gender, Age From Employee;
select distinct Gender From employee;
select distinct Age From employee Order by Age;

-- 比较运算符
select* from employee where employeeID = 10;
select* from employee where Age != 33;
select* from employee where Age <> 33;

-- 逻辑运算符
 select* from employee where Age >= 30 And salary > 20000;

--  范围查询(IN, Not In)( Between and)
select* from employee where Age in(32, 33, 34);
select* from employee where Age Not in(32, 33, 34);
select* from employee where Age = 32 OR age= 33 or Age = 34;

select* from employee where Age between 32 and 34;

-- 空值查询(is null)
select * from employee where JoinedAt is null;
select * from employee where JoinedAt is not null;

-- 模糊查询 % 任意多个字符,单个字符_
select * from employee Where Name Like'杨%';
select * from employee Where Name Like'杨_';
select * from employee Where Name Like'%国%';
select * from employee Where Name Like'__';

-- 聚合函数
-- 分组查询
-- 统计各个岗位的平均薪资
select JObposition,avg(salary) from employee where EmployeeID <= 10 GROUP BY JObposition;
select JObposition,avg(age) from employee where EmployeeID <= 10 GROUP BY JObposition;

-- where针对表数据进行过滤,having针对分组后的结果数据进行过滤;
select Gender,count(*) from employee Group by Gender Having Gender = '男';
select Gender,count(*) from employee where Gender = '男';

-- 查询语句的执行顺序
SELECT
age, round(avg(salary),0) as avg_salary
From employee
Where JobPosition = '开发人员'
Group by age
having avg_salary >= 21000
Order by Age DESC
Limit 3;

SELECT * From employee Where JobPosition = '开发人员';
SELECT round(avg(salary),0) as avg_salary From employee Where JobPosition = '开发人员' Group by Age;
SELECT round(avg(salary),0) as avg_salary From employee Where JobPosition = '开发人员' Group by Age having avg_salary >= 21000;
SELECT age,round(avg(salary),0) as avg_salary From employee Where JobPosition = '开发人员' Group by Age having avg_salary >= 21000;
SELECT age,round(avg(salary),0) as avg_salary From employee Where JobPosition = '开发人员' Group by Age having avg_salary >= 21000 Order by Age DESC;
SELECT age,round(avg(salary),0) as avg_salary From employee Where JobPosition = '开发人员' Group by Age having avg_salary >= 21000 Order by Age DESC Limit 3;

-- group_concat 函数
SELECT Age,Group_concat(Name) From employee Where JobPosition = '开发人员' Group by Age;

-- WITH ROLLUP
select jobposition, Gender, count(*), sum(salary) From employee Group by JobPosition, Gender Order by Jobposition, Gender;
select jobposition, count(*), sum(salary) From employee Group by JobPosition Order by Jobposition;
select count(*), sum(salary) From employee;

select jobposition, Gender, count(*), sum(salary) From employee Group by JobPosition, Gender with ROLLUP;

-- 九、SQL常用函数

-- abs 返回绝对值
select abs(100);
select abs(-100);
select abs(salary - 25000) From Employee;
-- pow 幂运算
select pow(2,3); #二的3次方

-- 判断正负数
select sign(1);
select sign (0);
SELECT sign (-1);
select Name,sign(salary - 25000) as sign from Employee order by sign desc;

-- rand, 返回一个从0到1的随机值

-- 查询全字段
select * from chapter04.employee;
-- 先指定数据库
use chapter04;
select * from Employee;

select Name,Salary From Employee;
select Employee.Name, Employee.salary From Employee;

-- 为字段取名字
Select Name as "姓名", Salary as "月薪" From Employee;

-- 根据主键取某一条记录
Select
	EmployeeID as '工号',
	Name as "姓名",
	Age as '年龄',
	Salary as '月薪'
From employee
WHERE employeeID = 10;

-- 修改全部数据
Update Employee SET Salary = Salary + 1000;

-- 修改指定数据
Update Employee Set salary = Salary + 1000,Age = Age + 10 WHere EmployeeID = 10;

-- 删除全部数据
delete from Employee;

select * from Employee;
-- 删除一条数据
delete from employee Where EmployeeID = 10;

-- 数据拼接(CONCAT(str1,str2,...) with Seperator
select concat(Name,Gender,Age) From Employee;
select concat(Name,',',Gender,',',Age) AS '员工基本信息' From Employee;
select CONCAT_WS(',',Name,Gender,Age,JobPosition) AS '员工基本信息' From Employee;

-- 数据排序
select EmployeeID, Name, Salary From employee Order by salary asc;
select EmployeeID, Name, Salary, Age From employee Order by salary desc, Age asc; #先排序salary, 然后再排AGE

-- 限制行数
select EmployeeID, Name, Salary, Age From employee Order by salary desc, Age asc Limit 10;
-- 第一个数字:从某条数据开始,第二个数字表示展示多少行
select EmployeeID, Name, Salary, Age From employee Order by salary desc, Age asc Limit 1, 10;

-- 数据的去重
select Name, Gender, Age From Employee;
select distinct Gender From employee;
select distinct Age From employee Order by Age;

-- 比较运算符
select* from employee where employeeID = 10;
select* from employee where Age != 33;
select* from employee where Age <> 33;

-- 逻辑运算符
 select* from employee where Age >= 30 And salary > 20000;

--  范围查询(IN, Not In)( Between and)
select* from employee where Age in(32, 33, 34);
select* from employee where Age Not in(32, 33, 34);
select* from employee where Age = 32 OR age= 33 or Age = 34;

select* from employee where Age between 32 and 34;

-- 空值查询(is null)
select * from employee where JoinedAt is null;
select * from employee where JoinedAt is not null;

-- 模糊查询 % 任意多个字符,单个字符_
select * from employee Where Name Like'杨%';
select * from employee Where Name Like'杨_';
select * from employee Where Name Like'%国%';
select * from employee Where Name Like'__';

-- 聚合函数
-- 分组查询
-- 统计各个岗位的平均薪资
select JObposition,avg(salary) from employee where EmployeeID <= 10 GROUP BY JObposition;
select JObposition,avg(age) from employee where EmployeeID <= 10 GROUP BY JObposition;

-- where针对表数据进行过滤,having针对分组后的结果数据进行过滤;
select Gender,count(*) from employee Group by Gender Having Gender = '男';
select Gender,count(*) from employee where Gender = '男';

-- 查询语句的执行顺序
SELECT
age, round(avg(salary),0) as avg_salary
From employee
Where JobPosition = '开发人员'
Group by age
having avg_salary >= 21000
Order by Age DESC
Limit 3;

SELECT * From employee Where JobPosition = '开发人员';
SELECT round(avg(salary),0) as avg_salary From employee Where JobPosition = '开发人员' Group by Age;
SELECT round(avg(salary),0) as avg_salary From employee Where JobPosition = '开发人员' Group by Age having avg_salary >= 21000;
SELECT age,round(avg(salary),0) as avg_salary From employee Where JobPosition = '开发人员' Group by Age having avg_salary >= 21000;
SELECT age,round(avg(salary),0) as avg_salary From employee Where JobPosition = '开发人员' Group by Age having avg_salary >= 21000 Order by Age DESC;
SELECT age,round(avg(salary),0) as avg_salary From employee Where JobPosition = '开发人员' Group by Age having avg_salary >= 21000 Order by Age DESC Limit 3;

-- group_concat 函数
SELECT Age,Group_concat(Name) From employee Where JobPosition = '开发人员' Group by Age;

-- WITH ROLLUP
select jobposition, Gender, count(*), sum(salary) From employee Group by JobPosition, Gender Order by Jobposition, Gender;
select jobposition, count(*), sum(salary) From employee Group by JobPosition Order by Jobposition;
select count(*), sum(salary) From employee;

select jobposition, Gender, count(*), sum(salary) From employee Group by JobPosition, Gender with ROLLUP;

-- 九、SQL常用函数

-- abs 返回绝对值
select abs(100);
select abs(-100);
select abs(salary - 25000) From Employee;
-- pow 幂运算
select pow(2,3); #二的3次方

-- 判断正负数
select sign(1);
select sign (0);
SELECT sign (-1);
select Name,sign(salary - 25000) as sign from Employee order by sign desc;

-- rand, 返回一个从0到1的随机值
select rand();
SELECT * From employee ORDER BY rand();

-- ceil 大于等于指定值的最小整数值
-- FLOOR(X)返回小于等于指定值的最小大整数值
-- ROUND(X)返回指定小数点的四舍五入值
-- TRUNCATE(X,D)返回指定小数点位数的截断值
-- FORMAT(X,D)小数点后面保留多少位,前面的3位做一个分隔

-- sql常用文本函数

CREATE TABLE STRINGTEST (
	ENNAME VARCHAR(50),
	CHNAME VARCHAR(50)
);

INSERT INTO STRINGTEST VALUES
('  Arnie  ', '  阿尼'),
('   Kalyna   ', '  卡丽娜  '),
('   Bennie  ', ' 本尼  '),
('  Gaiane  ', '  盖恩 '),
('   tomasz  ', ' 托马兹  ');

select * from stringtest;

-- ltrim, rtrim,trim 文本空格处理
select enname, ltrim(enname) from stringtest;# 清除左侧空格
select enname, rtrim(enname) from stringtest;# 清除右侧空格
select enname, ltrim(rtrim(enname))from stringtest;# 同时清除左右两侧
select enname, trim(enname)from stringtest;# 同时清除左右两侧

-- 针对查询结果建表
drop table stringtest2;

create table stringtest2
select trim(enname) as Enname,trim(chname) as Chname from stringtest;

-- CONCAT(str1,str2,...) CONCAT_ws,文本连接
select concat(trim(enname),'-',trim(chname)) from stringtest;

-- replace 文本替换,区分大小写
select Enname,Replace(Enname,'A','B') From stringtest2; #这里区分大小写

-- left,right,substring 文本截取
select Enname,Left(Enname,2),Right(Enname,2) From stringtest2;
select Enname,substring(Enname,2,3) From stringtest2;#从2开始截取3个

-- LENGTH(str)文本计数
select enname,length(enname) From stringtest2;

-- instr,文本查找
select enname,instr(enname,'a') From stringtest2;#不在乎大小写

-- 想提取包含字符右侧的文本内容
-- 需要先定位a字符首次出现的位置
select instr(enname,'a') from stringtest2;
-- 然后截取a右侧的文本内容
select enname,substring(enname,instr(enname,'a'),length(enname)-instr(enname,'a')+1) from stringtest2; #6-2+1

-- upper,lower,文本
select enname,upper(enname),lower(enname) from stringtest2;

-- SQL常用日期时间函数
-- 当前日期
select curdate();
select curtime();
select now(); #当前日期和时间

-- 获取年份,季度,月份,
-- date、year,quarter,month,day,WEEKOFYEAR(date),
select date(now());
select year(NOW());
select quarter(NOW());
select month(now());
select day(NOW());
select WEEKOFYEAR(NOW());

-- TIME、hour,minute,second
select time(now());
select hour(now());
select minute(now());
select second(now());

-- extarct
select extract(year from now());
select extract(quarter from now());
select extract(month from now());
select extract(week from now());

-- 日期和时间格式设置
select now();
select DATE_FORMAT(now(),'%Y年%m月%d日%m分%s秒');
select DATE_FORMAT(now(),'%Y%m%d');
select Name,JOinedAt,DATE_FORMAT(JoinedAt,'%Y年%m月%d日') From Employee;
select Name,extract(year from JOinedAt) from employee;

-- 日期计算,date_add,datediff
select now(),DATE_ADD(now(),INTERVAL 3 year);
select date(now()),date(DATE_ADD(now(),INTERVAL 3 year));
select date(now()),date(DATE_ADD(now(),INTERVAL -3 day));

select DATEDIFF('2022-8-11','2022-5-17');#左侧比右侧大

-- SQL空值函数
-- isnull,判断数据是否为空


CREATE TABLE Products(
	Pid INT PRIMARY KEY AUTO_INCREMENT,
	ProductName VARCHAR(50) NOT NULL,
	UnitPrice Decimal(10,2) NOT NULL,
	UnitsInStock INT,
	UnitsOnOrder INT
);

INSERT INTO Products VALUES
(NULL, '苹果手机', 9800, 100, 20),
(NULL, '华为手机', 8800, 200, 40),
(NULL, '小米手机', 7000, 200, NULL);

select productName,ISnull(UnitsInstock),Isnull(UnitsOnOrder) from products;

-- if NULL 如果数据为空,返回替换值
select productName,UnitPrice * (IFnull(UnitsInstock,0) + Ifnull(UnitsOnOrder,0)) from products;

-- 数据类型转换cast 和 coalesce 函数返回数据列表中第一个非空的值
desc employee;
select Name,cast(JoinedAt as datetime) FRom Employee;
select  concat(Name,'_',Salary) from employee;

select  concat(Name,'_',cast(Salary as decimal(10,0))) from employee;
select  concat(Name,'_',cast(Salary as char(5))) from employee;#采用固定长度:5位字符

select coalesce(null,null,1);

alter table Products add column Orderamount Decimal(10,2);
UPDATE Products set Orderamount = UnitPrice * UnitsOnOrder where pid = 1;

select ProductName, OrderAmount from Products;
-- 有数据展示
-- 如果为null,再次计算
-- 如果还是null,给出提示,无法计算
select ProductName, coalesce(OrderAmount,UnitPrice * UnitsOnOrder,'无法计算') from Products;

-- if函数(条件,结果1,结果2)
select if (5>2,1,2);
-- 基于员工工资,划分等级,低于20000元,是低薪资级别,否则,设置为高薪资级别
select * ,if (salary < 20000,'low','high') as SAL_Grade from employee;
-- 基于员工工资,划分等级,低于20000元,是低薪资级别,大于20000小于25000, 是中等薪资级别, 大于25000 是高等级别, 否则,设置为高薪资级别
select * ,if (salary < 20000,'low',if (salary <= 25000,"Medium",'High') )as SAL_Grade from employee;

-- 统计低中高人员数量
select count(*) ,if (salary < 20000,'low',if (salary <= 25000,"Medium",'High') )as SAL_Grade from employee group by sal_grade;

-- case函数
-- 方式一
-- 基于员工工资,划分等级,低于20000元,是低薪资级别,否则,设置为高薪资级别
select * ,
(CASE
	WHEN salary < 20000 THEN 'Low'
	ELSE
		'High'
END) AS sal_Grade
from employee
ORDER BY sal_Grade;

-- 基于员工工资,划分等级,低于20000元,是低薪资级别,大于20000小于25000, 是中等薪资级别, 大于25000 是高等级别, 否则,设置为高薪资级别
select * ,
(CASE
	WHEN salary < 20000 THEN 'Low'
	WHEN salary <= 25000 THEN 'Medium'
	ELSE
		'High'
END) AS sal_Grade
from employee
ORDER BY sal_Grade;

-- 统计低中高人员数量
select count(*) ,
(CASE
	WHEN salary < 20000 THEN 'Low'
	WHEN salary <= 25000 THEN 'Medium'
	ELSE
		'High'
END) AS sal_Grade
from employee
Group BY sal_Grade;

-- employee表,展示时加一个DepartmentName字段
select *,
(CASE Jobposition, #基于岗位名称确定部门
	WHEN '开发人员' THEN '开发部'
  WHEN '顾问' THEN '咨询部'
	WHEN '业务经理' THEN '管理部'
	ELSE '其他部门'
		其他部门
END) as Department
From Employee
ORDER BY DepartmentName;

-- CASE 转置应用:匹配的上填充,匹配不上填充0,然后汇总求和

-- 先创建表
DROP TABLE IF EXISTS OrderInfo;

CREATE TABLE OrderInfo(
	CustomerName VARCHAR(50),
	Month VARCHAR(10),
	Amount INT
);

INSERT INTO OrderInfo VALUES('张三','1月',50),('张三','2月',100),('张三','3月',200),
('李四','1月',70),('李四','2月',100),('李四','3月',150),
('王五','1月',200),('王五','2月',300),('王五','3月',800);

SELECT * FROM OrderInfo;

-- case 过渡处理

select CustomerName as Customer, #CustomerName不变
(CASE WHEN Month = '1月' THEN Amount Else 0 END) as '1月', #一条一条数据处理 1月分别匹配这3行判断语句
(CASE WHEN Month = '2月' THEN Amount Else 0 END) as '2月',
(CASE WHEN Month = '3月' THEN Amount Else 0 END) as '3月'
FROM OrderInfo;

-- 分组
select CustomerName as Customer, #CustomerName不变
sum(CASE WHEN Month = '1月' THEN Amount Else 0 END) as '1月', #一条一条数据处理 1月分别匹配这3行判断语句
sum(CASE WHEN Month = '2月' THEN Amount Else 0 END) as '2月',
sum(CASE WHEN Month = '3月' THEN Amount Else 0 END) as '3月'
FROM OrderInfo
GROUP BY Customer;

-- 多表连接

DROP DATABASE IF EXISTS chapter11;

-- 创建数据库
CREATE DATABASE IF NOT EXISTS chapter11;

USE chapter11;

DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Manager;
DROP TABLE IF EXISTS Department;

-- 部门表
CREATE TABLE IF NOT EXISTS Department(
	DeptID INT PRIMARY KEY AUTO_INCREMENT,
	DeptName VARCHAR(50) NOT NULL
);

INSERT INTO Department(DeptName) VALUES('总部'),('开发部'),('咨询部'),('财务部'),('行政部'),('人力部');

-- 经理表
CREATE TABLE IF NOT EXISTS Manager(
	ManagerID INT PRIMARY KEY AUTO_INCREMENT,
	ManagerName VARCHAR(50) NOT NULL,
	DeptID INT,
	FOREIGN KEY(DeptID) REFERENCES Department(DeptID) #外键 关联到Department(DeptID)
);

INSERT INTO Manager VALUES(NULL,'黄文隆',1),(NULL,'张吉',2),(NULL,'林玟',3),(NULL,'林雅',3),(NULL,'江奕',3),(NULL,'刘柏',4),(NULL,'吉茹',4);

-- 员工表
CREATE TABLE IF NOT EXISTS Employee(

-- Cross JOin
-- 查询员工信息以及所在的部门名称 78
select e.EmpName, d.DeptName
From Employee AS e, Department as d;

-- 什么是笛卡尔积?:每两个数据进行一个关联

select e.EmpName, d.DeptName
From Employee AS e cross JOIN Department as d;#78行数据

select count(*) from Employee; #13
select count(*) from Department; #6

-- Inner Join 内连接:只展示交叉的部分
select e.EmpName, d.DeptName
From Employee AS e
Inner JOIN Department as d
On e.DeptID = d.DeptID; #值相等作为条件, 10条数据

select e.*, d.DeptName # e的所有数据,也是只有10行
From Employee AS e
Inner JOIN Department as d
On e.DeptID = d.DeptID; #值相等作为条件, 10条数据

select e.*, d.DeptName # e的所有数据,也是只有10行
From Employee AS e
JOIN Department as d # Inner可以省略掉
On e.DeptID = d.DeptID; #值相等作为条件, 10条数据

select * from Employee; #有3行数据DeptID是null

-- Left JOIN:DeptID即使匹配不上,也展示出来,即上面未能展示的3行数据, 右侧表:只展示与左侧交叉的信息, 也叫Left outer join
select e.*, d.DeptName # e的所有数据,也是只有10行
From Employee AS e
Left JOIN Department as d
On e.DeptID = d.DeptID;

-- Right JOIN:右侧全部展示出来,财务部,行政部,人力部也展示,左侧只展示交叉部分, 也叫Right outer join
select e.*, d.DeptName # e的所有数据,也是只有10行
From Employee AS e
Right JOIN Department as d
On e.DeptID = d.DeptID;

-- Full JOIN:全连接, Mysql没有这个功能
select e.*, d.DeptName # e的所有数据,也是只有10行
From Employee AS e
Full JOIN Department as d
On e.DeptID = d.DeptID;

-- Union 3个数据全部合并到一起,并把重复的剔除掉
(select e.*, d.DeptName # e的所有数据,也是只有10行
From Employee AS e
Inner JOIN Department as d
On e.DeptID = d.DeptID)
UNION
(select e.*, d.DeptName # e的所有数据,也是只有10行
From Employee AS e
Left JOIN Department as d
On e.DeptID = d.DeptID)
UNION
(select e.*, d.DeptName # e的所有数据,也是只有10行
From Employee AS e
Right JOIN Department as d
On e.DeptID = d.DeptID)

-- Natural Join 自然连接,等同于inner join, 他自己找相同字段部分
select e.EmpName, d.DeptName
From Employee AS e
Natural JOIN Department as d;

select e.EmpName, d.DeptName
From Employee AS e
Inner JOIN Department as d
On e.DeptID = d.DeptID;

alter table Department Rename Column DeptID to DID;
-- 修改字段名后就会出现笛卡尔积
select e.EmpName, d.DeptName
From Employee AS e
Natural JOIN Department as d;

-- self join 自连接

DROP TABLE IF EXISTS EmployeeVar;
DROP TABLE IF EXISTS DepartmentVar;

-- 部门表
CREATE TABLE IF NOT EXISTS DepartmentVar (
	DeptID INT PRIMARY KEY AUTO_INCREMENT,
	DeptName VARCHAR(50) NOT NULL
);

INSERT INTO DepartmentVar(DeptName) VALUES('总部'),('开发部'),('咨询部'),('财务部'),('行政部'),('人力部');

alter table Department Rename Column DID to DeptID;

-- 员工表
CREATE TABLE IF NOT EXISTS EmployeeVar (
	EmpID INT PRIMARY KEY AUTO_INCREMENT,
	EmpName VARCHAR(50) NOT NULL UNIQUE,
	JobPosition ENUM('CEO','开发人员','顾问','经理','HR','会计','行政') NOT NULL,
	Salary DECIMAL(10,2) NOT NULL,
	DeptID INT,
	ManagerID INT,
	FOREIGN KEY(DeptID) REFERENCES Department(DeptID),
	FOREIGN KEY(ManagerID) REFERENCES EmployeeVar(EmpID)
);

INSERT INTO EmployeeVar VALUES
(NULL,'黄文隆','CEO',100000,1,NULL),
(NULL,'张吉','经理',30000,2,1),
(NULL,'黄文','行政',19000,NULL,NULL);




	EmpID INT PRIMARY KEY AUTO_INCREMENT,
	EmpName VARCHAR(50) NOT NULL UNIQUE,
	JobPosition ENUM('CEO','开发人员','顾问','经理','HR','会计','行政') NOT NULL,
	Salary DECIMAL(10,2) NOT NULL,
	DeptID INT,
	ManagerID INT,
	FOREIGN KEY(DeptID) REFERENCES Department(DeptID),#外键 关联到Department(DeptID)
	FOREIGN KEY(ManagerID) REFERENCES Manager(ManagerID)#外键 关联到Manager(ManagerID)

INSERT INTO Employee VALUES
(NULL,'黄文隆','CEO',100000,1,NULL),
(NULL,'张吉','经理',30000,2,1),


-- self Join 自连接 查看员工的姓名以及上级的姓名
select e1.EmpName as '员工姓名', e2.EmpName as '上级姓名'
from employeeVAr AS e1
Inner Join
EmployeeVar AS e2
On e1.ManagerID = e2.EmpID;

-- 为什么要使用自查询
-- 查询高于全体员工平均工资的员工信息
-- SELECT * from Employee Where salary > '平均工资'
-- 查询全体员工的平均工资
-- 查询高于平均工资的员工

select avg(salary) from employee where Jobposition != 'CEO';
select * from employee where salary > 20916 AND Jobposition != 'CEO';

select * from employee where salary > (
select avg(salary) from employee where Jobposition != 'CEO') AND Jobposition != 'CEO';

select *
from employee
where salary > (
								select avg(salary)
								from employee
								where Jobposition != 'CEO'
								)
			AND Jobposition != 'CEO';

-- 关联查询的类型-- cross JOIN
-- Cross JOin
-- 查询员工信息以及所在的部门名称 78
select e.EmpName, d.DeptName
From Employee AS e, Department as d;

-- 什么是笛卡尔积?:每两个数据进行一个关联

select e.EmpName, d.DeptName
From Employee AS e cross JOIN Department as d;#78行数据

select count(*) from Employee; #13
select count(*) from Department; #6

-- Inner Join 内连接:只展示交叉的部分
select e.EmpName, d.DeptName
From Employee AS e
Inner JOIN Department as d
On e.DeptID = d.DeptID; #值相等作为条件, 10条数据

select e.*, d.DeptName # e的所有数据,也是只有10行
From Employee AS e
Inner JOIN Department as d
On e.DeptID = d.DeptID; #值相等作为条件, 10条数据

select e.*, d.DeptName # e的所有数据,也是只有10行
From Employee AS e
JOIN Department as d # Inner可以省略掉
On e.DeptID = d.DeptID; #值相等作为条件, 10条数据

select * from Employee; #有3行数据DeptID是null

-- Left JOIN:DeptID即使匹配不上,也展示出来,即上面未能展示的3行数据, 右侧表:只展示与左侧交叉的信息, 也叫Left outer join
select e.*, d.DeptName # e的所有数据,也是只有10行
From Employee AS e
Left JOIN Department as d
On e.DeptID = d.DeptID;

-- Right JOIN:右侧全部展示出来,财务部,行政部,人力部也展示,左侧只展示交叉部分, 也叫Right outer join
select e.*, d.DeptName # e的所有数据,也是只有10行
From Employee AS e
Right JOIN Department as d
On e.DeptID = d.DeptID;

-- Full JOIN:全连接, Mysql没有这个功能
select e.*, d.DeptName # e的所有数据,也是只有10行
From Employee AS e
Full JOIN Department as d
On e.DeptID = d.DeptID;

-- Union 3个数据全部合并到一起,并把重复的剔除掉
(select e.*, d.DeptName # e的所有数据,也是只有10行
From Employee AS e
Inner JOIN Department as d
On e.DeptID = d.DeptID)
UNION
(select e.*, d.DeptName # e的所有数据,也是只有10行
From Employee AS e
Left JOIN Department as d
On e.DeptID = d.DeptID)
UNION
(select e.*, d.DeptName # e的所有数据,也是只有10行
From Employee AS e
Right JOIN Department as d
On e.DeptID = d.DeptID)

-- Natural Join 自然连接,等同于inner join, 他自己找相同字段部分
select e.EmpName, d.DeptName
From Employee AS e
Natural JOIN Department as d;

select e.EmpName, d.DeptName
From Employee AS e
Inner JOIN Department as d
On e.DeptID = d.DeptID;

alter table Department Rename Column DeptID to DID;
-- 修改字段名后就会出现笛卡尔积
select e.EmpName, d.DeptName
From Employee AS e
Natural JOIN Department as d;


ALTER DATABASE mySCHOOL READ ONLY = 0
-- 将数据库设置为可读写模式
-- 参数解释
-- READ ONLY = 0 - 关闭只读模式（可以写入）
-- READ ONLY = 1 - 开启只读模式（只能读取）

-- self join 自连接

DROP TABLE IF EXISTS EmployeeVar;
DROP TABLE IF EXISTS DepartmentVar;

-- 部门表
CREATE TABLE IF NOT EXISTS DepartmentVar (
	DeptID INT PRIMARY KEY AUTO_INCREMENT,
	DeptName VARCHAR(50) NOT NULL
);

INSERT INTO DepartmentVar(DeptName) VALUES('总部'),('开发部'),('咨询部'),('财务部'),('行政部'),('人力部');

alter table Department Rename Column DID to DeptID;

-- 员工表
CREATE TABLE IF NOT EXISTS EmployeeVar (
	EmpID INT PRIMARY KEY AUTO_INCREMENT,
	EmpName VARCHAR(50) NOT NULL UNIQUE,
	JobPosition ENUM('CEO','开发人员','顾问','经理','HR','会计','行政') NOT NULL,
	Salary DECIMAL(10,2) NOT NULL,
	DeptID INT,
	ManagerID INT,
	FOREIGN KEY(DeptID) REFERENCES Department(DeptID),
	FOREIGN KEY(ManagerID) REFERENCES EmployeeVar(EmpID)
);





	EmpID INT PRIMARY KEY AUTO_INCREMENT,
	EmpName VARCHAR(50) NOT NULL UNIQUE,
	JobPosition ENUM('CEO','开发人员','顾问','经理','HR','会计','行政') NOT NULL,
	Salary DECIMAL(10,2) NOT NULL,
	DeptID INT,
	ManagerID INT,
	FOREIGN KEY(DeptID) REFERENCES Department(DeptID),#外键 关联到Department(DeptID)
	FOREIGN KEY(ManagerID) REFERENCES Manager(ManagerID)#外键 关联到Manager(ManagerID)

INSERT INTO Employee VALUES
(NULL,'黄文隆','CEO',100000,1,NULL),
(NULL,'张吉','经理',30000,2,1)

--

-- self Join 自连接 查看员工的姓名以及上级的姓名
select e1.EmpName as '员工姓名', e2.EmpName as '上级姓名'
from employeeVAr AS e1
Inner Join
EmployeeVar AS e2
On e1.ManagerID = e2.EmpID;

-- 为什么要使用自查询
-- 查询高于全体员工平均工资的员工信息
-- SELECT * from Employee Where salary > '平均工资'
-- 查询全体员工的平均工资
-- 查询高于平均工资的员工

select avg(salary) from employee where Jobposition != 'CEO';
select * from employee where salary > 20916 AND Jobposition != 'CEO';

select * from employee where salary > (
select avg(salary) from employee where Jobposition != 'CEO') AND Jobposition != 'CEO';

select *
from employee
where salary > (
								select avg(salary) 单行单列的子查询
								from employee
								where Jobposition != 'CEO'
								)
			AND Jobposition != 'CEO';

-- 子查询的类型

作为单独一张表
select avg(salary) 单行单列的子查询
from employee
where Jobposition != 'CEO'

select *
from employee as e
Inner JOIN
(
	select avg(salary) as Avgsalary
	from employee
	where Jobposition != 'CEO'
	) As TEMP
On e.salary > temp.Avgsalary
Where e.JobPosition != 'CEO';


-- 字符分开:从 Title 列里提取 冒号前 的部分（电影系列名）和 冒号后 的部分（子标题）。
-- Title 字段 “Transformers: Age of Extinction” 里提取出
SPLIT_PART(title, ':', 1) AS name,
SPLIT_PART(title, ':', 2) AS series

-- 日期转化
TO_DATE(date, 'DD-MON-YYYY') AS date,
-- 提取小时
SELECT
       EXTRACT(HOUR FROM Start_Time)::NUMERIC AS Start_Hour,
       EXTRACT(HOUR FROM End_Time)::NUMERIC AS End_Hour
FROM bike_trips;

--Based on the exercise and your min/max values (2315 to 3072), you are asked to generate bins of size 50 using generate_series().
SELECT generate_series(2200, 3100, 50) AS lower,
       generate_series(2250, 3150, 50) AS upper;

-- MySQL事务控制
-- 1. COMMIT（提交）提交事务，将所有更改永久保存到数据库
START TRANSACTION;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
COMMIT;  -- 永久保存更改

-- 2.ROLLBACK（回滚）撤销事务，取消所有未提交的更改, 将数据恢复到事务开始前的状态

START TRANSACTION;
DELETE FROM users WHERE id = 5;
ROLLBACK;  -- 撤销删除操作

-- 3. AUTOCOMMIT（自动提交）MySQL的默认模式，每条SQL语句自动提交
-- AUTOCOMMIT = 1：每条语句立即生效（默认）
-- AUTOCOMMIT = 0：需要手动COMMIT

sqlSET AUTOCOMMIT = 0;  -- 关闭自动提交
UPDATE products SET price = 100;-- 此时更改未生效
COMMIT;  -- 手动提交才生效

CONVERT(NVARCHAR(20), NULL)
-- 表示将 NULL 值转换为 NVARCHAR 数据类型，且限定长度为 20 个字符。
-- CONVERT：是 SQL 中的类型转换函数，用来将一个数据类型转换成另一个数据类型。
-- NVARCHAR(20)：表示目标数据类型是 NVARCHAR，这是一种用于存储 Unicode 字符的可变长度字符串类型，(20) 表示字符串最大可以存储 20 个字符。
-- NULL：表示无值或空值。NULL 在 SQL 中表示没有数据。

SELECT ProductID FROM Production.Product
EXCEPT
SELECT ProductID FROM Sales.SalesOrderDetail;
-- EXCEPT 操作符用于返回出现在 第一个查询（Production.Product）中但不出现在 第二个查询（Sales.SalesOrderDetail）中的数据
-- EXCEPT 在内部执行时，会将两张表中的数据进行对比，查找 第一个查询结果中有，而第二个查询结果中没有的行，并返回结果。

select id,month,
sum(salary)over(partition by id order by month range 2 preceding) as salary
from employee
Where (ID,month) not in (select id,max(month) from Employee group by id)
Order by id,month desc