use PortfolioProject;

SELECT * 
FROM PortfolioProject.dbo.olympics_history


-- 1. How many olympics games have been held(Both summer and winter)?

    select count(distinct games) as total_olympic_games
    from olympics_history;


-- 2. List down all Olympics games held so far. (Data issue at 1956-"Summer"-"Stockholm")

    select distinct year,season,city
    from olympics_history
    order by year;


-- 3. Mention the total no of nations who participated in each olympics game?

    with all_countries as
        (select games, nr.region
        from olympics_history oh
        join olympics_history_noc_regions nr ON nr.noc = oh.noc
        group by games, nr.region)
    select games, count(Games) as total_countries
    from all_countries
    group by games
    order by total_countries DESC;


-- 4. Which year saw the highest and lowest no of countries participating in olympics

      with all_countries as
              (select games, nr.region
              from olympics_history oh
              join olympics_history_noc_regions nr ON nr.noc=oh.noc
              group by games, nr.region),
          tot_countries as
              (select games, count(Games) as total_countries
              from all_countries
              group by games)
      select distinct
      concat(first_value(games) over(order by total_countries)
      , ' - '
      , first_value(total_countries) over(order by total_countries)) as Lowest_Countries,
      concat(first_value(games) over(order by total_countries desc)
      , ' - '
      , first_value(total_countries) over(order by total_countries desc)) as Highest_Countries
      from tot_countries;
  

-- 5. Which nation has participated in all of the olympic games
      with tot_games as
              (select count(distinct games) as total_games
              from olympics_history),
          countries as
              (select games, nr.region as country
              from olympics_history oh
              join olympics_history_noc_regions nr ON nr.noc=oh.noc
              group by games, nr.region),
          countries_participated as
              (select country, count(country) as total_participated_games
              from countries
              group by country)
      select cp.*
      from countries_participated cp
      join tot_games tg on tg.total_games = cp.total_participated_games
      order by cp.total_participated_games;


-- 6. Identify the sport which was played in all summer olympics.
      with t1 as
          	(select count(distinct games) as total_games
          	from olympics_history where season = 'Summer'),
          t2 as
          	(select distinct games, sport
          	from olympics_history where season = 'Summer'),
          t3 as
          	(select sport, count(Sport) as no_of_games
          	from t2
          	group by sport)
      select *
      from t3
      join t1 on t1.total_games = t3.no_of_games;


-- 7. Which Sports were just played only once in the olympics.
      with t1 as
          	(select distinct games, sport
          	from olympics_history),
          t2 as
          	(select sport, count(Sport) as no_of_games
          	from t1
          	group by sport)
      select t2.*, t1.games
      from t2
      join t1 on t1.sport = t2.sport
      where t2.no_of_games = 1
      order by t1.sport;


-- 8. Fetch the total no of sports played in each olympic games.
      with t1 as
      	(select distinct games, sport
      	from olympics_history),
        t2 as
      	(select games, count(Games) as no_of_sports
      	from t1
      	group by games)
      select * from t2
      order by no_of_sports desc;


-- 9. Fetch oldest athletes to win a gold medal
    with temp as
            (select name,sex,cast(case when cast(age as varchar) = 'NA' then '0' else cast(age as varchar) end as int) as age
              ,team,games,city,sport, event, medal
            from olympics_history),
        ranking as
            (select *, rank() over(order by age desc) as rnk
            from temp
            where cast(medal as varchar) ='Gold')
    select *
    from ranking
    where rnk = 1;


-- 10. Find the Ratio of male and female athletes participated in all olympic games.
    with t1 as
        	(select sex, count(Sex) as cnt
        	from olympics_history
        	group by sex),
        male_cnt as
        	(select cnt from t1	where sex='M'),
        female_cnt as
        	(select cnt from t1	where Sex = 'F')
    select concat('1 : ', round(cast (a.cnt as decimal) /cast(b.cnt as decimal), 2)) as ratio
    from male_cnt a , female_cnt b;


-- 11. Top 5 athletes who have won the most gold medals.
    with t1 as
            (select name, team, count(Team) as total_gold_medals
            from olympics_history
            where cast(medal as varchar) = 'Gold'
            group by name, team
            ),
        t2 as
            (select *, dense_rank() over (order by total_gold_medals desc) as rnk
            from t1)
    select name, team, total_gold_medals
    from t2
    where rnk <=5;


