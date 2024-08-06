use job_data_db;

CREATE TABLE IF NOT EXISTS job_data (
    `ds` DATETIME,
    `job_id` INT,
    `actor_id` INT,
    `event` VARCHAR(20),
    `language` VARCHAR(20),
    `time_spent` INT,
    `org` VARCHAR(1)
);
INSERT INTO job_data VALUES ('2020-11-30 00:00:00',21,1001,'skip','English',15,'A'),
	('2020-11-30',22,1006,'transfer','Arabic',25,'B'),
	('2020-11-29',23,1003,'decision','Persian',20,'C'),
	('2020-11-28',23,1005,'transfer','Persian',22,'D'),
	('2020-11-28',25,1002,'decision','Hindi',11,'B'),
	('2020-11-27',11,1007,'decision','French',104,'D'),
	('2020-11-26',23,1004,'skip','Persian',56,'A'),
	('2020-11-25',20,1003,'transfer','Italian',45,'C');

select * from job_data;

/* query to calculate the number of jobs reviewed per hour for each day in November 2020. */

SELECT 
    ds AS date,
    COUNT(job_id) `jobs per day`,
    ROUND(SUM(time_spent) / 3600, 2) AS `total time spent hours`,
    ROUND((COUNT(job_id) / SUM(time_spent)) * 3600) AS `jobs reviewed per hr per day`
FROM
    job_data
WHERE
    ds between '2020-11-01' and '2020-11-30'
GROUP BY ds;
    
select * from job_data;

/* query to calculate the 7-day rolling average of throughput. */

SELECT ROUND(COUNT(event)/SUM(time_spent), 2) as `7 day througput` from job_data;

SELECT 
    ds AS Date,
    ROUND(COUNT(event) / SUM(time_spent), 2) AS `Daily throughput`
FROM
    job_data
GROUP BY ds
ORDER BY ds;

/* query to calculate the percentage share of each language over the last 30 days. */

SELECT language,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) from job_data where ds between '2020-11-01' AND '2020-11-30'),2) AS percentage_share
FROM job_data
WHERE ds between '2020-11-01' AND '2020-11-30'
GROUP by language;

select * from job_data;
/* query to display duplicate rows from the job_data table. */

SELECT *
FROM
    job_data
GROUP BY job_id , actor_id , event , language , time_spent , org , ds
HAVING COUNT(*) > 1;




    
    



    
    
