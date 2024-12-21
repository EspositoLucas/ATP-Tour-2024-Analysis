-- Data Cleaning: ATP Tour 2024 Overview

-- 1. Remove Duplicates

select * from atp_2024_results_errors ;

create table atp_tour_2024_results_staging
like atp_2024_results_errors ;

select * from  atp_tour_2024_results_staging ;

insert atp_tour_2024_results_staging
select * from atp_2024_results_errors ;

select * from atp_tour_2024_results_staging ;

ALTER TABLE atp_tour_2024_results_staging RENAME atp_2024_results_staging ;

ALTER TABLE `atp_tour_2024`.`atp_2024_results_staging` 
CHANGE COLUMN `Runner Up` `Runner_Up` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Winner ATP Ranking (Current)` `Winner_ATP_Ranking_Current` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Runner Up ATP Ranking (Current)` `Runner_Up_ATP_Ranking_Current` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Prize Money` `Prize_Money` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Not Useful Column` `Not_Useful_Column` TEXT NULL DEFAULT NULL ;

select * from atp_2024_results_staging ;

select *, row_number() over (partition by atp.`Date`,atp.Tournament,atp.Location, atp.Country, atp.Country_Error, atp.Category,atp.Surface, atp.Winner, atp.Runner_Up, 
atp.Winner_ATP_Ranking_Current, atp.Runner_Up_ATP_Ranking_Current, atp.Result, atp.Points , atp.Prize_Money, atp.Not_Useful_Column)
from atp_2024_results_staging atp;

with duplicate_cte as
(select *, row_number() over (partition by atp.`Date`,atp.Tournament,atp.Location, atp.Country, atp.Country_Error, atp.Category,atp.Surface, atp.Winner, atp.Runner_Up, 
atp.Winner_ATP_Ranking_Current, atp.Runner_Up_ATP_Ranking_Current, atp.Result, atp.Points , atp.Prize_Money, atp.Not_Useful_Column) as row_num
from atp_2024_results_staging atp
)

select *from duplicate_cte
where row_num > 1;

