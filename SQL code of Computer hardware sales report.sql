-- product sales report agrregated by month, customer Croma india FY=2021
-- report fields:
-- month, product name, variant, sold quantity, gross price per item, gross prcie total
-- drop view monthly_product_sales;
create view monthly_product_sales as
(SELECT 
s.date,
s.product_code,
s.customer_code,
s.sold_quantity,
p.product as product_name,
p.variant,
gross_price as Gross_price_per_item,
round(s.sold_quantity*gross_price,2) as Gross_price_total
FROM gdb0041.fact_sales_monthly s
left join dim_product p 
on s.product_code = p.product_code
left join fact_gross_price gp
on s.product_code = gp.product_code and get_fiscal_year(s.date) = gp.fiscal_year
where customer_code = (select customer_code from 
dim_customer where customer = "Croma") and get_fiscal_year(s.date) = 2021)
order by date;

select * from monthly_product_sales;

# gross monthly sales for Croma by creating  stored procedure gross 
select s.date,
round(sum(gp.gross_price* s.sold_quantity),2) as gross_sales_total 
from fact_sales_monthly s
join dim_product p
on s.product_code = p.product_code	
join fact_gross_price gp
on s.product_code = gp.product_code and get_fiscal_year(s.date) = gp.fiscal_year
where customer_code = 90002002
group by 1
order by date;

# NOTE : amazon has two customer_code in the system , stored procedure need to be modified
# using function --- find_in_set (s.customer_code, in_customer_code)>0



# create stored proc for market badge (input : market , fiscal_year)
# ---India ,2021 ---Gold
# Srilanka, 2020 --- Silver

# below is my-version of stored procedure
DELIMITER $$
CREATE PROCEDURE `get_market_badge_2`(IN in_market varchar(45),
IN in_fiscal_year int)
BEGIN
-- -- # retrive total qty for a given marekt + fiscal_year
select sum(s.sold_quantity) as total_qty,
case when sum(s.sold_quantity) > 5000000 then "Gold"
else "Silver"
End as market_badge
from fact_sales_monthly s
join dim_customer c
on s.customer_code = c.customer_code
where get_fiscal_year(s.date) = in_fiscal_year 
and c.market = in_market
group by c.market;
END $$
DELIMITER ;

# below is codebasics version of stored procedure for market badge 
DELIMITER $$
 CREATE  PROCEDURE `get_market_badge`(
IN in_market varchar(45),
 IN in_fiscal_year int, 
 out out_badge varchar(45)
)
BEGIN
-- -- -- # retrive total qty for a given marekt + fiscal_year
declare qty int default 0;
-- -- -- #set default market to be India 
if in_market ="" then  
   set in_market = "India";
end if;

--  retrive total qty for a given market and FY, (select...into variable --- used in stored procedure)
select sum(s.sold_quantity) into qty
from fact_sales_monthly s
join dim_customer c
on s.customer_code = c.customer_code
where get_fiscal_year(s.date) = in_fiscal_year 
and c.market = in_market
group by c.market;

# determine market badge , if statement in stored proc differenet from regular sql statement
if qty > 5000000 then 
   set out_badge = "Gold";
else
   set out_badge ="Silver";
end if;
 # determine market badge
END $$
DELIMITER ;

# improve performance 

# create stored procedure for TOP N market / customer / product
# improve performance 



with sales_pre_inv_dct as 
(SELECT 
s.date,
s.product_code,
s.customer_code,
s.sold_quantity,
p.product as product_name,
p.variant,
gross_price as Gross_price_per_item,
round(s.sold_quantity*gross_price,2) as Gross_price_total,
pre_invoice_discount_pct
FROM gdb0041.fact_sales_monthly s
left join dim_product p 
on s.product_code = p.product_code
left join fact_gross_price gp
on s.product_code = gp.product_code and get_fiscal_year(s.date) = gp.fiscal_year
left join fact_pre_invoice_deductions pre
on s.customer_code = pre.customer_code 
and get_fiscal_year(s.date) = pre.fiscal_year
where get_fiscal_year(s.date) = 2021
order by date
limit 1000000
)
select *,
(Gross_price_total-Gross_price_total*pre_invoice_discount_pct) as net_inv_sales
from cte1;



-- performance enhancement 1 by creating dim_date table to join to get fiscal year
EXPLAIN ANALYZE
SELECT 
s.date,
d.fiscal_year,
s.product_code,
s.customer_code,
s.sold_quantity,
p.product as product_name,
p.variant,
gross_price as Gross_price_per_item,
round(s.sold_quantity*gross_price,2) as Gross_price_total,
pre_invoice_discount_pct
FROM gdb0041.fact_sales_monthly s
join dim_date d
on s.date = d.calendar_date
left join dim_product p 
on s.product_code = p.product_code
left join fact_gross_price gp
on s.product_code = gp.product_code and d.fiscal_year = gp.fiscal_year
left join fact_pre_invoice_deductions pre
on s.customer_code = pre.customer_code 
and d.fiscal_year = pre.fiscal_year

where d.fiscal_year = 2021
order by date
limit 1000000;



-- performance enhancement 2 by creating fiscal year column in sales table
SELECT 
s.date,
s.fiscal_year,
s.product_code,
s.customer_code,
s.sold_quantity,
p.product as product_name,
p.variant,
gross_price as Gross_price_per_item,
round(s.sold_quantity*gross_price,2) as Gross_price_total,
pre_invoice_discount_pct
FROM gdb0041.fact_sales_monthly s
left join dim_product p 
on s.product_code = p.product_code
left join fact_gross_price gp
on s.product_code = gp.product_code and s.fiscal_year = gp.fiscal_year
left join fact_pre_invoice_deductions pre
on s.customer_code = pre.customer_code 
and s.fiscal_year = pre.fiscal_year
where s.fiscal_year = 2021
order by date
limit 1000000;



