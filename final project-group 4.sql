--Final Project 13
--drop database if exists final659
--GO
--create database final659
--GO

use gymgroup4
GO

--drop
drop table if exists employee_vacation_requests 
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_employee_vacation_requests_request_approved_employee_id')
    alter table employee_vacation_requests drop constraint fk_employee_vacation_requests_request_approved_employee_id
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_employee_vacation_requests_request_manager_id')
    alter table employee_vacation_requests drop constraint fk_employee_vacation_requests_request_manager_id
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_payments_payment_type')
    alter table payments drop constraint fk_payments_payment_type
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_payments_payment_member_id')
    alter table payments drop constraint fk_payments_payment_member_id
drop table if exists payments 
drop table if exists payment_types
drop table if exists messages 
drop table if exists employees_courses
drop table if exists members_courses
drop table if exists employees
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_courses_course_week')
    alter table courses drop constraint fk_courses_course_week
drop table if exists courses_week
drop table if exists courses
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_members_member_manager_id')
    alter table members drop constraint fk_members_member_manager_id
drop table if exists managers 
drop table if exists members 
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_members_member_manager_type')
    alter table members drop constraint fk_members_member_manager_type 
drop table if exists cardplans 
Go

--UP
--members
create table members (
    member_id int identity not null,
    member_firstname varchar(20) not null,
    member_lastname varchar(20) not null,
    member_login_password varchar(50) not null,
    member_gender varchar(20) not null,
    member_email varchar(50) not null,
    member_age int not null,
    member_phone varchar(10),
    member_start_date date not null,
    member_expire_date date not null,
    member_card_id varchar(6),
    member_card_type int,
    member_street varchar(50),
    member_city varchar(20),
    member_state varchar(20),
    member_postalcode varchar(5) not null,
    member_manager_id int not null,
    CONSTRAINT pk_members_member_id PRIMARY KEY (member_id),
    constraint u_members_member_email UNIQUE (member_email),
    constraint ck_valid_member_dates
        check (member_start_date<=member_expire_date )
)

alter table members add constraint ck_psw check(len(member_login_password)>=8)


--managers
create table managers(
    manager_id int identity not null,
    login_firstname varchar(20) not null,
    login_lastname varchar(20) not null,
    login_password VARCHAR(50) not null,
    manager_email varchar(50) not NULL,
    constraint pk_managers_manager_id PRIMARY key (manager_id),
    CONSTRAINT u_managers_manager_email UNIQUE (manager_email)
)
alter table members ADD CONSTRAINT fk_members_member_manager_id foreign KEY (member_manager_id) references managers(manager_id)
alter table managers add constraint ck_managers_psw check(len(login_password)>=8)


--cardplans
create TABLE cardplans(
    plan_id int identity not null,
    plan_type varchar(20) not null,
    plan_price money not null,
    CONSTRAINT pk_cardplans_plan_id PRIMARY KEY (plan_id)
)
alter table members ADD CONSTRAINT fk_members_member_card_type foreign KEY (member_card_type) references cardplans(plan_id)


--Course 
create table courses(
    course_id int IDENTITY not null,
    course_name varchar(20) not null,
    course_time int not null,
    course_week int,
    course_start_time time Null,
    course_end_time time Null,
    course_room int,
    course_type varchar(20) not Null,
    constraint pk_courses_course_id primary key (course_id),
    constraint ck_valid_course_time
        check (course_start_time<=course_end_time )
)


--courses_week
create table courses_week(
    week_id int IDENTITY not NULL,
    week_name varchar(20),
    constraint pk_courses_week_id primary key (week_id)
)
alter table courses 
    add constraint  fk_courses_course_week foreign key (course_week)
        references courses_week(week_id)



--employees
create table employees(
    employee_id int IDENTITY not null,
    employee_firstname varchar(20) not null,
    employee_lastname varchar(20) not null,
    employee_date_of_birth datetime not null,
    employee_email varchar(50) not null,
    employee_phonenumber varchar(10) not null,
    employee_street varchar(50) not null,
    employee_city varchar(20) not null,
    employee_state varchar(20) not null,
    employee_postalcode int not null,
    employee_gender varchar(10) not null,
    employee_login_password varchar(50) not null,
    CONSTRAINT pk_employees_employee_id PRIMARY key (employee_id),
    CONSTRAINT u_employees_employee_email unique (employee_email)
)
alter table employees add constraint ck_employees_psw check(len(employee_login_password)>=8)


--members_courses
create table members_courses(
    enroll_id int IDENTITY not null,
    course_id int not null,
    member_id int not null,
    enroll_time datetime not null,
    CONSTRAINT pk_members_courses_enroll_id PRIMARY key (enroll_id),
    CONSTRAINT fk_members_courses_member_id FOREIGN key (member_id) REFERENCES members(member_id),
    CONSTRAINT fk_members_courses_course_id FOREIGN KEY (course_id) REFERENCES courses(course_id)
)


