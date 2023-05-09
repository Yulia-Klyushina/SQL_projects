select count(*) from world_happyness.`2015`; -- 158
select count(*) from world_happyness.`2016`; -- 157
select count(*) from world_happyness.`2017`; -- 155
select count(*) from world_happyness.`2018`; -- 155
select count(*) from world_happyness.`2019`; -- 156
select count(*) from world_happyness.`2020`; -- 153
select count(*) from world_happyness.`2021`; -- 149
select count(*) from world_happyness.`2022`; -- 147


-- Preparing tables for analysing
select `2016`.Country, `2016`.Region, `2017`.Country from world_happyness.`2016` as `2016`
join world_happyness.`2017` as `2017` on `2016`.Country = `2017`.Country;

-- Add column Region to 2017, 2018, 2019 tables
ALTER table world_happyness.`2017`
add Region text;
Update world_happyness.`2017` t1
join world_happyness.`2015` t2 on t1.Country = t2.Country
set t1.Region = t2.Region;

ALTER table world_happyness.`2018`
add Region text;
Update world_happyness.`2018` t1
join world_happyness.`2015` t2 on t1.`Country or region` = t2.Country
set t1.Region = t2.Region;

ALTER table world_happyness.`2019`
add Region text;
Update world_happyness.`2019` t1
join world_happyness.`2015` t2 on t1.`Country or region` = t2.Country
set t1.Region = t2.Region;

ALTER table world_happyness.`2022`
add Region text;
Update world_happyness.`2022` t1
join world_happyness.`2016` t2 on t1.Country = t2.Country
set t1.Region = t2.Region;

update world_happyness.`2022`
set Region = 'Sub-Saharan Africa' where Country = 'Congo';

update world_happyness.`2022`
set Region = 'Sub-Saharan Africa' where Country = 'Gambia';

update world_happyness.`2022`
set Region = 'Sub-Saharan Africa' where Country = 'Lesotho';

update world_happyness.`2022`
set Region = 'Sub-Saharan Africa' where Country = 'Mozambique';

update world_happyness.`2019`
set Region = 'Sub-Saharan Africa' where `Country or region` = 'Gambia';

update world_happyness.`2015`
set Country = replace(Country, 'Somaliland Region', 'Somalia');

update world_happyness.`2016`
set Country = replace(Country, 'Somaliland Region', 'Somalia')


-- Add Happiness_rank column to 2020 and 2021 tables

select *, rank()over(order by `Ladder score` desc) as happiness_rank from  world_happyness.`2020`;

Alter table  world_happyness.`2020`
add Happiness_rank int;
Update world_happyness.`2020` t1
join (select `Country name`, rank()over(order by `Ladder score` desc) as happiness_rank from  world_happyness.`2020`
) t2 on t1.`Country name` = t2.`Country name`
set t1.Happiness_rank = t2.happiness_rank;

Alter table  world_happyness.`2021`
add Happiness_rank int;
Update world_happyness.`2021` t1
join (select `Country name`, rank()over(order by `Ladder score` desc) as happiness_rank from  world_happyness.`2021`
) t2 on t1.`Country name` = t2.`Country name`
set t1.Happiness_rank = t2.happiness_rank;

-- Add column Year to all tables

Alter table  world_happyness.`2015`
add Year text;
Update world_happyness.`2015`
set Year = (case when Year is null then '2015' end);
update world_happyness.`2015`
set Year = cast(Year as SIGNED);

Alter table  world_happyness.`2016`
add Year text;
Update world_happyness.`2016`
set Year = (case when Year is null then '2016' end);
update world_happyness.`2016`
set Year = cast(Year as SIGNED);

Alter table  world_happyness.`2017`
add Year text;
Update world_happyness.`2017`
set Year = (case when Year is null then '2017' end);
update world_happyness.`2017`
set Year = cast(Year as SIGNED);