-- -----create view pre-inv_sales

create view sales_pre_inv_dct as
SELECT 
s.date,
s.fiscal_year,
s.customer_code,
c.market,
s.product_code,
p.product as product_name,
p.variant,
s.sold_quantity,
gross_price as Gross_price_per_item,
round(s.sold_quantity*gross_price,2) as Gross_price_total,
pre.pre_invoice_discount_pct
FROM gdb0041.fact_sales_monthly s
left join dim_customer c 
on s.customer_code = c.customer_code
left join dim_product p 
on s.product_code = p.product_code
left join fact_gross_price gp
on s.product_code = gp.product_code and s.fiscal_year = gp.fiscal_year
left join fact_pre_invoice_deductions pre
on s.customer_code = pre.customer_code 
and s.fiscal_year = pre.fiscal_year
order by date;

create view sales_post_inv_dct as
select s.* ,
(Gross_price_total*(1-pre_invoice_discount_pct)) as net_inv_sales,
(po.discounts_pct + po.other_deductions_pct) as post_inv_dct_pct
from sales_pre_inv_dct s
left join fact_post_invoice_deductions  po
on s.date = po.date
and s.customer_code = po.customer_code
and s.product_code = po.product_code;

create view net_sales as 
select s.*,
net_inv_sales(1-post_inv_dct_pct) as net_sales
from sales_post_inv_dct s;



-- create stored procedure for top n product, market, customer by net_sales
select 
c.customer,
round(sum(s.net_sales)/1000000,2) as net_sales_mln
from net_sales s
left join dim_customer c
on s.customer_code = c.customer_code
group by c.customer
order by net_sales_mln desc;



-- Net sales global market share % by customers
with cte2 as 
(select 
c.customer,
round(sum(s.net_sales)/1000000,2) as net_sales_mln  
from net_sales s
left join dim_customer c
on s.fiscal_year = 2021
and s.customer_code = c.customer_code
group by c.customer
order by net_sales_mln desc
)
select *,
net_sales_mln/sum(net_sales_mln)over() as global_share_pct
from cte2;





-- create region-wise net_sales% breakdown  by customer for region analysis
with cte1 as (
select 
    c.region,
    c.customer,
    round(sum(s.net_sales)/1000000,2) as net_sales_cus_rign
from net_sales s
left join dim_customer c
on s.customer_code = c.customer_code
where s.fiscal_year = 2021
group by 1,2 
)
select *,
(net_sales_cus_rign*100/sum(net_sales_cus_rign) over (partition by region)) as sales_share_pct
from cte1
order by region,sales_share_pct desc;



-- create stored procedure for top n product by qty sold per division

with cte1 as
(select 
   p.division,
   p.product,
   sum(sold_quantity) as total_quantity,
   rank() over (partition by division order by sum(sold_quantity) desc) as rk
from fact_sales_monthly s
left join dim_product p
on s.product_code = p.product_code
where s.fiscal_year = 2021
group by 1,2 
)
select * from cte1
where rk <= 3;



-- exercises: top 2 market by gross sales within  each region
with cte1 as
(
SELECT 
c.region,
c.market,
round(sum(s.Gross_price_total)/1000000,2) as total_gross_sales_mln
FROM sales_pre_inv_dct s
left join dim_customer c
on s.customer_code = c.customer_code
where s.fiscal_year = 2021
group by 1,2
),
cte2 as(
select *,
dense_rank() over(partition by region order by total_gross_sales_mln desc) as drnk
from cte1
) 
select * from cte2 
where drnk <=2;



#---supply chain analytics
# using union to create a full join of the two tables-fact sales and fact forecast
create table fact_act_est
(select 
s.date,
s.product_code,
s.customer_code,
s.sold_quantity,
f.forecast_quantity
from fact_sales_monthly s
left join fact_forecast_monthly f
using (date, product_code, customer_code)

union 

select 
f.date,
f.product_code,
f.customer_code,
s.sold_quantity,
f.forecast_quantity
from fact_forecast_monthly f
left join fact_sales_monthly s
using (date, product_code, customer_code));

select * from fact_act_est
where sold_quantity is null;

select * from fact_act_est
where forecast_quantity is null;

-- change null value into 0
set sql_safe_updates = 0;
update fact_act_est
set sold_quantity = 0
where sold_quantity is null; 

update fact_act_est
set forecast_quantity = 0
where forecast_quantity is null;


# create triggers and event (data engineer knwoledge)


-- calculation of net error% and abs error% and forecast_accuracy 
with forecast_error_table as 
(
select f.customer_code,
sum(sold_quantity) as total_sold_qty,
sum(forecast_quantity) as total_forecast_qty,
sum((forecast_quantity - sold_quantity)) as net_error,
sum(abs(forecast_quantity - sold_quantity)) as abs_error,
sum((forecast_quantity - sold_quantity))/sum(forecast_quantity) as net_err_pct,
sum(abs(forecast_quantity - sold_quantity)) /sum(forecast_quantity) as abs_err_pct
from fact_act_est f
where f.fiscal_year =2021
group by customer_code
)
select t.*,
c.customer,
c.market,
if(abs_err_pct>1, 0,(1-abs_err_pct)) as forecast_accuracy
from forecast_error_table t
left join dim_customer c
on t.customer_code = c.customer_code
order by forecast_accuracy desc






