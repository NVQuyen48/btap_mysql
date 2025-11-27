DROP DATABASE IF EXISTS testing_system;
create database testing_system;
use testing_system;


create table department(
	department_id int auto_increment primary key,
	department_name varchar(50)
);

create table `position`(
	position_id int auto_increment primary key,
	position_name  enum ('Dev', 'Test', 'Scrum Master', 'PM')
);


create table `account`(
	account_id int auto_increment primary key,
	email varchar(50),
    user_name varchar(50),
	full_name varchar(50),
    department_id int,
    position_id int,
    create_date date,
	FOREIGN KEY (department_id) REFERENCES department(department_id),
    FOREIGN KEY (position_id) REFERENCES `position`(position_id)
);

create table `group`(
	group_id int auto_increment primary key,
    group_name varchar(50),
    creator_id int,
    create_date date,
	FOREIGN KEY (creator_id) REFERENCES `account`(account_id)
);

CREATE TABLE group_account (
    group_id INT,
    account_id INT,
    join_date DATE,
	PRIMARY KEY (group_id, account_id),
    FOREIGN KEY (group_id) REFERENCES `group` (group_id),
    FOREIGN KEY (account_id) REFERENCES `account` (account_id)
);

create table type_question(
	type_id int auto_increment primary key,
	type_name enum ('Essay', 'Multiple-Choice')
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
	FOREIGN KEY (creator_id) REFERENCES `account`(account_id),
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


INSERT INTO department (department_name)
VALUES 
('Sales'),
('Marketing'),
('HR'),
('IT'),
('Finance');

INSERT INTO `position` (position_name)
VALUES
('Dev'),
('Test'),
('Scrum Master'),
('PM'),
('Dev');

INSERT INTO `account` (email, user_name, full_name, department_id, position_id, create_date)
VALUES
('john@example.com', 'john01', 'John Doe', 1, 1, '2024-01-01'),
('mary@example.com', 'mary02', 'Mary Smith', 2, 2, '2024-01-05'),
('anna@example.com', 'anna03', 'Anna Taylor', 3, 3, '2024-02-10'),
('peter@example.com', 'peter04', 'Peter Brown', 4, 4, '2024-03-15'),
('linda@example.com', 'linda05', 'Linda Johnson', 5, 1, '2024-04-01');


INSERT INTO `group` (group_name, creator_id, create_date)
VALUES
('Group A', 1, '2024-01-10'),
('Group B', 2, '2024-01-12'),
('Group C', 3, '2024-02-01'),
('Group D', 4, '2024-03-01'),
('Group E', 5, '2024-03-20');


INSERT INTO group_account (group_id, account_id, join_date)
VALUES
(1, 1, '2024-01-15'),
(1, 2, '2024-01-16'),
(2, 3, '2024-02-05'),
(3, 4, '2024-03-10'),
(4, 5, '2024-04-02');


INSERT INTO type_question (type_name)
VALUES
('Essay'),
('Multiple-Choice'),
('Essay'),
('Multiple-Choice'),
('Essay');

INSERT INTO category_question (category_name)
VALUES
('Java'),
('.NET'),
('SQL'),
('Postman'),
('Ruby');


INSERT INTO question (content, category_id, type_id, creator_id, create_date)
VALUES
('Java la gi?', 1, 1, 1, '2024-01-01'),
('Hay giai thich lap trinh huong doi tuong (OOP)?', 1, 2, 2, '2024-01-10'),
('SQL la gi?', 3, 1, 3, '2024-02-01'),
('Hay giai thich REST API?', 4, 2, 4, '2024-03-01'),
('Ruby on Rails la gi?', 5, 1, 5, '2024-03-05');

INSERT INTO answer (content, question_id, is_correct)
VALUES
('Java la mot ngon ngu lap trinh', 1, TRUE),
('OOP co 4 nguyen ly co ban', 2, TRUE),
('SQL la Nguyen ngu Truy van Co cau truc', 3, TRUE),
('REST la mot kieu kien truc phan mem', 4, TRUE),
('Ruby on Rails la mot framework phat trien web', 5, TRUE);

INSERT INTO exam (code_id, title, category_id, duration, creator_id, create_date)
VALUES
(101, 'Exam A', 1, 60, 1, '2024-01-05'),
(102, 'Exam B', 2, 45, 2, '2024-01-10'),
(103, 'Exam C', 3, 90, 3, '2024-02-15'),
(104, 'Exam D', 4, 30, 4, '2024-03-10'),
(105, 'Exam E', 5, 75, 5, '2024-04-01');


INSERT INTO exam_question (exam_id, question_id)
VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(4, 5);