Alter table  world_happyness.`2018`
add Year text;
Update world_happyness.`2018`
set Year = (case when Year is null then '2018' end);
update world_happyness.`2018`
set Year = cast(Year as SIGNED);

Alter table  world_happyness.`2019`
add Year text;
Update world_happyness.`2019`
set Year = (case when Year is null then '2019' end);
update world_happyness.`2019`
set Year = cast(Year as SIGNED);

Alter table  world_happyness.`2020`
add Year text;
Update world_happyness.`2020`
set Year = (case when Year is null then '2020' end);
update world_happyness.`2020`
set Year = cast(Year as SIGNED);

Alter table  world_happyness.`2021`
add Year text;
Update world_happyness.`2021`
set Year = (case when Year is null then '2021' end);
update world_happyness.`2021`
set Year = cast(Year as SIGNED);

Alter table  world_happyness.`2022`
add Year text;
Update world_happyness.`2022`
set Year = (case when Year is null then '2022' end);
update world_happyness.`2022`
set Year = cast(Year as SIGNED);

-- Union all tables
create view world_happyness.`2015_2022` as
select Year, Country, Region, Happiness_Rank, Happiness_Score, `Economy (GDP per Capita)` as GDP_per_capita,
Family as Social_support, `Health (Life Expectancy)` as Health_life_Expectancy, Freedom, 
`Trust (Government Corruption)` as Government_Corruption, Generosity from world_happyness.`2015`
union
select Year, Country, Region, `Happiness Rank` as Happiness_Rank, `Happiness Score` as Happiness_Score,
`Economy (GDP per Capita)` as GDP_per_capita, Family as Social_support, `Health (Life Expectancy)` as Health_life_Expectancy,
Freedom, `Trust (Government Corruption)` as Government_Corruption, Generosity from world_happyness.`2016`
union
select Year, Country, Region, `Happiness.Rank` as Happiness_Rank, `Happiness.Score` as Happiness_Score,
`Economy..GDP.per.Capita.` as GDP_per_capita, Family as Social_support, `Health..Life.Expectancy.` as Health_life_Expectancy,
Freedom, `Trust..Government.Corruption.` as Government_Corruption, Generosity from world_happyness.`2017`
union
select Year, `Country or region` as Country, Region, `Overall rank` as Happiness_Rank, Score as Happiness_Score,
`GDP per capita` as GDP_per_capita, `Social support` as Social_support, `Healthy life expectancy` as Health_life_Expectancy,
`Freedom to make life choices` as Freedom, `Perceptions of corruption` as Government_Corruption, Generosity from world_happyness.`2018`
union
select Year, `Country or region` as Country, Region, `Overall rank` as Happiness_Rank, Score as Happiness_Score,
`GDP per capita` as GDP_per_capita, `Social support` as Social_support, `Healthy life expectancy` as Health_life_Expectancy,
`Freedom to make life choices` as Freedom, `Perceptions of corruption` as Government_Corruption, Generosity from world_happyness.`2019`
union
select Year, `Country name` as Country, `Regional indicator` as Region, `Happiness_rank` as Happiness_Rank, `Ladder score` as Happiness_Score,
`Explained by: Log GDP per capita` as GDP_per_capita, `Explained by: Social support` as Social_support, `Explained by: Healthy life expectancy` as Health_life_Expectancy,
`Explained by: Freedom to make life choices` as Freedom, `Explained by: Perceptions of corruption` as Government_Corruption, `Explained by: Generosity` as Generosity from world_happyness.`2020`
union
select Year, `Country name` as Country, `Regional indicator` as Region, `Happiness_rank` as Happiness_Rank, `Ladder score` as Happiness_Score,
`Explained by: Log GDP per capita` as GDP_per_capita, `Explained by: Social support` as Social_support, `Explained by: Healthy life expectancy` as Health_life_Expectancy,
`Explained by: Freedom to make life choices` as Freedom, `Explained by: Perceptions of corruption` as Government_Corruption, `Explained by: Generosity` as Generosity from world_happyness.`2021`
union
select Year, Country, Region, `RANK` as Happiness_Rank, `Happiness score` as Happiness_Score,
`Explained by: GDP per capita` as GDP_per_capita, `Explained by: Social support` as Social_support, `Explained by: Healthy life expectancy` as Health_life_Expectancy,
`Explained by: Freedom to make life choices` as Freedom, `Explained by: Perceptions of corruption` as Government_Corruption, `Explained by: Generosity` as Generosity from world_happyness.`2022`;

