SELECT
    birthdate,
    Day(Birthdate) 'day',
    MONTH(BIRTHDATE) 'MONTH',
    year(Birthdate) 'year',
    DATEPART(Quarter,birthdate) 'Quarter',
    DATEPART(Day,birthdate) 'day2',
    DATEPART(month,birthdate) 'month2',
    DATEPART(year,birthdate) 'year2',
    DATEPART(week,birthdate) 'week',
    DATEPART(weekday,birthdate) 'weekday',
    --DATENAME
    DATENAME(Month,birthdate) 'MonthWord',
    DateName(Weekday,birthdate) 'Weekdayword',
    Left(DATENAME(Month,birthdate),3),

    /* Note the output of the data type at all int */
  -- Datetrunc give you details upto the level specify in the part either to Year, month, quarter, day, hours, minute etc level
    DATETRUNC(Quarter,birthdate) 'TrunckQuarter',
     DATETRUNC(mONTH,birthdate) 'TrunckMonth',
     DATETRUNC(Year,birthdate) 'TrunckYear'
    --
From sales.Employees;

SELECT
    creationTime,
    Datepart(Hour,CreationTime) 'Hours',
    Datepart(Minute,CreationTime) 'Minute',
    Datepart(Second,CreationTime) 'second',
    DATETRUNC(Minute,CreationTime) 'TrunckMinute',
    DATETRUNC(Day,CreationTime) 'TrunckDay',

    EOMONTH(CreationTime) 'EndofMonth', -- returns the end of the month
    Cast(DATETRUNC(month,creationTime) as date) 'StartofMonth'
From sales.Orders;

-- How many orders were placed each year?

SELECT
    Year(orderDate) 'Year',
    Count(*) 'NosOrder'
from sales.Orders
group by Year(orderDate)
order by 1

-- How many orders were placed each Quarter ?
SELECT
   DatePart(Quarter,orderDate) 'Quarter',
    Count(*) 'NosOrder'
from sales.Orders
group by DatePart(Quarter,orderDate)
order by 1

-- How many orders were placed each Quarter ?
SELECT
   DateNAme(Month,orderDate) 'Month',
  
    Count(*) 'NosOrder'
from sales.Orders
group by DateName(month,orderdate),month(orderdate)
order by month(OrderDate)

-- Show all order that were placed during the month of february.
Select *
from sales.Orders
where month(orderdate) = 2;

SELECT
        orderid,
        creationTIme,
        --using format()
        format(creationTIme,'dd') 'day',
        format(creationTIme,'MM') 'Month',
        format(creationTIme,'ddd') 'day1',
        format(creationTIme,'MMM') 'month2',
        format(creationTIme,'MMM-yy') 'Month-Year',
        format(creationTIme,'yyyy')  'year',
        format(creationTIme,'HH')  'hr',
        format(creationTIme,'mm')  'min',
        format(creationTIme,'ss')  'sec',
/* show creationTime using the following format
    Day Wed Jan Q1 2025 12:34:56 PM
 */

 'Day ' +format(CreationTime,'ddd')  +' '+format(CreationTime,'MMM') 
+ ' Q' + DateNAme(quarter,CreationTime)  + ' '+format(CreationTime,'yyyy hh:mm:ss tt')
 as 'NEWTIME'

from sales.Orders;

SELECT
    format(orderdate,'MMM-yy') 'Month',
    count(*) 'QtyOrder'
   
From Sales.Orders
    group by format(orderdate,'MMM-yy'),month(OrderDate) 
    order by month(OrderDate)

SELECT

    convert(Time, creationTIme) 'Time',
    orderdate ,
    shipdate,
    DATEDIFF(Day,OrderDate,ShipDate)+1 'Datedff'
From sales.Orders;

-- Time gap Analysis
-- Find the number of days between each order and the previous order


SELECT

    orderid,
    orderdate CurrentOrder,
    shipdate,
    DATEDIFF(Day,LAG(OrderDate) over(order by OrderDate),orderDate) NrofDays
From sales.Orders;

