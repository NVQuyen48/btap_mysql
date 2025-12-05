use testing_system;

#Question 1: Viết lệnh để lấy ra danh sách nhân viên và thông tin phòng ban của họ
select * from `account` a join department d
	on a.department_id = d.department_id;
    
#Question 2: Viết lệnh để lấy ra thông tin các account được tạo sau ngày 20/12/2010
select * from `account` where create_date > '2010/12/20';

#Question 3: Viết lệnh để lấy ra tất cả các developer
select * from `account` a join `position` p 
	on a.position_id = p.position_id
where position_name = 'Dev';

#Question 4: Viết lệnh để lấy ra danh sách các phòng ban có > 3 nhân viên
select * from department;
select d.department_id,department_name, count(d.department_id)  from department d join `account` a
	on d.department_id = a.department_id
group by department_id
having count(d.department_id) > 3;

#Question 5: Viết lệnh để lấy ra danh sách câu hỏi được sử dụng trong đề thi nhiều nhất
select eq.question_id,q.content, count(eq.exam_id) as total_used from exam_question eq join question q
on eq.question_id = q.question_id
group by eq.question_id
order by total_used desc limit 1;

#Question 6: Thông kê mỗi category Question được sử dụng trong bao nhiêu Question
select * from category_question;
select * from question;
select c.category_id,category_name, count(c.category_id) from category_question c  join question q
	on c.category_id = q.category_id
group by category_id;

#Question 7: Thông kê mỗi Question được sử dụng trong bao nhiêu Exam
select * from exam_question;
select  question_id , count(exam_id) from exam_question  group by question_id;

#Question 8: Lấy ra Question có nhiều câu trả lời nhất
select q.question_id,q.content, COUNT(a.answer_id) as total_answer from question  q join answer a
	on q.question_id = a.question_id
group by q.question_id, q.content
order by total_answer DESC
limit 1;

#Question 9: Thống kê số lượng account trong mỗi group
select ga.group_id ,g.group_name, count(ga.account_id) from `account` a join group_account  ga
	on a.account_id = ga.account_id
    join `group` g  on ga.group_id = g.group_id
group by ga.group_id;

#Question 10: Tìm chức vụ có ít người nhất
select p.position_id,p.position_name, count(a.account_id) as total_account from `account` a  join `position` p
	on a.position_id = p.position_id
    group by p.position_id
    order by total_account asc limit 1;

#Question 11: Thống kê mỗi phòng ban có bao nhiêu dev, test, scrum master, P
select d.department_id, d.department_name,
       p.position_name,count(a.account_id)  AS total_accounts
from `account` a join department d
	on a.department_id = d.department_id
    join position p on a.position_id = p.position_id
group by  d.department_id, d.department_name, p.position_id, p.position_name
ORDER BY d.department_id;

#Question 12: Lấy thông tin chi tiết của câu hỏi bao gồm: thông tin cơ bản của question, loại câu hỏi, ai là người tạo ra câu hỏi, câu trả lời là gì, …
select q.question_id,
       q.content AS question_content,
       t.type_name,
       ac.full_name AS creator_name,
       a.answer_id,
       a.content AS answer_content,
       a.is_correct from 
question  q 
	join type_question t on q.type_id = t.type_id
    join account ac on q.creator_id = ac.account_id
    join answer a on q.question_id = a.question_id 
ORDER BY q.question_id, a.answer_id;

#Question 13: Lấy ra số lượng câu hỏi của mỗi loại tự luận hay trắc nghiệm
select t.type_id , t.type_name, count(q.question_id) AS total_questions 
from question q join type_question t
	on q.type_id = t.type_id
group by t.type_id , t.type_name;

#Question 14:Lấy ra group không có account nào
select g.group_id, g.group_name, COUNT(a.account_id) AS total_accounts 
from `group` g 
left join group_account ga ON g.group_id = ga.group_id
left join account a ON ga.account_id = a.account_id
group by g.group_id
having total_accounts = 0;

#Question 16: Lấy ra question không có answer nào.
select q.question_id,q.content, count(a.answer_id) as total_answer from question q left join answer a
on q.question_id = a.question_id
group by q.question_id
having total_answer = 0;

-- Question 17
-- a) Lấy các account thuộc nhóm thứ 1
-- b) Lấy các account thuộc nhóm thứ 2
-- c) Ghép 2 kết quả từ câu a) và câu b) sao cho không có record nào trùng
-- nhau
select a.account_id, a.full_name from `account` a join group_account ga
	on a.account_id = ga.account_id
    join `group` g on g.group_id = ga.group_id
    where ga.group_id = 1
UNION   
select a.account_id, a.full_name from `account` a join group_account ga
	on a.account_id = ga.account_id
    join `group` g on g.group_id = ga.group_id
    where ga.group_id = 2;
    
-- Question 18:
-- a) Lấy các group có lớn hơn 5 thành viên
-- b) Lấy các group có nhỏ hơn 7 thành viên
-- c) Ghép 2 kết quả từ câu a) và câu b).
select ga.group_id,g.group_name, count(ga.account_id) as total_account   from group_account ga join account a
	on ga.account_id = a.account_id
    join `group` g on ga.group_id = g.group_id
    group by ga.group_id
    having total_account > 5
union all    
select ga.group_id,g.group_name, count(ga.account_id) as total_account   from group_account ga join account a
	on ga.account_id = a.account_id
    join `group` g on ga.group_id = g.group_id
    group by ga.group_id
    having total_account < 7
    
    