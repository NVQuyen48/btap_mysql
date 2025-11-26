create database testing_system;
use testing_system;

create table department(
	department_id int auto_increment primary key,
	department_name varchar(50)
);

create table position_id(
	position_id int auto_increment primary key,
	position_name varchar(50)
);


create table account_id(
	account_id int auto_increment primary key,
	email varchar(50),
    user_name varchar(50),
	full_name varchar(50),
    department_id int,
    position_id int,
    create_date date,
	FOREIGN KEY (department_id) REFERENCES department(department_id),
    FOREIGN KEY (position_id) REFERENCES position_id(position_id)
);

create table group_id(
	group_id int auto_increment primary key,
    group_name varchar(50),
    creator_id int,
    create_date date
);

create table group_account(
	group_id int,
    account_id int,
    join_date date,
	FOREIGN KEY (group_id) REFERENCES group_id(group_id),
    FOREIGN KEY (account_id) REFERENCES account_id(account_id)
);

create table type_question(
	type_id int auto_increment primary key,
	type_name varchar(50)
);

create table category_question(
	category_id int auto_increment primary key,
	category_name varchar(50)
);

create table question(
	question_id int auto_increment primary key,
	content text,
    category_id int ,
    type_id int,
	creator_id int,
	create_date date,
    FOREIGN KEY (category_id) REFERENCES category_question(category_id),
	FOREIGN KEY (type_id) REFERENCES type_question(type_id)

);

create table answer(
	answer_id int auto_increment primary key,
	content text,
    question_id int,
	is_correct BOOLEAN,
	FOREIGN KEY (question_id) REFERENCES question(question_id)
);

create table exam(
	exam_id int auto_increment primary key,
	code_id int,
    title varchar(10),
    category_id int ,
    duration int,
    creator_id int,
	create_date date,
	FOREIGN KEY (category_id) REFERENCES category_question(category_id)
    
);

create table exam_question(
	exam_id int,
	question_id int ,
    PRIMARY KEY (exam_id, question_id),
    FOREIGN KEY (exam_id) REFERENCES exam(exam_id),
    FOREIGN KEY (question_id) REFERENCES question(question_id)
);