-- Find the average scores of the customers
select
     customerID,
     score,
     avg(score) over() Avgscore,
     avg(coalesce(score,0)) over() Avgscore -- handle the null value and replacing it with 0 if null
from sales.Customers;


/* Display the full name of customers in a single field
 by merging their first and lastnames,
 and add 10 bobues point to each customer's score.
 */

 Select 
        customerID,
        Fullname = Concat(FirstName,' ',LastName),
        Neswcore = coalesce(score,0) + 10
From sales.Customers;


-- Sort the customers from lowest to Highest scores
-- With Nulls appearing Last

Select 
    customerid,
    score
from sales.Customers
order by 
    Case when score is null then 1
    else 0 end
    ,score
 
-- Find the sales price for each order by dividing sales by quantity

SELECT
    ProductID,
    Sales,
    Quantity,
    sales_Price = sales/NULLIF(quantity,0) -- using the NULLIF to handle the divide by 0 challenge by assigning Null to the value
from sales.orders;


-- Handling of Null, Empty String and Blank Space
With orders as (
    Select 1 id, 'A' Category
    UNION
    Select 2, NULL 
    UNION
    Select 3, ''
    UNION
    select 4, '  '
)
Select 
        *,
        Trim(Category) Policy1, -- This remove the blank space 'Whitespaces
        NULLIF(TRIM(Category),'') policy2, -- This replaces the empty space with NULL value
        COALESCE(NULLIF(TRIM(Category),''),'Unknown') Policy3 -- THis would assign a value of Unknown to the identify Null Value

From orders;

/* Generate a report shouwing the total sales for each category
 1. High: if the sales higher than 50
 2. Medium: if the sales between 20 and 50
 3. Low: if the sales equal or lower than 20

 Sort the result from lowest to highest

 */
 Select 
     
        Case 
        When sales > 50 then 'High'
         When sales >= 20 then 'medium'
        else 'low'
        End Category,
        sum(sales) as total_sales
From sales.orders
Group by 
 Case 
        When sales > 50 then 'High'
         When sales >= 20 then 'medium'
        else 'low'
        End
order by total_sales desc;

-- Convert Gender from M to male and F = Female
Select 
    EmployeeID,
    FullName = concat(FirstName,' ',Lastname),
    Department,
    Birthdate,
    Case
        when gender ='M' then 'Male'
        When gender = 'F' then 'Female'
        else 'Unknown'
    END Gender,
    Salary,
    ManagerID


from sales.Employees;

-- Retrieve Customer details with abbrevaited country code
select 
    customerID,
    FullName = concat(FirstName,' ',Lastname),
    Country,
    Case
        When country = 'USA' THEN 'US'
        WHEN Country = 'Germany' THEN 'DE'
    Else 'Unknown'
End Country_abrrv
From sales.Customers;

/* Find the average scores of customers and treat Nulls as 0
 And Additional provide details such customerID and LastnaME

*/

SELECT  
        CustomerID,
        LastName,
        score,
        Case
            when score is null then 0
            else score
        end Score_clean,
        --Now use window function to get the avg_score of the score_clean
        Avg(Case
            when score is null then 0
            else score
        end) over() AvgCustomerClean

        --Avg(score) over() avgCustomer
From sales.Customers

/* Count how many times each customer has made an order
with sales greater than 30

*/

Select  
       
        customerId,
       
        Sum(Case
            when sales > 30 Then 1
            Else 0
        END) TotalHighsales,
    Count(*) Totalorders
from sales.orders
Group by customerId;


/* SubQueries, - Using the FROM Clause.
SQL TASK
Find the products that have a price higher
than the average price of all product

*/
Select 
    *
    From (
            --Subsquery
            SELECT  
                productID,
                price,
                avg(price) over() avg_price
            From sales.Products)t
Where Price > Avg_Price;

-- Rank Customer based on their total amount of sales

    Select
        *,
        Rank() over( order by totalsales desc)  Ranked 
           From(
                Select 
                        customerid,
                       
                        sum(sales) totalsales
                    from sales.orders
                   group by customerid)t

/* Select Clause Subsquery
SQL Task
Show the Product IDs, names, Price, and total number of orders
*/

