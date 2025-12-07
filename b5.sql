use testing_system;

create view account_sale as
select a.*,d.department_name from `account` a join department d
	on a.department_id = d.department_id
    where d.department_name = 'Sales';

select * from account_sale;

#Question 2: Tạo view có chứa thông tin các account tham gia vào nhiều group nh
create view max_account_group as
select 
    a.account_id,
    a.full_name,
    count(ga.group_id) AS total_groups
from
    account a
        join
    group_account ga ON a.account_id = ga.account_id
group by a.account_id , a.full_name
having count(ga.group_id) = (select 
        max(group_count)
    from
        (select 
            count(ga2.group_id) AS group_count
		from
            group_account ga2
        group by ga2.account_id) AS sub);

#Question 3: Tạo view có chứa câu hỏi có những content quá dài (content quá 300 từ
create view char_content as
select * from question where char_length(content) > 300;

#Question 4: Tạo view có chứa danh sách các phòng ban có nhiều nhân viên nhất
create view department_account as
select 
    d.department_id,d.department_name, count(a.account_id) as total_account
from
    department d
        join
    account a on d.department_id = a.department_id
group by d.department_id
having total_account = (select 
        max(total_account)
    from
        (select d2.department_id,
            count(a2.account_id) as total_account
        from
            department d2
        join account a2 ON d2.department_id = a2.department_id
        group by d2.department_id) as sub);

#Question 5: Tạo view có chứa tất các các câu hỏi do user họ Nguyễn tạo.
create view user_nguyen as
select * from account a join question q
on a.account_id = q.creator_id
where full_name like 'Nguyễn%';
