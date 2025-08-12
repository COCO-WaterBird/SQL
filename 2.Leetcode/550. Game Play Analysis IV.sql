with cte as(
    select player_id, min(event_date) as first_login
    From Activity
    Group by player_id),

cte2 as(
    select *, date_add(first_login, interval 1 day) as next_date
    from cte)

select
    round((select count(distinct player_id)
    from Activity
    where (player_id,event_date) in (select player_id,next_date from cte2))/
    (select count(distinct player_id) from Activity),2) as fraction

WITH cte1 AS (...),     #← 第一个CTE，后面有逗号
     cte2 AS (...)      #← 最后一个CTE，后面没有逗号
-- 主查询语句;              ← 直接写主查询

-- 开窗函数

--SUM后的开窗函数
SELECT *,
SUM(Salary) OVER(PARTITION BY Groupname) 每个组的总工资，
--只对PARTITION后的内容进行分组，分组后求解Salary的和。
SUM(Salary) OVER(PARTITION BY groupname ORDER BY ID) 每个组的累计总工资，
--对PARTITION BY后面的列Groupname进行分组，然后按ORDER BY后的ID进行排序，然后在组内对Salary进行累加处理。
SUM(Salary) OVER(ORDER BY ID) 累计工资，
--只对ORDER BY后的ID内容进行排序，对排序完后的Salary进行累加处理。
SUM(Salary) OVER() 总工资
--对Salary进行汇总处理
from Employee ;

--COUNT后的开窗函数
SELECT *,
COUNT(*) OVER(PARTITION BY Groupname) 每个组的个数，
COUNT(*) OVER(PARTITION BY Groupname ORDER BY ID) 每个组的累计个数，
COUNT(*) OVER(ORDER BY ID) 累积个数，
COUNT(*) OVER() 总个数
from Employee;

--对学生成绩排序
SELECT *,
ROW_NUMBER() OVER (PARTITION BY ClassName ORDER BY SCORE DESC) 班内排序，
ROW_NUMBER() OVER (ORDER BY SCORE DESC) AS 总排序
FROM Scores;

--示例
SELECT ROW_NUMBER() OVER (ORDER BY SCORE DESC) AS [RANK], *
FROM Scores;

SELECT RANK() OVER (ORDER BY SCORE DESC) AS [RANK], *
FROM Scores;

--当出现两个学生成绩相同是里面出现变化。RANK()是1-1-3-3-5-6，
--而ROW_NUMBER()则还是1-2-3-4-5-6，这就是RANK()和ROW_NUMBER()的区别了。

/*
2. 开窗函数语法
函数名①() over(partition by 分组的列名 order by 排序的列名 rows/range.. 子句)
分析子句
partition by    分组
order by        排序
ROWS            窗口

限制数据属性
UNBOUNDED PRECEDING   第一行
CURRENT ROW           当前行
UNBOUNDED FOLLOWING   最后一行


聚合函数
SUM() AVG() MAX() MIN() COUNT()

排序类
ROW_NUMBER() 顺序排序 —— 1 2 3 4 5 6
RANK() 跳过排序 —— 1 2 2 4 5 6
DENSE_RANK() 不跳过并列 —— 1 2 2 3 4 5 6

3. 开窗函数分类

偏移类
LAG() LEAD()

用法（以 LAG 为例）：LAG(COL_NAME, OFFSET, DEFVAL) OVER()：向前偏移 N 行取数
COL_NAME：要分析的字段
OFFSET：偏移量 —— 默认偏移一行
DEFVAL：默认返回值 —— 默认返回空 null

4.最值函数  first_value() 与 last_value()

*/