SELECT
        ProductId,
        Product ProductName,
        Price,
                (Select     
                        count(*) 
                    from sales.orders
                    )Totalorder
from Sales.Products

/* Subquery in the Join Clause

Show all customer details and find the total orders for each customer
*/
-- Main Query
Select 
       c.*,
       o.Totalorders
From sales.Customers c
Left Join
        (select 
            customerID,
            Count(*) TotalOrders
    From sales.orders
    group by customerid) o
On c.CustomerID = o.CustomerID;

/* Where Clause Subsuery
SQL Task
Find the products that have a price higher than the average price of all product
*/

-- Main quary
select *,
         (select 
                avg(price)
            from sales.Products) Avg_price
from sales.Products
where Price >(
          
           --Calculate the average price of all product
            select 
                avg(price)
            from sales.Products)

/* Subsquery IN operator
SQL Task
Show the details of orders made by customers in Germany
*/
Select 
      *
      
from Sales.orders O
Where customerid in
                    (
                    Select customerID from sales.customers
                    where country = 'Germany') 

-- sHOW the details of orders for customers who are not from germany

Select 
      *
      
from Sales.orders O
Where customerid in
                    (
                    Select customerID from sales.customers
                    where country <> 'Germany') ;

--OR
Select 
      *
      
from Sales.orders O
Where customerid NOT in
                    (
                    Select customerID from sales.customers
                    where country = 'Germany') ;


-- SQL TASK
-- Find female employees whose salaries are greater than the salaries of any male employees

Select 
        FullName = Concat(FirstName,' ',Lastname),
        Salary
    From sales.Employees
    Where Gender = 'F' And Salary > ANY

                            (Select 
                                    Salary
                                From sales.Employees
                                Where Gender = 'M');

-- Find female employees whose salaries are greater than the salaries of all male employees
Select 
        FullName = Concat(FirstName,' ',Lastname),
        Salary
    From sales.Employees
    Where Gender = 'F' And Salary > ALL

                            (Select 
                                    Salary
                                From sales.Employees
                                Where Gender = 'M');

-- Show all customer details and find the total orders for each customer

-- Main Query
SELECT
        *,
        (select 
                count(*) 
        from sales.orders o
        WHERE o.CustomerID = c.customerid) Totalsales
from sales.customers c

-- Show the details for orders made by customers in germany

-- main query
Select 
        *
From Sales.orders O
Where EXISTS (Select
                     *
              From Sales.Customers c
              Where country = 'Germany'
              AND o.CustomerID = C.CustomerID)

/*Window Function in SQL
Find the total sales across all orders
*/

Select 
    
   sum(sales) as totalsales
from sales.orders;

-- Find the total sales for each Product
Select 
    ProductID,
    format(sum(sales),'C') as totalsales
from sales.Orders
group by Productid;

-- Find the total sales for each product
-- additionally provide details such orderId and orderdate




SELECT
    Productid,
    orderid,
    orderdate,
    sum(sales) over(Partition by Productid,orderid,orderdate) as salesbydate,
    sum(sales) over(Partition by Productid) as totalsales
From sales.orders;


-- Find the total sales across all orders
-- Additionally provide details such orderid, order date

SELECT
    orderid,
    orderdate,
    sum(sales) over(Partition by orderid) as Totalsale,
    sum(sales) over() allsales
from sales.orders;

-- Find the total sales for each Product, 
--additionally provide details such orderid & orderdate

SELECT  
    productid,
    orderid,
    orderdate,
    sum(sales) over(partition by Productid) totalsales
from sales.Orders;

-- Find the total sales across all orders
-- Find the total sales for each product
-- Additionally provide details such as order id, order date

select  
        ProductID,
        orderid,
        orderdate,
        sales,
        orderstatus,
        sum(sales) over(partition by ProductId) TotalSaleProduct,
        sum(sales) over(partition by ProductId, orderstatus) TotalSaleProduct,
        sum(sales) over() as totalsales
       
from sales.Orders

-- Rank each order based on their sales from highest to lowest
-- Additionally provide details such orderID, orderdate

