CREATE TABLE Emp(grp  varchar(20), sequence  int )

INSERT INTO Emp VALUES('A',1);
INSERT INTO Emp VALUES('A',2);
INSERT INTO Emp VALUES('A',3);
INSERT INTO Emp VALUES('A',5);
INSERT INTO Emp VALUES('A',6);
INSERT INTO Emp VALUES('A',8);
INSERT INTO Emp VALUES('A',9);
INSERT INTO Emp VALUES('B',11);
INSERT INTO Emp VALUES('C',1);
INSERT INTO Emp VALUES('C',2);
INSERT INTO Emp VALUES('C',3);

/*
2. Problem Statement:-
Student Table has three columns Student_Name, Total_Marks and Year.
User has to write a SQL query to display Student_Name, Total_Marks, Year,  Prev_Yr_Marks for
those whose Total_Marks are greater than or equal to the previous year.
*/

CREATE TABLE Student(
Student_Name  varchar(30),
Total_Marks  int ,
Year  int);

INSERT INTO Student VALUES('Rahul',90,20Oct) ;
INSERT INTO Student VALUES('Sanjay',80,20Oct);
INSERT INTO Student VALUES('Mohan',70,20Oct);
INSERT INTO Student VALUES('Rahul',90,2011);
INSERT INTO Student VALUES('Sanjay',85,2011);
INSERT INTO Student VALUES('Mohan',65,2011);
INSERT INTO Student VALUES('Rahul',80,2012);
INSERT INTO Student VALUES('Sanjay',80,2012);
INSERT INTO Student VALUES('Mohan',90,2012);


select * from (
  select Student_Name , Total_Marks, Year ,
    case when Total_Marks >= prev_yr_marks then 1 else 0 end flag
    from (
      select Student_Name,
             Total_Marks,
             Year,
             lag(Total_Marks) over(partition by Student_Name order by Year) as prev_yr_marks
             from Student
          ) A
   ) B where flag=1;


CREATE TABLE Order_Tbl(
 ORDER_DAY date,
 ORDER_ID varchar(Oct) ,
 PRODUCT_ID varchar(Oct) ,
 QUANTITY int ,
 PRICE int
);

INSERT INTO Order_Tbl  VALUES ('2015-05-01','ODR1', 'PROD1', 5, 5);
INSERT INTO Order_Tbl  VALUES ('2015-05-01','ODR2', 'PROD2', 2, Oct);
INSERT INTO Order_Tbl  VALUES ('2015-05-01','ODR3', 'PROD3', Oct, 25);
INSERT INTO Order_Tbl  VALUES ('2015-05-01','ODR4', 'PROD1', 20, 5);
INSERT INTO Order_Tbl  VALUES ('2015-05-02','ODR5', 'PROD3', 5, 25);
INSERT INTO Order_Tbl  VALUES ('2015-05-02','ODR6', 'PROD4', 6, 20);
INSERT INTO Order_Tbl  VALUES ('2015-05-02','ODR7', 'PROD1', 2, 5);
INSERT INTO Order_Tbl  VALUES ('2015-05-02','ODR8', 'PROD5', 1, 50);
INSERT INTO Order_Tbl  VALUES ('2015-05-02','ODR9', 'PROD6', 2, 50);
INSERT INTO Order_Tbl  VALUES ('2015-05-02','ODROct','PROD2', 4, Oct);

/*
3) Problem:

(a) Write a SQL to get all the products that got sold on both the days and the number of times the product is sold.
(b) Write a SQL to get products that was ordered on 02-May-2015 but not on 01-May-2015
*/
-- a)
select PRODUCT_ID,count(PRODUCT_ID) cnt, count(distinct ORDER_DAY) as cnt_distinct
from  Order_Tbl group by PRODUCT_ID having cnt_distinct > 1;
-- b)
select distinct PRODUCT_ID from Order_Tbl where ORDER_DAY='2015-05-02'
and PRODUCT_ID not in ( select distinct PRODUCT_ID from Order_Tbl where ORDER_DAY='2015-05-01');

/*
4) Problem Statements :-
(a) Write a SQL to get the highest sold Products (Quantity*Price) on both the days
(b) Write a SQL to get all product's  total sales on 1st May and 2nd May adjacent to each other
(c) Write a SQL to get all products day wise, that was ordered more than once
*/
-- a)
select A.ORDER_DAY, B.PRODUCT_ID, A.max_amount_sold
from (
  select ORDER_DAY, MAX(QUANTITY * PRICE) max_amount_sold
  from Order_Tbl
  group by ORDER_DAY
) A
inner join
(
  Select ORDER_DAY, PRODUCT_ID, (QUANTITY * PRICE) amount_sold
  from Order_Tbl
) B
where A.ORDER_DAY = B.ORDER_DAY and A.max_amount_sold = B.amount_sold

-- b)
Select product_id, sum(Sales_01_May) , sum(Sales_02_May)
from
(
  Select product_id,
  case when order_day='2015-05-01' THEN Total_sales Else 0 end 'Sales_01_May',
  case when order_day='2015-05-02' THEN Total_sales Else 0 end 'Sales_02_May'
  from
  ( Select PRODUCT_ID, ORDER_DAY, sum( QUANTITY * price) Total_sales
    from Order_Tbl
    group by PRODUCT_ID, ORDER_DAY
    order by PRODUCT_ID, order_day
  ) A
) B
group by product_id


-- c)

Select product_id, order_day, count(*)
from Order_Tbl
group by PRODUCT_ID, order_day
having count(*) > 1;

--5) Hacker Rank Project timelines from task timelines.

create table projects (task_id int,start_date date, end_date date);

