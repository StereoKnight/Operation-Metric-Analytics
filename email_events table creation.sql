create table email_events(
user_id int,
occurred_at varchar(50),
action varchar(100),
user_type int
);

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/email_events.csv"
into table email_events
fields terminated by ","
enclosed by '"'
lines terminated by "\n"
ignore 1 rows;

select * from email_events;

alter table email_events add column temp_occurred_at datetime;

update email_events set temp_occurred_at = str_to_date(occurred_at, '%d-%m-%Y %H:%i');

alter table email_events drop column occurred_at;

alter table email_events change column temp_occurred_at occurred_at datetime;