SELECT
        orderId,
        orderdate,
        sales,
        Rank() over(order by sales desc) rank
from sales.orders;

-- Rank the customers based on their total sales


SELECT
    customerid,
    sum(sales)  as totalsales,
    Rank() over(order by sum(sales) desc) Ranked
From sales.Orders
group by customerid;

-- find the total number of all orders
-- Additionally provide details such orderid, orderdate
-- Additionally provide the total of orders for each customers

select 
    
    orderid,
    orderdate,
    customerid,
    count(orderid) over(partition by CUSTOMERID) orderbycustomer,
    count(*) over() totalorders
from sales.orders;

-- Find the total number of customers,
-- additionally provide all customer's detail

SELECT
    *,
     COUNT(*) OVER() TOTALCUSTOMER
FROM SALES.Customers;

-- cHECK whether the table order contains any duplicate rows

SELECT
    *
    From
        (Select
                orderid,
                count(*) over(partition by orderid) checkPK
        from sales.orders)t
where checkPk > 1;


USE SALESDB;

/*
SQL TASK

Find the total sales across all orders
and the total sales for each product
Additionally, provide details such as orderID and orderdate
*/

Select
            productid,
            orderid,
            orderdate,
            sales,
            sum(sales) over(partition by Productid) TotalProductsale,
            sum(sales) over() allsales
From sales.Orders;

/* SQL Task

Find the percentage contribution of
each product's sales to the total sales

*/

SELECT
        orderid,
        productid,
        Sales,
        sum(sales) over() totalsales,
        -- percentage contribution is sales/total sales
        Round(Cast(sales as Float)/sum(sales) over() * 100,2) PercentContribution  -- need to change the data type from INT to Float
From sales.orders;

/*
SQL Task
Find the average sales across all orders
and the average sales for each products
Additionally, provide details such as order id and order date

*/

SELECT
        productid,
        orderid,
        orderDate,
        sales,
        avg(sales) over(partition by productid) overallSales,
        avg(sales) over() overallSales

from sales.orders;

-- Find the average scores of customers
-- additionally, provide details such as customerID and LastName

Select 
        customerID,
        LastName,
        score,
        avg(coalesce(score,0)) over() CustomerScoreAvg,
        avg(score) over() CustomerScoreAvgwithNull
from sales.Customers;

-- Find all orders where sales are higher than the average sales across all order

SELECT
   *
        From (
            
            Select 
                        orderid,
                        productid,
                        Sales,
                        avg(sales) over() avgSales
            From sales.orders   )T
where sales > avgsales;

/* SQL Task
Find the highest and lowest sales across all orders
and the highest & lowest sales for each product
additionally, provide details such as orderId and orderdate
*/

SELECT
        Productid,
        orderid,
        orderdate,
        max(sales) over() maxsales,
        Min(sales) over() Minsales,
        max(sales) over(partition by productid) maxsales2,
        Min(sales) over(partition by productid) Minsales2
from sales.orders

-- show the employee with the highest salaries

SELECT Top 1
        employeeid,
        fullname = concat(firstname,' ',lastname),
        format(salary,'C'),
        format(max(salary) over(order by salary desc),'C') as highsalary
       
from sales.Employees;

--- Option B - using subquery

Select
    *
From
    (
       select
            *,
            Max(salary) over() HighestSalary
        From sales.Employees
    )t 
where salary = HighestSalary;

-- Find the deviation of each sales from the minimum and maximum sales amount

select  
    orderid
    orderdate,
    Productid,
    Sales,
    max(sales) over() maxsales,
    Min(sales) over() Minsales,
    DeviationfromMin = Sales - Min(sales) over(),
    DeviationfromMAX = max(sales) over() - Sales
from sales.orders;

/* SQL Task
Analytical Use Case
Running & Rolling Total

1. Tracking: Tracking current sales with Target Sales
2. Trend Analysis: Providing insights into historical patterns.

The Running Total: Aggregate all values from the begining up to the current point 
without dropping off older data.

ROlling Total: Aggregate all values within a fixed time window (eg 30 days)
As new data is added, the oldest data point will be dropped.

SQL Task

-- calculate moving average of sales for each product over time
-- calculate moving average of sales for each product over time, including only the nexr order


*/

