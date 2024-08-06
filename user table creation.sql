create table users(
user_id int,
created_at varchar(500),
company_id int,
language varchar(50),
activated_at varchar(50),
state varchar(50));

show variables like "secure_file_priv";

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users.csv"
into table users
fields terminated by ","
enclosed by '"'
lines terminated by "\n"
ignore 1 rows;

select * from users;

alter table users add column temp_activated_at datetime;

update users set temp_activated_at = str_to_date(activated_at, '%d-%m-%Y %H:%i');

alter table users drop column activated_at;

alter table users change column temp_activated_at activated_at datetime;