--employees_courses
create table employees_courses(
    assign_id int IDENTITY not null,
    employee_id int not null,
    course_id int not null
    constraint pk_employees_courses_assign_id PRIMARY key (assign_id),
    CONSTRAINT fk_employees_courses_employee_id foreign key (employee_id) REFERENCES employees(employee_id),
    CONSTRAINT fk_employees_courses_course_id FOREIGN key (course_id) REFERENCES courses(course_id)
)


--messages
create table messages(
    message_id int IDENTITY not null,
    message_publish_time datetime not null,
    message_member_id int not null,
    massage_detail varchar(300) not null,
    CONSTRAINT pk_messages_message_id PRIMARY KEY (message_id),
    CONSTRAINT fk_messages_message_member_id foreign key (message_member_id) REFERENCES members(member_id)
)


--payment types
create table payment_types(
    paytype_id int IDENTITY not null,
    payment_type varchar(20) not null,
    CONSTRAINT pk_payment_types_paytype_id PRIMARY key (paytype_id)
)

--payments
create table payments(
    payment_id int IDENTITY not null,
    payment_member_id int not null,
    payment_purpose varchar(20) not null,
    payment_time datetime not null,
    payment_type int not null,
    constraint pk_payments_payment_id PRIMARY key (payment_id),
    constraint fk_payments_payment_member_id foreign key (payment_member_id) REFERENCES members(member_id),
    constraint fk_payments_payment_type foreign key (payment_type) REFERENCES payment_types(paytype_id)
)


-- employee_vacation_requests
create table employee_vacation_requests
(
	request_id int identity not null,
	request_name varchar(50) not null,
	request_employee_id int not null,
	request_start_date datetime default (getdate()) not null,
	request_number_of_days int default(1) not null,
	request_approved_manager_id int null,
	request_approved_date datetime null,
	constraint pk_employee_vacation_requests_request_id primary key (request_id),
	constraint fk_employee_vacation_requests_request_employee_id 
		foreign key (request_employee_id) references employees(employee_id),
	constraint fk_employee_vacation_requests_request_approved_employee_id
			foreign key (request_approved_manager_id) references managers(manager_id)
)



--Up

insert into managers 
(login_firstname, login_lastname, login_password, manager_email)
values 
('Hart', 'Linhan', '12345678', 'manager01@gmail.com'),
('Vic', 'Grande', '12345678', 'manager02@gmail.com')
go

insert into cardplans 
(plan_type, plan_price)
VALUES
('month', 55),
('season', 150),
('annual', 420)
go

insert into members 
(member_firstname, member_lastname, member_login_password, member_gender, member_email, member_age, member_phone,member_start_date, member_expire_date, member_card_id, member_card_type, member_street, member_city, member_state, member_postalcode, member_manager_id)
values 
('Mike', 'Ling', '12345678', 'Male', 'mling285@gmail.com', 31, '3157086524', '2021-04-30', '2022-04-30', '310001', 3, '954 Marshall Street', 'Syracuse', 'New York', '13210', '1'),
('Ken', 'Horse', '12345678', 'Male', 'khorse543@gmail.com', 25, '3157087765', '2021-07-28', '2022-07-28', '310002', 3, '898 Mall Street', 'Syracuse', 'New York', '13210', '1'),
('Avi', 'Maria', '12345678', 'FeMale', 'amaria@gmail.com', 23, '3157088862', '2021-07-31', '2024-07-31', '310003', 3, '672 Popy Street', 'Syracuse', 'New York', '13210', '2'),
('Nancy', 'Tin', '12345678', 'FeMale', 'ntin803@gmail.com', 23, '3157088862', '2022-10-31', '2023-01-31', '310003', 2, '896 Mall Street', 'Syracuse', 'New York', '13210', '2')
go


insert into courses_week
(week_name)
values 
('Monday'), ('Thuesday'), ('Wednesday'), ('Thursday'), ('Friday'), ('Saturday'), ('Sunday')
go

insert into courses
(course_name, course_time, course_week, course_start_time, course_end_time, course_room, course_type)
values 
('Yoga', 2, 1,'16:00', '18:00', 001, 'Free'),
('Aerobics', 1, 2, '16:00', '18:00', 002, 'Free'),
('Spining Bike', 1, 3, '17:00', '18:00', 003, 'Free'),
('Yoga', 2, 5,'16:00', '18:00', 001, 'Free'),
('Aerobics', 1, 6, '16:00', '18:00', 002, 'Free'),
('Private Lesson', 1, NULL, NULL, NULL, 004, 'Fee')
go