SELECT  
        orderid,
        productid,
        orderdate,
        sales,
        Avg(sales) over(partition by productid) AvgbyProduct,
        Avg(sales) over(partition by productid order by orderdate) MovingAvg,
        Avg(sales) over(partition by productid order by orderdate ROWS BETWEEN CURRENT ROW AND 1 following ) ROllingAvg
from sales.orders


/*
RANKING WINDOW FUNCTION

- Integer based Ranking
- Percentage based Ranking

- Distribution Analysis  - Find Top 20% Product
- Top/Bottom N Analysis = Find Top 3 products

Ranking Analysis
1. Row_Number()
2. Rank()
3. Dense_Rank()
4. Ntile(n)

Percentage Base Ranking
1. Cume_Dist()
2. Percent_Rank()
*/

-- SQL Task
-- Rank the orders based on their sale from highest to lowest
-- using Row_number(), which does not handle ties

select 
    orderid,
    sales,
    ROW_NUMBER() over(order by sales desc) Rank
from sales.orders;

-- lets use Rank(), that handles ties
-- also use Dense_Rank for handling ties without giving space

select 
    orderid,
    sales,
    ROW_NUMBER() over(order by sales desc) Row_Number,
    RANK() over(order by sales desc) Rank,
    Dense_RANK() over(order by sales desc) Dense_Rank
from sales.orders;

-- Find the top highest sales for each product
-- Top N Analysis
SELECT
    *
    From
        (

            SELECT
                    Productid,
                    orderid,
                    Sales,
                    rank() over(partition by ProductID order by sales desc) Rank
            from sales.orders
        )t 
where rank = 1;

-- Find the lowest 2 customer
-- based on their total sales
-- Bottom N Analyser

SELECT
        *
        From 
            (

            SELECT 
                    customerid,
                    sum(sales) as totalsales,
                    Row_number() over (order by sum(sales)) RankCustomers
            from sales.Orders
            group by customerid
            -- order by totalsales
            )t 
Where RankCustomers <= 2;
      

-- Assign unique IDs to the row of the 'orders archive' table

SELECT
        ROW_NUMBER() over(order by orderid) idno,
        *
    from sales.OrdersArchive;

alter table sales.ordersarchive
Add  IDno INt;


-- Use Case
-- Identify duplicates
-- identify and remove duplicate rows to improve data quality
-- and return a clean duplicate

SELECT  
        *
        from(
       
        SELECT
            ROW_NUMBER() over(partition by orderid order by creationTIme) rn,
            *
        from sales.OrdersArchive
        )t 
where rn = 1 -- Note any rn higher than 1 is a duplicate based on the creationtime.

-- To get the duplicate
SELECT  
        *
        from(
       
        SELECT
            ROW_NUMBER() over(partition by orderid order by creationTIme) rn,
            *
        from sales.OrdersArchive
        )t 
where rn > 1 -- Note any rn higher than 1 is a duplicate based on the creationtime.


/* NTILE(n) Function, The Ntile(n), divides  the rows into a specified number of approximately equal groups (buckets)

*/

Select 
     OrderId,
     sales,
     NTILE(1) over(order by sales desc) oneBucket,
     NTILE(2) over(order by sales desc) TwoBucket,
     NTILE(3) over(order by sales desc) THreeBucket,
     NTILE(4) over(order by sales desc) FourBucket,
     NTILE(5) over(order by sales desc) FiveBucket

from sales.orders;

/*
NTILE Use case
1. Data Segmentation as Data Analyst
2. Equalizing load Processing as a Data Engineer
*/

-- SQL Task
-- Segment all orders into 3 categories
-- High,medium and lower

SELECT
    *,
    Case 
        when rn = 1 Then 'High'
        When rn = 2 Then 'Medium'
         When rn = 3 Then 'Low'
    END Sales_Segmentation

    from
        (
        SELECT 
            NTILE(3) over(order by sales desc) rn,
            Sales,
            Orderid,
            Productid
            
        from sales.orders
        )t