-- 12. Top 5 athletes who have won the most medals (gold/silver/bronze).
    with t1 as
            (select name, team, count(Name) as total_medals
            from olympics_history
            where medal in ('Gold', 'Silver', 'Bronze')
            group by name, team
            ),
        t2 as
            (select *, dense_rank() over (order by total_medals desc) as rnk
            from t1)
    select name, team, total_medals
    from t2
    where rnk <= 5;


--13. Top 5 most successful countries in olympics. Success is defined by no of medals won.
    with t1 as
            (select nr.region, count(*) as total_medals
            from olympics_history oh
            join olympics_history_noc_regions nr on nr.noc = oh.noc
            where medal <> 'NA'
            group by nr.region
            ),
        t2 as
            (select *, dense_rank() over(order by total_medals desc) as rnk
            from t1)
    select *
    from t2
    where rnk <= 5;


--14. In which Sport/event, India has won highest medals.
    with t1 as
        	(select sport, count(1) as total_medals
        	from olympics_history
        	where medal <> 'NA'
        	and team = 'India'
        	group by sport
        	),
        t2 as
        	(select *, rank() over(order by total_medals desc) as rnk
        	from t1)
    select sport, total_medals
    from t2
    where rnk = 1;


-- 15. Break down all olympic games where india won medal for Hockey and how many medals in each olympic games
    select team, sport, games, count(Team) as total_medals
    from olympics_history
    where medal <> 'NA'
    and team = 'India' and sport = 'Hockey'
    group by team, sport, games
    order by total_medals desc;


-- 16. Mention no of olympic games India has been part of

        select distinct games, nr.region,
		COUNT(games) over() as total_played
        from olympics_history oh
        join olympics_history_noc_regions nr ON nr.noc = oh.noc
		where nr.region = 'India'
        group by games, nr.region;
 

-- 17. Mention no of Indian players who have has been part of each olympics

		with t1 as 
			(
			select distinct games, Name, nr.region
			from olympics_history oh
			join olympics_history_noc_regions nr ON nr.noc = oh.noc
			where nr.region = 'India'
			)
		select distinct Games,
			   COUNT(Games) over(partition by games) as no_of_players
	    from t1
		order by Games


-- 18. Oldest Indian to win a medal
   
-- Gold
	with temp as
        (select name,sex,cast(case when cast(age as varchar) = 'NA' then '0' else cast(age as varchar) end as int) as age
            ,team,games,city,sport, event, medal
        from olympics_history oh
		join olympics_history_noc_regions nr ON nr.noc = oh.noc
		where nr.region = 'India'),
    ranking as
        (select *, rank() over(order by age desc) as rnk
        from temp
        where cast(medal as varchar) ='Gold')
    select *
    from ranking
    where rnk = 1;


-- Any medal
	with temp as
        (select name,sex,cast(case when cast(age as varchar) = 'NA' then '0' else cast(age as varchar) end as int) as age
            ,team,games,city,sport, event, medal
        from olympics_history oh
		join olympics_history_noc_regions nr ON nr.noc = oh.noc
		where nr.region = 'India'),
    ranking as
        (select *, rank() over(order by age desc) as rnk
        from temp
        where cast(medal as varchar) in ('Gold','Silver','Bronze'))
    select *
    from ranking
    where rnk = 1;


-- 19. Top 5 athletes who have won the most gold medals for India.
    with t1 as
            (select name, team,count(Team) as total_gold_medals
            from olympics_history oh
			join olympics_history_noc_regions nr ON nr.noc = oh.noc
			where cast(medal as varchar) = 'Gold' and nr.region = 'India'
            group by name, team
            ),
        t2 as
            (select *, dense_rank() over (order by total_gold_medals desc) as rnk
            from t1 )
    select t2.Name, t2.Team, sport,total_gold_medals
    from t2 join olympics_history on t2.Name = olympics_history.Name
    where rnk <=5;


-- 20. Top 5 athletes who have won the most medals (gold/silver/bronze).


    with t1 as
            (select name, team,count(Team) as total_medals
            from olympics_history oh
			join olympics_history_noc_regions nr ON nr.noc = oh.noc
			where cast(medal as varchar) in ('Gold', 'Silver', 'Bronze')
			and nr.region = 'India'
            group by name, team
            ),
        t2 as
            (select *, dense_rank() over (order by total_medals desc) as rnk
            from t1 )
    select distinct t2.Name, t2.Team, medal, sport,total_medals
    from t2 join olympics_history on t2.Name = olympics_history.Name
    where rnk <=5 and olympics_history.Medal <> 'NA' order by total_medals DESC





	