CREATE TABLE `atp_2024_results_staging_2` (
  `Date` text,
  `Tournament` text,
  `Location` text,
  `Country` text,
  `Country_Error` text,
  `Category` text,
  `Surface` text,
  `Winner` text,
  `Runner_Up` text,
  `Winner_ATP_Ranking_Current` double DEFAULT NULL,
  `Runner_Up_ATP_Ranking_Current` double DEFAULT NULL,
  `Result` text,
  `Points` int DEFAULT NULL,
  `Prize_Money` text,
  `Not_Useful_Column` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from atp_2024_results_staging_2;

insert atp_2024_results_staging_2
select *, row_number() over (partition by atp.`Date`,atp.Tournament,atp.Location, atp.Country, atp.Country_Error, atp.Category,atp.Surface, atp.Winner, atp.Runner_Up, 
atp.Winner_ATP_Ranking_Current, atp.Runner_Up_ATP_Ranking_Current, atp.Result, atp.Points , atp.Prize_Money, atp.Not_Useful_Column) as row_num
from atp_2024_results_staging atp ;

select * from atp_2024_results_staging_2
where row_num > 1;

delete 
from atp_2024_results_staging_2
where row_num > 1;




-- 2. Standardizing the Data

select distinct atp.Country_Error from atp_2024_results_staging_2 atp
where atp.Country_Error like'Ch"%' ;

update atp_2024_results_staging_2 atp
set atp.Country_Error = 'China'
where atp.Country_Error like 'Ch"%';

update atp_2024_results_staging_2 atp
set atp.Country_Error = 'Argentina'
where atp.Country_Error like 'Ar%';

update atp_2024_results_staging_2 atp
set atp.Country_Error = 'Australia'
where atp.Country_Error like 'Aus%';

update atp_2024_results_staging_2 atp
set atp.Country_Error = 'Germany'
where atp.Country_Error like 'Ger%';

update atp_2024_results_staging_2 atp
set atp.Country_Error = 'Netherlands'
where atp.Country_Error like 'Net%';

update atp_2024_results_staging_2 atp
set atp.Country_Error = 'Switzerland'
where atp.Country_Error like 'Swit%';

update atp_2024_results_staging_2 atp
set atp.Country_Error = 'United/Arab - Emirates'
where atp.Country_Error like 'United/%';

update atp_2024_results_staging_2 atp
set atp.Country = 'United/Arab - Emirates'
where atp.Country_Error like 'United/%';

update atp_2024_results_staging_2 atp
set atp.`Date` = str_to_date(atp.`Date`,'%d/%m/%Y');

update atp_2024_results_staging_2 atp
set atp.Country= 'Argentina'
where atp.Country like 'Ar%';

update atp_2024_results_staging_2 atp
set atp.Tournament = 'Argentina'
where atp.Tournament like 'Ar%';

update atp_2024_results_staging_2 atp
set atp.Winner = 'Jannik Sinner'
where atp.Winner like '%Jannik Sinner' or atp.Winner like 'Jannik Sinner%';

update atp_2024_results_staging_2 atp
set atp.Winner = 'Jack Draper'
where atp.Winner like '%Jack Draper';

update atp_2024_results_staging_2 atp
set atp.Winner = 'Denis Shapovalov'
where atp.Winner like 'Denis Shapovalov%';

update atp_2024_results_staging_2 atp
set atp.Winner = 'Alexander Zverev'
where atp.Winner like 'Alexander Zverev%';

update atp_2024_results_staging_2 atp
set atp.Runner_Up = 'Tomáš Macháč'
where atp.Runner_Up like 'Tomáš Machá?';

update atp_2024_results_staging_2 atp
set atp.Runner_Up = 'Jiří Lehečka'
where atp.Runner_Up like 'Ji?í Lehe?ka';

update atp_2024_results_staging_2 atp
set atp.Winner = 'Marin Čilić'
where atp.Winner like 'Marin ?ili?';

select atp.`Date`, str_to_date(atp.`Date`,'%d/%m/%Y')
from atp_2024_results_staging_2 atp;

select atp.`Date`, date_format(atp.`Date`,'%d/%m/%Y')
from atp_2024_results_staging_2 atp;

select * from atp_2024_results_staging_2 atp
where atp.Winner_ATP_Ranking_Current = null
order by month(atp.`Date`) ;

alter table atp_2024_results_staging_2 
modify column `Date` Date;


-- 3. Null Values or blank values

select * from atp_2024_results_staging_2 atp
where atp.Winner_ATP_Ranking_Current is null 
and atp.Runner_Up_ATP_Ranking_Current is null ;

select distinct t1.Winner_ATP_Ranking_Current , t2.Winner_ATP_Ranking_Current, t1.Runner_Up_ATP_Ranking_Current, t2.Runner_Up_ATP_Ranking_Current  
from atp_2024_results_staging_2 t1
join atp_2024_results_staging_2 t2 on t1.Tournament= t2.Tournament
where (t1.Winner_ATP_Ranking_Current is null or t1.Winner_ATP_Ranking_Current='')
and  (t1.Runner_Up_ATP_Ranking_Current is null or t1.Runner_Up_ATP_Ranking_Current='')  
and  t2.Winner_ATP_Ranking_Current is not null 
and  t2.Runner_Up_ATP_Ranking_Current is not null ;


update atp_2024_results_staging_2 t1
join atp_2024_results_staging_2 t2 on t1.Tournament= t2.Tournament
set t1.Winner_ATP_Ranking_Current = t2.Winner_ATP_Ranking_Current, t1.Runner_Up_ATP_Ranking_Current = t2.Runner_Up_ATP_Ranking_Current 
where (t1.Winner_ATP_Ranking_Current is null or t1.Winner_ATP_Ranking_Current='')
and  (t1.Runner_Up_ATP_Ranking_Current is null or t1.Runner_Up_ATP_Ranking_Current='')  
and  t2.Winner_ATP_Ranking_Current is not null 
and  t2.Runner_Up_ATP_Ranking_Current is not null ;

update atp_2024_results_staging_2 t1
join atp_2024_results_staging_2 t2 on t1.Tournament= t2.Tournament
set t1.Winner_ATP_Ranking_Current = t2.Winner_ATP_Ranking_Current
where (t1.Winner_ATP_Ranking_Current is null or t1.Winner_ATP_Ranking_Current='')
and  t2.Winner_ATP_Ranking_Current is not null ;

update atp_2024_results_staging_2 t1
join atp_2024_results_staging_2 t2 on t1.Tournament= t2.Tournament
set t1.Runner_Up_ATP_Ranking_Current = t2.Runner_Up_ATP_Ranking_Current
where (t1.Runner_Up_ATP_Ranking_Current is null or t1.Runner_Up_ATP_Ranking_Current='')
and  t2.Runner_Up_ATP_Ranking_Current is not null ;


-- 4. Remove Any Columns 

alter table atp_2024_results_staging_2 
drop column Not_Useful_Column;

alter table atp_2024_results_staging_2 
drop column row_num;

alter table atp_2024_results_staging_2 
drop column country_error;


-- 5. Remove missing duplicates after cleaning winner and runner_up names and current ranking

with duplicate_cte_2 as
(select *, row_number() over (partition by atp.`Date`,atp.Tournament,atp.Location, atp.Country, atp.Category,atp.Surface, atp.Winner, atp.Runner_Up, 
atp.Winner_ATP_Ranking_Current, atp.Runner_Up_ATP_Ranking_Current, atp.Result, atp.Points , atp.Prize_Money) as row_num
from atp_2024_results_staging_2 atp
)

select *from duplicate_cte_2
where row_num > 1;


CREATE TABLE `atp_2024_results_staging_3` (
  `Date` date,
  `Tournament` text,
  `Location` text,
  `Country` text,
  `Category` text,
  `Surface` text,
  `Winner` text,
  `Runner_Up` text,
  `Winner_ATP_Ranking_Current` double DEFAULT NULL,
  `Runner_Up_ATP_Ranking_Current` double DEFAULT NULL,
  `Result` text,
  `Points` int DEFAULT NULL,
  `Prize_Money` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from atp_2024_results_staging_3;

insert atp_2024_results_staging_3
select *, row_number() over (partition by atp.`Date`,atp.Tournament,atp.Location, atp.Country, atp.Category,atp.Surface, atp.Winner, atp.Runner_Up, 
atp.Winner_ATP_Ranking_Current, atp.Runner_Up_ATP_Ranking_Current, atp.Result, atp.Points , atp.Prize_Money) as row_num
from atp_2024_results_staging_2 atp ;

select * from atp_2024_results_staging_3
where row_num > 1;

delete 
from atp_2024_results_staging_3
where row_num > 1;

select * from atp_2024_results_staging_3
order by `Date`;

update atp_2024_results_staging_3
set `Date` = '2024-02-18'
where `Date` = '2025-02-18' ;

update atp_2024_results_staging_3 atp
set atp.Tournament = 'Argentina Open'
where atp.Tournament like 'Ar%';

delete 
from atp_2024_results_staging_3
where Tournament like 'ATP Finals' and Prize_Money like'€ 579,320';

delete 
from atp_2024_results_staging_3
where Tournament = 'Swiss Indoors' ;

alter table atp_2024_results_staging_3 
drop column row_num;

insert atp_2024_results_staging_3 ( `Date`, Tournament, Location, Country, Category,Surface, Winner, Runner_Up, Winner_ATP_Ranking_Current, Runner_Up_ATP_Ranking_Current, Result, Points, Prize_Money) 
values('2024-10-27', 'Swiss Indoors', 'Basel', 'Switzerland','ATP 500', 'Hard', 'Giovanni Mpetshi Perricard', 'Ben Shelton', '31.00', '21.00', '6–4 7–6(7–4)', '500', '€2,385,100');	