-- in order to export the data, divide the orders into 2 groups

select
    NTILE(2) over(order by orderid) segment,
    *
    
from sales.orders;

/* Percentage Ranking function
We have 2 Percentage ranking function
1. Cume_Dist()
2. Percent_Rank()

*/

-- Find the products that fall within the highest 40% of the prices


SELECT
     *,
    concat(rn * 100, '%') rnPercent
     From
            (
                
                Select 
                    Product,
                    Price,
                    CUME_DIST() over(order by price desc ) Rn ,
                    PERCENT_RANK() over(order by price desc ) Rn2 
                from sales.Products
            )t 
    
Where rn <= 0.4


/* Time series Analysis
The process of analyzing the data to understand 
patterns, trends and behaviors over time.

1. Year-Over-Year (YOY) Analysis
 This would help us understand the overall growth or decline of 
 the business's performance over time

2. Month-over-Month (MOM) Analysis
   In other to Analyze short-term trends and discover patterens in seasonality.


*/

-- SQL Task
-- Analyze the month-over-month performance by finding the percentage change
-- in sales between the current and previous month


SELECT
        *,
        MOM_change = CurrentMnSales - PrvMonthsales,
        MOM_PercentChange = Round(cast((CurrentMnSales - PrvMonthsales) as Float)/PrvMonthsales * 100,1)

        From 
        (
    
        SELECT
            month(orderDate)  OrderMonth,
            sum(sales) CurrentMnSales,
            LAG(Sum(SALES)) over(order by Month(orderDate)) PrvMonthsales
        from sales.orders
        group by month(orderdate)
        )t


-- Customer Retention Analysis
-- This is all about measure customer's behavious and loyalty to help
-- business build strong relationships with customers
-- SQL TASK
-- Analyze customer loyalty by ranking customers
-- based on the average number of days between orders
    
    Select
        customerID,
        avg(DaysUNitNextOrder) avgDays,
        Rank() over(order by Coalesce(avg(DaysUNitNextOrder),999999)) Rank
        FROM
            (


            select 
                customerID,
                ORDERID,
                
                orderDate currentorder,
                Lead(Orderdate) over (PARTITION by customerid order by Orderdate) Nextorder,
                DateDiff(DAY,orderDate,Lead(Orderdate) over (PARTITION by customerid order by Orderdate)) DaysUNitNextOrder
            From Sales.Orders
            --Order by Customerid, orderdate
            )t 
    Group by CustomerID;


    /*
   CTE : Common Table Expression
   There are 2 type
   1. Recursive CTE, this is further divide into 
        a. Stand Alone CTE
        b. Nested CTE
   2. Non Recursive CTE

   */

   -- SQL Task
   -- Step 1: FInd the total sales per customer
   -- find the last order date for each customer
   -- Rank the customers based on total sales per customer
   -- Segement Customers based on total sales

-- step 1: find total sales for each customer
With CTE_Total_sales AS
    (
                Select 
                    customerID,
                    Sum(sales) Totalsales
                from sales.Orders
                group by CustomerID
    )

    -- step 2: Find the lastorder date for each customers
    ,CTE_Last_Order AS
    (
            SELECT
                    CustomerID,
                    Max(orderDate) LastOrderDate
                from sales.orders
                group by customerID

    )

    -- Step 3:  Rank the Customer (This is a Nested CTE)
    ,CTE_Rank_Customer AS
    (
             Select
                    customerID,
                    Rank() over(order by TotalSales desc) Rank
            From CTE_Total_sales

    )
    --step 4: Customers segmentation based on total sales (Nested CTE)
    , CTE_Customer_Segmentation AS
    ( 
         Select 
                Case 
                    When Customer_segmentation = 1 Then 'High'
                    When customer_Segmentation = 2 Then 'Medium'
                    When Customer_segmentation = 3 THen 'Low'
                END Customer_Seg,
                *
            FROM(
                    SELECT
                            customerID,
                            NTILE(3) over(order by totalsales desc) as Customer_segmentation
                    From CTE_Total_sales)t

    )

    -- Main Query
    SELECT
        c.customerid,
        fullname = concat(c.firstname,' ',c.lastname),
        cts.totalsales,
        cto.LastOrderDate,
        CRC.Rank Ranking,
        ccs.Customer_Seg
        From Sales.customers C 
        LEFT Join CTE_TOTAL_SALES cts
        On cts.CustomerID = c.CustomerID
        Left Join CTE_Last_Order cto 
        on cto.CustomerID = c.CustomerID
        LEFT JOIN CTE_Rank_Customer CRC 
        on crc.CustomerID = c.CustomerID
        LEFT JOIN CTE_Customer_Segmentation CCS 
        on ccs.CustomerID = c.CustomerID
        order by crc.rank 
    

