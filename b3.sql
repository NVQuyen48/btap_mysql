use testing_system;

INSERT INTO `account` (email, user_name, full_name, department_id, position_id, create_date)
VALUES
('karen@example.com', 'karen06', 'Karen Miller', 1, 2, '2024-05-01'),
('tom@example.com', 'tom07', 'Tom Wilson', 2, 3, '2024-05-05'),
('emma@example.com', 'emma08', 'Emma Davis', 3, 1, '2024-06-01'),
('jack@example.com', 'jack09', 'Jack Moore', 4, 4, '2024-06-10'),
('susan@example.com', 'susan10', 'Susan Lee', 5, 2, '2024-06-15');

INSERT INTO department (department_name)
VALUES
('Logistics'),
('Support'),
('Training'),
('Research'),
('Operation');

INSERT INTO `account` (email, user_name, full_name, department_id, position_id, create_date)
VALUES
('alex@example.com', 'alex01', 'Alex Nguyen', 1, 2, '2024-05-01'),
('sara@example.com', 'sara02', 'Sara Pham', 2, 3, '2024-05-05'),
('david@example.com', 'david03', 'David Tran', 3, 1, '2024-06-01'),
('sophie@example.com', 'sophie04', 'Sophie Le', 4, 4, '2024-06-10'),
('thomas@example.com', 'thomas05', 'Thomas Vu', 5, 2, '2024-06-12');

INSERT INTO `group` (group_name, creator_id, create_date)
VALUES
('Group F', 1, '2024-05-01'),
('Group G', 2, '2024-05-03'),
('Group H', 3, '2024-05-10'),
('Group I', 4, '2024-05-20'),
('Group J', 5, '2024-05-25');

INSERT INTO group_account (group_id, account_id, join_date)
VALUES
(1, 3, '2024-05-01'),
(2, 4, '2024-05-03'),
(3, 5, '2024-05-10'),
(4, 1, '2024-05-20'),
(5, 2, '2024-05-25');

INSERT INTO category_question (category_name)
VALUES
('HTML'),
('CSS'),
('JavaScript'),
('Python'),
('Docker');

INSERT INTO question (content, category_id, type_id, creator_id, create_date)
VALUES
('HTML la gi?', 1, 1, 1, '2024-05-01'),
('CSS dung de lam gi?', 2, 2, 2, '2024-05-03'),
('JavaScript la gi?', 3, 1, 3, '2024-05-05'),
('Python dung de lam gi?', 4, 2, 4, '2024-05-07'),
('Docker la gi?', 5, 1, 5, '2024-05-10');

INSERT INTO answer (content, question_id, is_correct)
VALUES
('HTML la ngon ngu danh dau sieu van ban', 6, TRUE),
('CSS dung de tao kieu cho trang web', 7, TRUE),
('JavaScript la ngon ngu lap trinh web', 8, TRUE),
('Python la ngon ngu lap trinh da muc dich', 9, TRUE),
('Docker la cong cu dong goi ung dung', 10, TRUE);

INSERT INTO exam (code_id, title, category_id, duration, creator_id, create_date)
VALUES
(106, 'Exam F', 1, 60, 1, '2024-05-02'),
(107, 'Exam G', 2, 45, 2, '2024-05-05'),
(108, 'Exam H', 3, 90, 3, '2024-05-10'),
(109, 'Exam I', 4, 30, 4, '2024-05-15'),
(110, 'Exam J', 5, 75, 5, '2024-05-20');

INSERT INTO exam_question (exam_id, question_id)
VALUES
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);


#bài 2  lấy ra tất cả các phòng ban
select * from department;


#bài 3 lấy ra id của phòng ban "Sale"
select department_id from department where department_name = 'Sales';

#bài 4  lấy ra thông tin account có full name dài nhất
select *  from `account` where char_length(full_name) =(
	select max(char_length(full_name)) from account 
);

#bài 5  Lấy ra thông tin account có full name dài nhất và thuộc phòng ban có id=3
select *  from `account` where char_length(full_name) =(
	select max(char_length(full_name)) from account where department_id = 3
) and department_id = 3;

#bài 6  Lấy ra tên group đã tham gia trước ngày 20/12/2019
select group_name from `group` where create_date < '2019/12/20';

#bài 7  Lấy ra ID của question có >= 4 câu trả lời
select * from question;
select question_id from answer group by question_id having count(answer_id) >= 4;

#bài 8 Lấy ra các mã đề thi có thời gian thi >= 60 phút và được tạo trước ngày 20/12/2019
select * from exam;
select * from exam where duration >= 60 and create_date <= '2019/12/20';

#bài 9 Lấy ra 5 group được tạo gần đây nhất
select * from `group`  order by  create_date DESC limit 5;

#bài 10 Đếm số nhân viên thuộc department có id = 2
select * from account ;
select count(*) from account where department_id = 2; 

#bài 11  Lấy ra nhân viên có tên bắt đầu bằng chữ "D" và kết thúc bằng chữ "o"
select * from `account` where full_name  like 'D%' and full_name like '%o';

#bài 12  Xóa tất cả các exam được tạo trước ngày 20/12/2019
select * from exam;
select * from exam_question;
-- vì exam_id có quan hệ với bảng exam_question qua khóa ngoại , nên phải xóa exam_id ở bảng exam_question trước 
DELETE FROM exam_question 
WHERE exam_id IN (
    SELECT exam_id 
    FROM exam 
    WHERE create_date < '2019-12-20'
);
delete from exam where create_date < '2019/12/20';

#bài 13 Xóa tất cả các question có nội dung bắt đầu bằng từ "câu hỏi"
select * from question ;
-- trong bảng answer và exam_question có tham chiếu đến question , nên phải xóa trước,ròi mới xóa đến bảng question
delete from answer where question_id in (select question_id from question where content like 'câu hỏi%');
delete from exam_question where question_id in (select question_id from question where content like 'câu hỏi%');
delete from question where content like 'câu hỏi%';

#bài 14  Update thông tin của account có id = 5 thành tên "Nguyễn Bá Lộc" và email thành loc.nguyenba@vti.com.vn

select * from account;
update `account` set full_name ='Nguyễn Bá Lộc' , email = 'loc.nguyenba@vti.com.vn' where account_id = 5;

#bài 15 update account có id = 5 sẽ thuộc group có id = 4
select * from group_account;
update group_account set group_id = 4 where account_id =5