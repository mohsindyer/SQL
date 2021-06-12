/*
Mohammed Mohsin Dyer
#V00930385

Taimur Kashif Khan Niazi
#V00913853
 */


-- Create the tables for the S&P 500 database.
-- They contain information about the companies 
-- in the S&P 500 stock market index
-- during some interval of time in 2014-2015.
-- https://en.wikipedia.org/wiki/S%26P_500 

create table history
(
	symbol text,
	day date,
	open numeric,
	high numeric,
	low numeric,
	close numeric,
	volume integer,
	adjclose numeric
);

create table sp500
(
	symbol text,
	security text,
	sector text,
	subindustry text,
	address text,
	state text
);

-- Populate the tables
insert into history select * from bob.history;
insert into sp500 select * from bob.sp500;

-- Familiarize yourself with the tables.
select * from history;
select * from sp500;


-- Exercise 1 (3 pts)

-- 1. (1 pts) Find the number of companies for each state, sort descending by the number.

select state, count(security) from sp500 group by state order by count(security) desc;


-- 2. (1 pts) Find the number of companies for each sector, sort descending by the number.

select sector, count(security) from sp500 group by sector order by count(security) desc;


-- 3. (1 pts) Order the days of the week by their average volatility.
-- Sort descending by the average volatility. 
-- Use 100*abs(high-low)/low to measure daily volatility.

with x as (
     select day, (100*abs(high-low)/low) as volatility
     from history
 )
select extract(dow from day) as day_of_week, avg(volatility) as avg_volatility
from x group by day_of_week order by avg_volatility desc;




-- Exercise 2 (4 pts)

-- 1. (2 pts) Find for each symbol and day the pct change from the previous business day.
-- Order descending by pct change. Use adjclose.


with x as (select day, symbol, adjclose, lag(adjclose,1) over (partition by symbol order by day) as adjclose_prev from history)
select day, symbol, (100*(adjclose-adjclose_prev)/adjclose_prev) as pct_change from x;


-- 2. (2 pts)
-- Many traders believe in buying stocks in uptrend
-- in order to maximize their chance of profit. 
-- Let us check this strategy.
-- Find for each symbol on Oct 1, 2015 
-- the pct change 20 trading days earlier and 20 trading days later.
-- Order descending by pct change with respect to 20 trading days earlier.
-- Use adjclose.

-- Expected result
--symbol,pct_change,pct_change2
--TE,26.0661102331371252,3.0406725557250169
--TAP,24.6107784431137725,5.1057184046131667
--CVC,24.4688922610015175,-0.67052727826882048156
--...

WITH X AS (SELECT symbol, adjclose, day, LAG(adjclose, 20) OVER (PARTITION BY symbol ORDER BY day)
    AS adjclose_prev, LEAD(adjclose, 20) OVER (PARTITION BY symbol ORDER BY day) AS adjclose_post
    FROM history)
SELECT symbol, 100*(adjclose-adjclose_prev)/adjclose_prev AS pct_change,
       100*(adjclose_post-adjclose)/adjclose AS pct_change2
FROM X WHERE day = to_date('October 01, 2015', 'Month DD, YYYY')
ORDER BY pct_change DESC;



-- Exercise 3 (3 pts)
-- Find the top 10 symbols with respect to their average money volume AVG(volume*adjclose).
-- Use round(..., -8) on the average money volume.
-- Give three versions of your query, using ROW_NUMBER(), RANK(), and DENSE_RANK().

select * from
(
 select symbol, round(avg(volume*adjclose),8) as avg_money_volume,
 row_number() over (partition by symbol order by round(avg(volume*adjclose),8) desc) as rank
 from history group by symbol
     ) x order by symbol, rank;

select * from
(
 select symbol, round(avg(volume*adjclose),8) as avg_money_volume,
 rank() over (partition by symbol order by round(avg(volume*adjclose),8) desc) as rank
 from history group by symbol
     ) x order by symbol, rank;

select * from
 (
 select symbol, round(avg(volume*adjclose),8) as avg_money_volume,
 dense_rank() over (partition by symbol order by round(avg(volume*adjclose),8) desc) as rank
 from history group by symbol
     ) x order by symbol, rank;