/* Non-Recursive CTE: Is executed only once without any repetition
Recursive CTE: Self-referencing query that repeatedly processes data 
until a specific condition is met.



-- SQL TasK
-- Generate a sequence of number from 1 to 20

*/

With CTE_numberseq AS
        (   
            --Anchor cte
            Select
            MyNumber = 1
            UNION ALL
            -- recursive cte
            select 
                MyNumber + 1
            FROM CTE_numberseq
            Where MyNumber < 20
        )

-- Main Query
 Select *
From CTE_numberseq;
-- option (MaxRecursion 5000) -- This syntax is use to control the number of recursion



-- SQL TASK
-- Show the employee hierarchy by displaying
-- each employee's level with the organization

With CTE_employee as (
    -- Anchor Query
    SELECT
        EmployeeID,
        FullName = Concat(Firstname,' ',Lastname),
        Department,
        ManagerID,
        Level = 1
    From sales.Employees
        where ManagerId is Null
    UNION ALL
    -- Recursive Query
    Select
        e.EmployeeID,
        FullName = Concat(e.Firstname,' ',e.Lastname),
        e.Department,
        e.ManagerID,
        level + 1
    From sales.employees As e 
    INNER JOIN CTE_employee Cte
      on e.managerID = cte.EmployeeID
    
)
-- Main Query
Select *
From CTE_employee;


/* Views

--SQL TasK
-- Find the Running Total for sales for each month

*/

With CTE_Monthly_Summary As (

    Select
            DATETRUNC(Month, OrderDate) OrderMonth,
            Sum(sales) TotalSales,
            count(orderid) TotalOrders,
            sum(Quantity) TotalQuantities
    From Sales.orders
    Group by DATETRUNC(Month, OrderDate)
)
-- Main Query
SELECT
    Ordermonth,
    Totalsales,
    Totalorders,
    TotalQuantities,
    Sum(TotalSales) over (Order by ordermonth) as RunningTotal
    From CTE_Monthly_Summary;

-- Create View

Create VIEW V_Monthly_Summary AS
(
    Select
            DATETRUNC(Month, OrderDate) OrderMonth,
            Sum(sales) TotalSales,
            count(orderid) TotalOrders,
            sum(Quantity) TotalQuantities
    From Sales.orders
    Group by DATETRUNC(Month, OrderDate)
    )

-- Use the view
Select 
        *
From V_Monthly_Summary;

--  Provide view that combines details from order, product, customers and Employees
Create View MasterRecord AS
(
Select 
        o.OrderID,
        o.ProductID,
        o.CustomerID,
        o.SalesPersonID,
        o.Shipdate,
        o.OrderStatus,
        o.ShipAddress,
        o.BillAddress,
        o.Quantity,
        o.Sales,
        o.CreationTime,
        p.Product,
        p.Category,
        p.price,
        Fullname = Concat(c.FirstName,' ',c.LastName),
        c.country,
        c.score,
        e.Department,
        e.Birthdate,
        e.gender,
        e.Salary,
        e.ManagerID

From sales.Orders o
left join sales.products p
on o.productID = p.ProductID
left join sales.customers C 
on o.CustomerID = c.customerid
left join sales.Employees e
on o.SalesPersonID = e.EmployeeID
);

-- Use view
select *
from MasterRecord