
use PortfolioProject;

-- Display the entire dataset
select * from [dbo].[Forbes Richest Athletes ]



-- Q. How many distinct players are present in the dataset
select count(distinct Name) as 'Number of players' from [dbo].[Forbes Richest Athletes ]
-- Ans: 533 distinct players are there in the dataset



-- Q. Players present in the dataset
select distinct Name as 'Players',Nationality from [dbo].[Forbes Richest Athletes ]



-- Q. Highest earning by a player in any Year
select Name , Nationality, Earnings, Year from [dbo].[Forbes Richest Athletes ] 
where Earnings = 
(Select MAX(Earnings) from dbo.[Forbes Richest Athletes ])
-- Ans: Floyd Mayweather of USA earned 300 million USD in 2015 which is the highest



-- Q. Highest earning by a player every Year
with cte2 as (
select year,max(earnings) as 'Highest_Earnings' from dbo.[Forbes Richest Athletes ] 
group by year )
select b.name, a.Year, CONCAT(Highest_Earnings,' Million') as 'Earnings' from cte2 a join dbo.[Forbes Richest Athletes ] b on
(a.year = b.year) and (a.Highest_Earnings = b.Earnings) order by a.Year



-- Q. Countries and number of rich players belonging to each country
select Nationality , count(distinct Name) as 'Number of players' from [dbo].[Forbes Richest Athletes ]
group by Nationality
order by 'Number of players' DESC
-- Ans: 391 players from USA have appeared in Forbes richest players list which is the highest from any country followed by UK and Spain



-- Q. Countries and total earnings in Million USD of rich players belonging to each country
select Nationality , round(sum(Earnings),2) as 'Total Earnings' from [dbo].[Forbes Richest Athletes ]
group by Nationality
order by 'Total Earnings' DESC
-- Ans: Players from USA have had the highest total earnings over years followed by players from UK and Argentina



-- Q. Players playing which sport have appeared the most and their total earnings
select Sport , count(distinct Name) as 'Number of players', round(sum(Earnings),2) as 'Total Earnings' 
from [dbo].[Forbes Richest Athletes ]
group by Sport
order by 'Total Earnings' DESC,  'Number of players' DESC
-- Ans: Even though number of players who play Football appeared the highest number of times, Earnings of Basketball players are more
--      compared to Football players



-- Q. Player,the number of times they have appeared in the list, sport they play and their total earnings
select Name,Sport, count(*) as 'Appearances', round(sum(Earnings),2) as 'Total Earnings' 
from [dbo].[Forbes Richest Athletes ]
group by Name, Sport
order by 'Appearances' DESC
-- Ans: Tiger Woods who plays Golf has appeared 25 times in the list which is the highest by any player of any sport



-- Q. Different sports and player who has appeared most number of times playing that sport

-- This query will give you only one player per sport
select distinct Sport ,

(
select TOP 1 name 
from [dbo].[Forbes Richest Athletes ] b
where b.sport = a.sport
group by name
order by count(*) DESC 
) 
as 'Name' ,

(
select TOP 1 count(*)
from [dbo].[Forbes Richest Athletes ] b
where b.sport = a.sport
group by name
order by count(*) DESC 
) 
as 'Appearances' 

from [dbo].[Forbes Richest Athletes ] a
order by 'Appearances' DESC


--CREATE VIEW sport_rank as 
--(
--select distinct name, sport, 
--count(*) over(partition by sport,name order by sport )  as 'Appearances' 
--from [dbo].[Forbes Richest Athletes ]
--)


--This query gives all the players who appeared highest number of times
with cte1 as 
(
select name, sport ,Appearances, dense_rank() over(partition by sport order by Appearances DESC) as Rank_ from sport_rank
)
select * from cte1 where Rank_ = 1 order by Appearances DESC






-- USA Numbers

-- Q. Earnings of players belonging to USA
select Name, Nationality , round(sum(Earnings),2) as 'Total Earnings' from [dbo].[Forbes Richest Athletes ]
where Nationality = 'USA'
group by Name, Nationality
order by 'Total Earnings' DESC
-- Ans: Tiger Woods has the highest earnings over the years followed by LeBron James and Floyd Mayweather 



-- Q. Different sports and players belonging to USA who has appeared most number of times playing that sport

--CREATE VIEW sport_rank_country as 
--(
--select distinct name, sport, Nationality,
--count(*) over(partition by sport,name order by sport )  as 'Appearances' 
--from [dbo].[Forbes Richest Athletes ]
--)

with cte3 as 
(
select name, sport ,Appearances, nationality, dense_rank() over(partition by sport order by Appearances DESC) as Rank_ from sport_rank_country
)
select * from cte3 where Rank_ = 1 and nationality = 'USA'order by Appearances DESC 



-- Q. Player,the number of times they have appeared in the list, sport they play and their total earnings
select Name,Sport,count(*) as 'Appearances', round(sum(Earnings),2) as 'Total Earnings' 
from [dbo].[Forbes Richest Athletes ] where Nationality = 'USA'
group by Name, Sport
order by 'Appearances' DESC



