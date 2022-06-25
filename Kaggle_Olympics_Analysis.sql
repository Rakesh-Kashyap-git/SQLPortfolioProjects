use PortfolioProject;

select * from PortfolioProject.dbo.olympics_history;

-- 1. How many olympics games have been held?

    select count(distinct games) as total_olympic_games
    from olympics_history;
--  Ans: 51


-- 2. List down all Olympics games held so far.

    select distinct year,season,city
    from olympics_history
    order by year;


-- 3. Mention the total no of nations who participated in each olympics game?

    with all_countries as
        (select games, nr.region
        from olympics_history oh
        join olympics_history_noc_regions nr ON nr.noc = oh.noc
        group by games, nr.region)
    select games, count(games) as total_countries
    from all_countries
    group by games
    order by total_countries;

	 