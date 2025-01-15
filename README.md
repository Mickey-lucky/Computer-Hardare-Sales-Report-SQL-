# Computer-Hardare-Sales-Report-SQL-




## Step 1. import databse in MySQL including 2 dimention tables and 6 fact tables





## Introduction 
Project Overview: The project delved into datasets of a consumer products company that supplies various computer hardware categories to e-commerce and brick-and-mortar customers across multiple countries and regions. The dashboard explored sales data from over 1 million records and extracted insights from multi-faceted dimensions, such as finance, marketing, sales, supply chain, etc. The dashboard included multiple filter slicers, region/market, product segment/category, customers and multiple years (2019 to 2022). The two benchmark criteria for KPI are ‘VS last year’ and ‘VS target’. [Project live report](https://app.powerbi.com/view?r=eyJrIjoiOTg5ZWVhNWMtZjU3Ny00ODk4LTk3MWYtNjcyNGZiZjIwZmE3IiwidCI6ImM2ZTU0OWIzLTVmNDUtNDAzMi1hYWU5LWQ0MjQ0ZGM1YjJjNCJ9&pageName=19ff2deda902a8b9e25e)


## Tools & Platform 
MySQL, SQL, Excel, Jira

## SQL Techniques used:
Create views, Stored procedure, User_defined functions, CTE

## Key Steps:
1.	Connected to MySQL database and loaded data to Power BI. Introduced 3 dimension tables (product, market, customer) and 7 fact sales tables(monthly_sales, monthly_ forecast, gross price, pre-invoice deduction, post-invoice deduction, freight cost, manufacturing cost). Imported 3 Excel fact tables (operating expense, market share and targets)
2.	Performed data cleaning and ETL in power query
4.	Bulit data models (created star schema and snowflake schema diagram)

## task 1:
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