-- Q. Players of USA playing which sport have appeared the most and their total earnings
select Sport , count(distinct Name) as 'Number of players', round(sum(Earnings),2) as 'Total Earnings' 
from [dbo].[Forbes Richest Athletes ] where Nationality = 'USA'
group by Sport
order by 'Total Earnings' DESC,  'Number of players' DESC
-- Ans: Even though number of players who play Football appeared the highest number of times, Earnings of Basketball players are more
--      compared to Football players



-- Q. Highest earning by a players of USA in any Year
select Name , Nationality, Earnings, Year from [dbo].[Forbes Richest Athletes ] 
where Earnings = 
(Select MAX(Earnings) from dbo.[Forbes Richest Athletes ] WHERE Nationality = 'USA') and Nationality = 'USA'
-- Ans: Floyd Mayweather of USA earned 300 million USD in 2015 which is the highest



-- Q. Highest earning by an Indian player every Year
with cte2 as (
select year,max(earnings) as 'Highest_Earnings' from dbo.[Forbes Richest Athletes ] 
where Nationality = 'USA'
group by year )
select b.name, a.Year, CONCAT(Highest_Earnings,' Million') as 'Earnings' from 
cte2 a join dbo.[Forbes Richest Athletes ] b 
on
(a.year = b.year) and (a.Highest_Earnings = b.Earnings) 
where b.Nationality = 'USA'
order by a.Year



-- Q. Was a USA player's earning the highest any Year
with cte2 as (
select year,max(earnings) as 'Highest_Earnings' from dbo.[Forbes Richest Athletes ] 
group by year )
select b.name, a.Year, CONCAT(Highest_Earnings,' Million') as 'Earnings' from 
cte2 a join dbo.[Forbes Richest Athletes ] b 
on
(a.year = b.year) and (a.Highest_Earnings = b.Earnings) 
where b.Nationality = 'USA'
order by a.Year





-- Indian Numbers

-- Q. Earnings of players belonging to India
select Name, Nationality , round(sum(Earnings),2) as 'Total Earnings' from [dbo].[Forbes Richest Athletes ]
where Nationality = 'India'
group by Name, Nationality
order by 'Total Earnings' DESC
-- Ans: Mahendra Singh Dhoni has the highest earnings over the years followed by Virat and Sachin



-- Q. Different sports and players belonging to India who has appeared most number of times playing that sport

with cte4 as 
(
select name, sport ,Appearances, nationality, dense_rank() over(partition by sport order by Appearances DESC) as Rank_ from sport_rank_country
)
select * from cte4 where Rank_ = 1 and nationality = 'India' order by Appearances DESC 



-- Q. Player of India and the number of times they have appeared in the list, sport they play and their total earnings
select Name,Sport,count(*) as 'Appearances', round(sum(Earnings),2) as 'Total Earnings' 
from [dbo].[Forbes Richest Athletes ] where Nationality = 'India'
group by Name, Sport
order by 'Appearances' DESC



-- Q. Players of India playing which sport have appeared the most and their total earnings
select Sport , count(distinct Name) as 'Number of players', round(sum(Earnings),2) as 'Total Earnings' 
from [dbo].[Forbes Richest Athletes ] where Nationality = 'India'
group by Sport
order by 'Total Earnings' DESC,  'Number of players' DESC



-- Q. Highest earning by a players of India in any Year
select Name , Nationality, Earnings, Year from [dbo].[Forbes Richest Athletes ] 
where Earnings = 
(Select MAX(Earnings) from dbo.[Forbes Richest Athletes ] where Nationality = 'India') and Nationality = 'India'
-- Ans: MS Dhoni earned 31.5 million USD in 2013 which is the highest for an indian in Forbes list



-- Q. Highest earning by an Indian player every Year
with cte2 as (
select year,max(earnings) as 'Highest_Earnings' from dbo.[Forbes Richest Athletes ] 
where Nationality = 'India'
group by year )
select b.name, a.Year, CONCAT(Highest_Earnings,' Million') as 'Earnings' from 
cte2 a join dbo.[Forbes Richest Athletes ] b 
on
(a.year = b.year) and (a.Highest_Earnings = b.Earnings) 
where b.Nationality = 'India'
order by a.Year



-- Q. Was an Indian player's earning the highest any Year
with cte2 as (
select year,max(earnings) as 'Highest_Earnings' from dbo.[Forbes Richest Athletes ] 
group by year )
select b.name, a.Year, CONCAT(Highest_Earnings,' Million') as 'Earnings' from 
cte2 a join dbo.[Forbes Richest Athletes ] b 
on
(a.year = b.year) and (a.Highest_Earnings = b.Earnings) 
where b.Nationality = 'India'
order by a.Year
-- Ans: In none of the years Earnings by Indian players was the highest
