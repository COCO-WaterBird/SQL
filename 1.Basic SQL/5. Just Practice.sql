Create datebase chapter02;
show create datebase chapter 02;
use chapter02;
select datebase();
show tables;
use mysql;
select database();
drop datebase chapter03;
create table employee(
    employeeID not null unique auto_increment,
    Name varchar(50),
    Gender Enum('M','F'),
    Age Int unsigned,
    Jobposition Enum('manager','development','counselor'),
    Salary Decimal(10,2) not null default 0,
    Joined Datetime,
    Address text,
    DeptID int not null,
    Primary key(EmployeeID)
    Foreign key(DeptID) references Department(DeptID)                 );
Desc employee;
Drop table employee;

Insert into employee values('001','Sam')
insert into employww(Name,Age)VAlues('Deby',25);

