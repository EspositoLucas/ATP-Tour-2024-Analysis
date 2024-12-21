-- Exploratory Analysis: ATP Tour 2024 Overview

alter TABLE `atp_tour_2024`.`atp_2024_results` 
CHANGE COLUMN `Runner Up` `Runner_Up` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Winner ATP Ranking (Current)` `Winner_ATP_Ranking_Current` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Runner Up ATP Ranking (Current)` `Runner_Up_ATP_Ranking_Current` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Prize Money` `Prize_Money` TEXT NULL DEFAULT NULL ;

alter table atp_2024_results
modify column `Date` date ;

alter table atp_2024_results
modify column `Prize_Money` decimal;


-- 1: Tournament Overview

-- How many tournaments exist per category? Analyze the distribution of tournaments by category (Grand Slam, Masters, ATP 500, etc.).
select atp.Category, count(atp.Tournament) as Amount_of_Tournaments
from atp_2024_results atp
group by atp.Category
order by 1 ;

-- Which are the top 5 countries with the most tournaments? Identify the regions with the highest tennis activity.
select atp.Country, count(atp.Tournament) as  Amount_of_Tournaments
from atp_2024_results atp
group by atp.Country
order by 2 desc
limit 5 ;

-- What is the average prize per tournament category? Explore how prize money varies across tournament types.
select atp.Category, cast(avg(atp.Prize_Money) as decimal(10,2))  as  Avg_Prize_Per_Tournament
from atp_2024_results atp
group by atp.Category
order by 2 desc
limit 5 ;



-- 2: Player Performance

-- Who are the top 10 players with the most victories and finals? Identify the most dominant players in the circuit.
select atp.Winner, count(*) as Number_of_Victories, (count(*) + (select count(*) from atp_2024_results atp_3
																 where atp.Winner = atp_3.Runner_Up)) as Total_Finals_Played
from atp_2024_results atp
group by atp.Winner
order by 2 desc
limit 10 ;


-- How does player performance vary by surface? Compare the number of wins by surface (Hard, Clay, Grass) and player.
select atp.Winner, atp.Surface, count(*) as Number_of_Victories_by_Surface
from atp_2024_results atp
group by atp.Winner, atp.Surface
order by 2, 3 desc ;


-- 3: Match Results 

-- What is the distribution of sets played in finals? Analyze how many sets are typically played in final matches.
select atp.Tournament, atp.Result, concat(
        (length(atp.Result) - length(REPLACE(Result, ' ', '')) + 1),
        ' sets'
    ) as Sets_Played
from atp_2024_results atp
group by atp.Tournament, atp.Result;


-- Impact on Winner's Ranking: How often do players with a significantly lower ranking win, and what is the ranking difference in those cases?
select atp.Winner, atp.Runner_Up, atp.Tournament, atp.Result, abs(Winner_ATP_Ranking_Current - Runner_Up_ATP_Ranking_Current) as Ranking_Difference
from atp_2024_results atp
where atp.Winner_ATP_Ranking_Current  <=10
order by atp.Winner_ATP_Ranking_Current, 5 ;



-- 4: Economic Impact

-- What is the average value per ATP point by tournament category? Calculate the monetary value generated per ATP point.
select atp.Tournament, atp.Category, round(avg(atp.Prize_Money/ atp.Points),2) as Average_value_per_ATP_point_by_tournament_category
from atp_2024_results atp
group by atp.Tournament, atp.Category
order by 3 desc ;


-- Which tournaments offer the highest prize money? Highlight events with the largest monetary rewards.
select atp.Tournament, atp.Category, atp.Prize_Money 
from atp_2024_results atp
order by 3 desc
limit 10 ;


-- Which category offer the highest prize money? Highlight categories with the largest monetary rewards.
select atp.Category, sum(atp.Prize_Money) as Total_Category_Prize_Money
from atp_2024_results atp
group by atp.Category
order by 2 desc ;



-- 5: Temporal Trends


-- How does the distribution of surfaces change throughout the year? Analyze which surfaces are most frequent in each season.
select
    atp.Surface,
    case 
        when atp.Date between '2024-01-01' and '2024-03-21' then 'Winter'
        when atp.Date between '2024-03-22' and '2024-06-21' then 'Spring'
        when atp.Date between '2024-06-22' and '2024-09-21' then 'Summer'
        else 'Fall'
    end as Season,
    COUNT(*) as Frequency
from atp_2024_results atp
group by 
    atp.Surface,
    case 
        when atp.Date between '2024-01-01' and '2024-03-21' then 'Winter'
        when atp.Date between '2024-03-22' and '2024-06-21' then 'Spring'
        when atp.Date between '2024-06-22' and '2024-09-21' then 'Summer'
        else 'Fall'
    END;
    

-- Which player dominates each season? Identify the player with the most wins each season
select
    atp.Winner, atp.Surface,
    case 
        when atp.Date between '2024-01-01' and '2024-03-21' then 'Winter'
        when atp.Date between '2024-03-22' and '2024-06-21' then 'Spring'
        when atp.Date between '2024-06-22' and '2024-09-21' then 'Summer'
        else 'Fall'
    end as Season,
    COUNT(*) as Wins
from atp_2024_results atp
group by 
    atp.Winner, atp.Surface,
    case 
        when atp.Date between '2024-01-01' and '2024-03-21' then 'Winter'
        when atp.Date between '2024-03-22' and '2024-06-21' then 'Spring'
        when atp.Date between '2024-06-22' and '2024-09-21' then 'Summer'
        else 'Fall'
    END
order by 2, 4 desc;



-- 6: Regional Analysis

-- Which surface dominates in each country or region? Explore the most commonly used surfaces by region or country.
select atp.Surface, atp.Country,count(atp.Surface) as Amount_Times_Surface_Used
from atp_2024_results atp
group by atp.Surface,atp.Country
order by 1, 3 desc ;


-- How many local champions has each country produced? Relate champions to tournaments held in their home countries.
ALTER TABLE atp_2024_results
ADD COLUMN Winner_Nationality VARCHAR(100);

UPDATE atp_2024_results 
SET Winner_Nationality = 
    CASE Winner
    
        WHEN 'Jannik Sinner' THEN 'Italy'
        WHEN 'Carlos Alcaraz' THEN 'Spain'
        WHEN 'Alexander Zverev' THEN 'Germany'
        WHEN 'Andrey Rublev' THEN 'Russia'
        WHEN 'Grigor Dimitrov' THEN 'Bulgaria'
        WHEN 'Casper Ruud' THEN 'Norway'
        WHEN 'Taylor Fritz' THEN 'United States'
        WHEN 'Alex de Minaur' THEN 'Australia'
        WHEN 'Ji?í Lehe?ka' THEN 'Czech Republic'
        WHEN 'Alejandro Tabilo' THEN 'Chile'
        WHEN 'Alexander Bublik' THEN 'Kazakhstan'
        WHEN 'Tommy Paul' THEN 'United States'
        WHEN 'Ugo Humbert' THEN 'France'
        WHEN 'Luciano Darderi' THEN 'Italy'
        WHEN 'Facundo Diaz Acosta' THEN 'Argentina'
        WHEN 'Sebastian Baez' THEN 'Argentina'
        WHEN 'Karen Khachanov' THEN 'Russia'
        WHEN 'Jordan Thompson' THEN 'Australia'
        WHEN 'Ben Shelton' THEN 'United States'
        WHEN 'Mateo Berrettini' THEN 'Italy'
        WHEN 'Hubert Hurkacz' THEN 'Poland'
        WHEN 'Stefanos Tsitsipas' THEN 'Greece'
        WHEN 'Márton Fucsovics' THEN 'Hungary'
        WHEN 'Jan-Lennard Struff' THEN 'Germany'
        WHEN 'Giovanni Mpetshi Perricard' THEN 'France'
        WHEN 'Jack Draper' THEN 'Great Britain'
        WHEN 'Arthur Fils' THEN 'France'
        WHEN 'Marcos Giron' THEN 'United States'
        WHEN 'Nuno Borges' THEN 'Portugal'
        WHEN 'Matteo Berrettini' THEN 'Italy'
        WHEN 'Francisco Cerúndolo' THEN 'Argentina'
        WHEN 'Yoshihito Nishioka' THEN 'Japan'
        WHEN 'Sebastian Korda' THEN 'United States'
        WHEN 'Alexei Popyrin' THEN 'Australia'
        WHEN 'Lorenzo Sonego' THEN 'Italy'
        WHEN 'Shang Juncheng' THEN 'China'
        WHEN 'Marin ?ili?' THEN 'Croatia'
        WHEN 'Roberto Bautista Agut' THEN 'Spain'
        WHEN 'Denis Shapovalov' THEN 'Canada'
        WHEN 'Benjamin Bonzi' THEN 'France'
    END;
    
    
select atp.Country, count(atp.Winner) as Local_Champions
from atp_2024_results atp
where atp.Winner_Nationality = atp.Country
group by atp.Country ;