insert into projects VALUES
(1, CAST('2020-10-01' AS date), CAST('2020-10-02' AS date)),
(2, CAST('2020-10-02' AS date), CAST('2020-10-03' AS date)),
(3, CAST('2020-10-03' AS date), CAST('2020-10-04' AS date)),
(4, CAST('2020-10-13' AS date), CAST('2020-10-14' AS date)),
(5, CAST('2020-10-14' AS date), CAST('2020-10-15' AS date)),
(6, CAST('2020-10-28' AS date), CAST('2020-10-29' AS date)),
(7, CAST('2020-10-30' AS date), CAST('2020-10-31' AS date));

-- get start dates not present in end date column (these are “true” project start dates)
SELECT start_date
FROM projects
WHERE start_date NOT IN (SELECT end_date FROM projects)

-- get end dates not present in start date column (these are “true” project end dates)

SELECT end_date
FROM projects
WHERE end_date NOT IN (SELECT start_date FROM projects)

-- filter to plausible start-end pairs (start < end), then find correct end date for each start date (the minimum end date, since there are no overlapping projects)

SELECT t1.start_date, min(t2.end_date) AS end_date
FROM (
      SELECT start_date FROM projects
      WHERE start_date NOT IN (SELECT end_date FROM projects)
    ) t1,
    (
      SELECT end_date
      FROM projects
      WHERE end_date NOT IN (SELECT start_date FROM projects)
    ) t2
WHERE t1.start_date < t2.end_date
group by start_date
order by start_date;

-- 6) Cancellation rates
From the following table of user IDs, actions, and dates,
write a query to return the publication and cancellation rate for each user.

Create table users(user_id int, action varchar(10), adate date)

Insert into users VALUES
(1,'start', CAST('2020-01-01' AS date)),
(1,'cancel', CAST('2020-02-01' AS date)),
(2,'start', CAST('2020-03-01' AS date)),
(2,'publish', CAST('2020-04-01' AS date)),
(3,'start', CAST('2020-05-01' AS date)),
(3,'cancel', CAST('2020-06-01' AS date)),
(1,'start', CAST('2020-07-01' AS date)),
(1,'publish', CAST('2020-08-01' AS date));

-- select user_id, case when action='start' then 1 else 0

/*
  7) SalesInfo Table has three columns namely Continents, Country and Sales.
  Write a SQL query to get the aggregate sum  of sales  country wise and display only those
  which are maximum in each continents as shown in the table.
 */

Create Table SalesInfo(
Continents varchar(30),
Country varchar(30),
Sales Bigint
)

Insert into SalesInfo Values('Asia','India',50000);
Insert into SalesInfo Values('Asia','India',70000);
Insert into SalesInfo Values('Asia','India',60000);
Insert into SalesInfo Values('Asia','Japan',10000);
Insert into SalesInfo Values('Asia','Japan',20000);
Insert into SalesInfo Values('Asia','Japan',40000);
Insert into SalesInfo Values('Asia','Thailand',20000);
Insert into SalesInfo Values('Asia','Thailand',30000);
Insert into SalesInfo Values('Asia','Thailand',40000);
Insert into SalesInfo Values('Europe','Denmark',40000);
Insert into SalesInfo Values('Europe','Denmark',60000);
Insert into SalesInfo Values('Europe','Denmark',10000);
Insert into SalesInfo Values('Europe','France',60000);
Insert into SalesInfo Values('Europe','France',30000);
Insert into SalesInfo Values('Europe','France',40000);


-- Solution:
with agg_country as (
  select Continents, country, sum(sales) agg_sales
  from SalesInfo group by Continents,Country order by Continents, country
)
select t1.continents, agg_country.country, t1.highest_sales
from (
    select a1.continents, max(a1.agg_sales) highest_sales
    from agg_country a1 group by continents
) t1, agg_country where t1.continents = agg_country.continents and t1.highest_sales = agg_country.agg_sales;

/*

8) CLASSICAL PROBLEM, also called as Codd's T-Join or approximate join or theta join.
The problem is to assign the classes to the available classrooms.
We want (class_size < room_size) to be true after the assignments are made.
Note, there is no single solution to this.

*/

CREATE TABLE Rooms (room_nbr CHAR(2) PRIMARY KEY, room_size INTEGER NOT NULL);
CREATE TABLE Classes (class_nbr CHAR(4) PRIMARY KEY, class_size INTEGER NOT NULL);

INSERT INTO Classes
 VALUES
('c1', 106), ('c2', 105), ('c3', 104), ('c4', 100), ('c5', 99), ('c6', 90), ('c7', 89), ('c8', 88), ('c9', 83), ('c10', 82), ('c11', 81), ('c12', 65), ('c13', 50), ('c14', 49), ('c15', 30), ('c16', 29), ('c17', 28), ('c18', 20), ('c19', 19);

INSERT INTO Rooms
VALUES
('r1', 102), ('r2', 101), ('r3', 95), ('r4', 94), ('r5', 85), ('r6', 70), ('r7', 55), ('r8', 54), ('r9', 35), ('r10', 34), ('r11', 25), ('r12', 18);

With cte as
  (
    -- Get list of combinations where a class can entirely fit in a room.
    select class_nbr,class_size,room_nbr,room_size
    from Classes, Rooms
    where class_size < room_size
  )
  -- Use the above list and get the best fit by taking the minimum sized room that can fit in it a class/batch.
  -- This is similar to getting a record having highest/lowest column value in every category.
select cte.class_nbr,cte.room_nbr, cte.class_size, cte.room_size
from
(
  select class_nbr, min(cte.room_size) min_room
  from cte
  group by class_nbr order by class_nbr
) t1, cte where t1.class_nbr = cte.class_nbr and t1.min_room = cte.room_size
