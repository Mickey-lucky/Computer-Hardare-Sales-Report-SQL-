# Computer-Hardare-Sales-Report-SQL-
Project Overview: The project focuses on providing detailed sales report (as requested by product manager) via SQL data analysis for a consumer product company that supplies various computer hardware categories to e-commerce and brick-and-mortar customers across multiple countries and regions. The project covers three main areas: finance, marketing and supply chain. The project is executed in Jira environment to ensure efficient collaboration and process tracking.



## Project Preparation:
import databse in MySQL including 2 dimention tables and 7 fact tables<br>
-- dimention tables: 
  - cusomter, <br>
  - product<br><br>
  
-- fact tables:<br> 
  - monthly_sales, <br>
  - monthly_forecast,<br>
  - freight_cost, <br>
  - gross_price,<br> 
  - manufacturing_cost, <br>
  - pre_invoice_deduction, <br>
  - post_invoice_deduction



## Tools & Platform 
MySQL, SQL, Excel, Jira

## SQL techniques/functions used:
Create views, Stored Procedure, User_defined functions, CTE, window function, Join, Union etc.


### tasks 1 (Finance function):
1. Product owner would like to have a product wise sales report (aggregated on monthly lever) for custonmer - Croma in fiscal year 2021
    - created user-defined function "get_fiscal_year" and "get_fiscal_quarter) for later repeated use
      
   ![user-defined functions!](https://github.com/user-attachments/assets/7812f81a-a5db-48de-81a6-9ed4b5fe1462)
   
   ![user-defined functions!](https://github.com/user-attachments/assets/eb7fad47-bbb1-40a6-af21-3906c69a3fe1)


    - utilized multiple joins to generate the table which is stored in view
   
   ![product wise monthly report!](https://github.com/user-attachments/assets/7374698a-4eac-4e3f-852c-288ac1c49795)<br>

<br>

2. Create monthly gross sales report for Croma and other customers 
   - deployed stored procedure to automate the process and enhance efficiency

![gross monthly sales report by customer!](https://github.com/user-attachments/assets/beff2dfb-cf4b-4481-b4f8-a498029c85ad)


- one issue arises: some customer like Amazon has two customer_code in the database<br>
     -- this stored procedure need to be enhanced using "find_in_set"

     ![gross monthly sales report by customer!](https://github.com/user-attachments/assets/6c4c9376-eb22-47d7-a25a-847ae482a8d4)


3. create stored procedure to determine market badge for a specific market
 - if total quantity sold > 5 million, the market is considered gold else it is silver.

 ![determine market badge!](https://github.com/user-attachments/assets/fbda2243-583a-4c9f-abc4-558baf27c791)<br><br>

### tasks 2 : identify top markets, top products, top customers by net_sales and market share% breakdown:<br><br>
- 1: generate net sales table utilizing 3 facts tables --fact_sales_monthly, fact_pre_invoice_deduction and fact_post_invoice_decuction
   -- create view of 3 tables 

![sales_pre_discount!](https://github.com/user-attachments/assets/1af5664a-437a-46c0-b88f-6c6a21ca6242)<br><br>

![sales_post_discount and net_sales!](https://github.com/user-attachments/assets/ee1fce33-9a6c-430b-877f-6f4afc3a9000)<br><br>


- 2: create stored procedure for TOP N prodcut, market and customers by net_sales <br>
![Top N Customers!](https://github.com/user-attachments/assets/0658679e-4783-4761-8159-71eba82cd7c0)<br><br>
   --  Stored procedure of Top N markets and Top N products are similiar to Top N customers<br><br>



 - 3: Net sales global market share % by customers using window function <br>
![net sales global share %!](https://github.com/user-attachments/assets/1539dca1-61fd-42fa-9e37-5f6c149de086)



 - 4: Net sales% per region using window function <br><br>
![net sales % region wise!](https://github.com/user-attachments/assets/f4373a51-6a08-4704-ba84-98d3f5a97fa7)

--excel visualization<br>
![net sales % region wise!](https://github.com/user-attachments/assets/36f011b5-12ee-4d08-bd50-df0dd14175d6)<br><br>

5: -- create stored procedure for top n product by qty sold per division<br>
![top N product by quantity per division!](https://github.com/user-attachments/assets/48cd9ee4-bf64-43f7-80d5-fbb7c59fb75e)<br><br>






### tasks 3: supply chain analysis 
1. create a full union of the two tables: fact_sales_monthly and fact_forecast_monthly <br>
![full join of two tables!](https://github.com/user-attachments/assets/33583a0b-426c-449e-9f17-312258c17ede)<br>


2. change null value to 0 <br>
![change null into 0!](https://github.com/user-attachments/assets/8779af41-3f9d-49f3-8803-51e463b4e0ca)<br>


3.net error%, absolute error % and forecast accuracy% <br>
![forecast accuracy%!](https://github.com/user-attachments/assets/12f1a194-d171-42c2-9d1b-c93746d393e9)<br>