select * from (select Year, Country, Region, Happiness_Rank, Happiness_Score, `Economy (GDP per Capita)` as GDP_per_capita,
Family as Social_support, `Health (Life Expectancy)` as Health_life_Expectancy, Freedom, 
`Trust (Government Corruption)` as Government_Corruption, Generosity from world_happyness.`2015`
union
select Year, Country, Region, `Happiness Rank` as Happiness_Rank, `Happiness Score` as Happiness_Score,
`Economy (GDP per Capita)` as GDP_per_capita, Family as Social_support, `Health (Life Expectancy)` as Health_life_Expectancy,
Freedom, `Trust (Government Corruption)` as Government_Corruption, Generosity from world_happyness.`2016`
union
select Year, Country, Region, `Happiness.Rank` as Happiness_Rank, `Happiness.Score` as Happiness_Score,
`Economy..GDP.per.Capita.` as GDP_per_capita, Family as Social_support, `Health..Life.Expectancy.` as Health_life_Expectancy,
Freedom, `Trust..Government.Corruption.` as Government_Corruption, Generosity from world_happyness.`2017`
union
select Year, `Country or region` as Country, Region, `Overall rank` as Happiness_Rank, Score as Happiness_Score,
`GDP per capita` as GDP_per_capita, `Social support` as Social_support, `Healthy life expectancy` as Health_life_Expectancy,
`Freedom to make life choices` as Freedom, `Perceptions of corruption` as Government_Corruption, Generosity from world_happyness.`2018`
union
select Year, `Country or region` as Country, Region, `Overall rank` as Happiness_Rank, Score as Happiness_Score,
`GDP per capita` as GDP_per_capita, `Social support` as Social_support, `Healthy life expectancy` as Health_life_Expectancy,
`Freedom to make life choices` as Freedom, `Perceptions of corruption` as Government_Corruption, Generosity from world_happyness.`2019`
union
select Year, `Country name` as Country, `Regional indicator` as Region, `Happiness_rank` as Happiness_Rank, `Ladder score` as Happiness_Score,
`Explained by: Log GDP per capita` as GDP_per_capita, `Explained by: Social support` as Social_support, `Explained by: Healthy life expectancy` as Health_life_Expectancy,
`Explained by: Freedom to make life choices` as Freedom, `Explained by: Perceptions of corruption` as Government_Corruption, `Explained by: Generosity` as Generosity from world_happyness.`2020`
union
select Year, `Country name` as Country, `Regional indicator` as Region, `Happiness_rank` as Happiness_Rank, `Ladder score` as Happiness_Score,
`Explained by: Log GDP per capita` as GDP_per_capita, `Explained by: Social support` as Social_support, `Explained by: Healthy life expectancy` as Health_life_Expectancy,
`Explained by: Freedom to make life choices` as Freedom, `Explained by: Perceptions of corruption` as Government_Corruption, `Explained by: Generosity` as Generosity from world_happyness.`2021`
union
select Year, Country, Region, `RANK` as Happiness_Rank, `Happiness score` as Happiness_Score,
`Explained by: GDP per capita` as GDP_per_capita, `Explained by: Social support` as Social_support, `Explained by: Healthy life expectancy` as Health_life_Expectancy,
`Explained by: Freedom to make life choices` as Freedom, `Explained by: Perceptions of corruption` as Government_Corruption, `Explained by: Generosity` as Generosity from world_happyness.`2022`) t order by Country, `Year`;

select count(*) from world_happyness.`2015_2022`; -- 1229