insert into employees
(employee_firstname, employee_lastname, employee_date_of_birth, employee_email, employee_phonenumber, employee_street, employee_city, employee_state, employee_postalcode,employee_gender, employee_login_password)
values 
('Lary', 'Rochest', '1997-03-28', 'lrochest286@gmail.com', '3157086598', '919E Genesee Street', 'Syracuse', 'New York', '13210', 'Male', '12345678'),
('Yola', 'Fudge', '1999-08-26', 'yfudge930@gmail.com', '3157086280', '924 Westcott Street', 'Syracuse', 'New York', '13210', 'Female', '12345678'),
('Michale', 'Robert', '1996-05-19', 'mrobert706@gmail.com', '3157088402', '612 University Street', 'Syracuse', 'New York', '13210', 'Male', '12345678')
go

 
insert into payment_types
( payment_type)
VALUES('cash'), ('card'), ('check'), ('transfer')
GO

insert into payments
(payment_member_id, payment_purpose, payment_time, payment_type) 
values
(1, 'membership', '2021-03-31 18:58:00', 2),
(2, 'membership', '2021-07-25 09:49:00', 2),
(3, 'membership', '2021-07-25 14:32:58', 4),
(4, 'membership', '2022-11-01 15:23:27', 1),
(4, 'course','2022-11-01 15:48:09', 1)
go

insert into messages
(message_publish_time, message_member_id, massage_detail)
VALUES
('2022-11-08 12:36:07', 3, 'The coach is great!'),
('2022-11-11 17:08:23', 1, 'The elliptical machine is broken. Please repair it!')
go

 insert into employees_courses
 (employee_id, course_id)
 VALUES
 (2, 1), (1,3), (2,1), (3,5), (3,6)
go

insert into members_courses 
(course_id, member_id, enroll_time)
VALUES
(1, 3, '2022-11-01'),
(3, 2, '2022-11-01'),
(1, 4, '2022-11-07'),
(5, 1, '2022-11-09'),
(6, 3, '2022-11-11')
go

insert into employee_vacation_requests
(request_name, request_employee_id, request_start_date, request_number_of_days, request_approved_manager_id, request_approved_date)
VALUES
 ('Itupp', 2, '2022-11-21 04:23:00', 3, 1, '2022-11-21 15:45:00'),
 ( 'Case', 1, '2022-11-28 4:00:00', 7, 1, '2022-11-28 12:07:00' )
Go

--GO
select * from members
select * from managers
select * from cardplans
select * from courses
select * from courses_week
select * from employees
select * from members_courses 
select * from employees_courses
select * from messages
select * from payment_types
select * from payments
select * from employee_vacation_requests

--make store procedure
--down
drop procedure if exists employee_vacation_upsert
go
--UP 
create procedure employee_vacation_upsert(
    @request_name VARCHAR(50),
    @request_start_date DATETIME,
    @request_number_of_days int,
    @request_approved_manager_id int, 
    @request_employee_id int
)as begin 
begin try 
    begin TRANSACTION
        if exists (select * from employee_vacation_requests) BEGIN
        update employee_vacation_requests
        set request_name=@request_name,
        request_start_date=@request_start_date,
        request_number_of_days=@request_number_of_days,
        request_approved_date=GETDATE()
        where request_approved_manager_id=@request_approved_manager_id and 
        request_employee_id=@request_employee_id
        if @@ROWCOUNT <>1 throw 50001, 'member_vacation_upsert: Update Error', 1
    END
    ELSE BEGIN 
        DECLARE @request_id int = (select MAX(request_id) from employee_vacation_requests) + 1
        insert into employee_vacation_requests(
            request_name,
            request_start_date,
            request_employee_id,
            request_number_of_days,
            request_approved_manager_id,
            request_approved_date)
        VALUES(
            @request_name,
            @request_start_date,
            @request_employee_id,
            @request_number_of_days,
            @request_approved_manager_id,
            GETDATE()
        )
        if @@ROWCOUNT <>1 throw 50001, 'member_vcation_upsert: Update Error', 1
    END
    COMMIT
    END TRY
    BEGIN CATCH
    ROLLBACK
    ;
    THROW
    END CATCH
END

--make view
--down 
drop view if exists v_member_course
GO
--up 
create FUNCTION concat_name(
    @a VARCHAR(20), @b VARCHAR(20)
) returns varchar(50) as BEGIN
    RETURN
    @a + ' ' + @b
END
go
create view v_member_course AS(
    select 
    member_id,
    dbo.concat_name(member_firstname, member_lastname) as member_name, 
    course_name,
    course_start_time,
    course_end_time,
    course_location,
    course_employee
from members_course c
join courses o on c.member_course_id=o.course_id
join members s on c.member_id=s.member_id
)
