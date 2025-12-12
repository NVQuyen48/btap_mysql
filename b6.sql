use testing_system;

#Question 1: Tạo store để người dùng nhập vào tên phòng ban và in ra tất cả các account thuộc phòng ban đó.
delimiter $$
create procedure infor_deparment (in in_department_name varchar(50) )
	begin 
		select d.department_name , a.account_id, a.user_name
        from department d
		join account a
        on d.department_id = a.department_id
        where department_name = in_department_name;
	end $$
delimiter ;

call infor_deparment('Sales');

#Question 2: Tạo store để in ra số lượng account trong mỗi group.
delimiter $$
	create procedure account_in_group ()
		begin
			select g.group_id, count(g.account_id)
            from group_account g 
            group by g.group_id;
        end $$
delimiter ;
call account_in_group()

#Question 3: Tạo store để thống kê mỗi type question có bao nhiêu question được tạo trong tháng hiện tại
delimiter $$ 
	create procedure total_question()
		begin
			select t.type_id,t.type_name,count(q.question_id)
            from type_question t
            join question q
            on t.type_id = q.type_id
			where month(create_date) =  month(curdate()) and (q.create_date) = year(curdate())
            group by t.type_id;
        end $$
delimiter ;
call total_question();

#Question 4: Tạo store để trả ra id của type question có nhiều câu hỏi nhất.
delimiter $$
	create procedure max_question(out out_type_id int)
		begin
			select t.type_id, t.type_name, count(q.question_id)
            from type_question t
            join question q
            on t.type_id =  q.type_id
            group by t.type_id
            having count(q.question_id) = (
				select max(total_question)
                from(
					select count(q2.question_id) as total_question
                    from type_question t2
                    join question q2
                    on t2.type_id = q2.type_id
                    group by t2.type_id
                )as sub
            );
		end $$
delimiter ;

call max_question(@out_id);
select @out_id

#Question 5: Sử dụng store ở question 4 để tìm ra tên của type question.
delimiter $$ 
	create procedure fill_name_question(out out_type_name varchar(50))
		begin
			declare i_question_id int;
            
            call max_question(i_question_id);
            select type_name into out_type_name
            from type_question
            where type_id = i_question_id;
        end $$
delimiter ;

CALL fill_name_question(@result_name);

-- Question 6: Viết 1 store cho phép người dùng nhập vào 1 chuỗi và trả về group có tên
-- chứa chuỗi của người dùng nhập vào hoặc trả về user có username chứachuỗi của người dùng nhập vào.

delimiter $$
	create procedure search_group_or_user (in in_text varchar(50))
		begin
			select  g.group_id,g.group_name
            from `group` g
            where g.group_name like concat('%', in_text,'%')
            union all
            select a.account_id, a.user_name
            from `account` a
            where a.user_name like concat('%',in_text,'%');
        end $$
delimiter ;

call search_group_or_user('jo')

-- Question 7: Viết 1 store cho phép người dùng nhập vào thông tin fullName,
-- email và trong store sẽ tự động gán:
-- username sẽ giống email nhưng bỏ phần @..mail đi
-- positionID: sẽ có default là developer
-- departmentID: sẽ được cho vào 1 phòng chờ
-- Sau đó in ra kết quả tạo thành công

delimiter  $$
	create procedure insert_infor (in in_full_name varchar(50), in in_email varchar(50))
		begin
			declare in_user_name varchar(50);
            set in_user_name = SUBSTRING_INDEX(in_email,'@', 1);
			insert into `account` (email,user_name,full_name,department_id,position_id, create_date)
			value (in_email,in_user_name,in_full_name,99, 1,now());
			
            select concat ('tạo thành công', in_user_name) ;
        end $$
delimiter ;
drop procedure insert_infor;
CALL insert_infor('Nguyen Van A', 'nguyenvana@gmail.com');
 
 #Question 8: Viết 1 store cho phép người dùng nhập vào Essay hoặc Multiple-Choice
#để thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất

delimiter $$
	create procedure conten_max (in in_type_name varchar(50))
		begin
			if in_type_name not in ('Essay', 'Multiple-Choice') then
				signal sqlstate '45000'
                set message_text = 'Giá trị k hợp lệ';
			else 
				select t.type_id,q.content, char_length(q.content) 
                from type_question t
                join question q
                on t.type_id = q.type_id
                where t.type_name = in_type_name 
					and char_length(q.content) =
                    (
						select MAX(CHAR_LENGTH(q2.content))
						from question q2
						join type_question t2 ON q2.type_id = t2.type_id
						where t2.type_name = in_type_name
                    );
			end if;
        end $$
delimiter ;

call conten_max('Essay')

#Question 9: Viết 1 store cho phép người dùng xóa exam dựa vào ID
delimiter $$
	create procedure delete_exam (in in_exam_id int)
		begin
			delete from exam
            where exam_id = in_exam_id;
            
            if row_count() > 0 then
				select concat('Đã xóa thành công exam có id: ',in_exam_id);
			else
				select concat('Không tìm thấy exam có id: ',in_exam_id);
			end if;
        end $$
delimiter ;
drop procedure delete_exam;
call delete_exam(3)

-- Question 10: Tìm ra các exam được tạo từ 3 năm trước và xóa các exam đó
-- đi (sử dụng store ở câu 9 để xóa)
-- Sau đó in số lượng record đã remove từ các table liên quan trong khi removing

delimiter $$
	create procedure remove_exam ()
		begin
			delete from exam
            where create_date < date_sub(now(), interval 3 year);
            
            select row_count() as total_delete;
        end $$
delimiter ;
drop procedure remove_exam
call remove_exam()

-- Question 11: Viết store cho phép người dùng xóa phòng ban bằng cách
-- người dùng nhập vào tên phòng ban và các account thuộc phòng ban đó sẽ được
-- chuyển về phòng ban default là phòng ban chờ việc
delimiter $$
	create procedure delete_department (in in_department_name varchar(50))
		begin
			declare v_department_id INT;
			declare v_default_department_id INT;
            
            #lấy ra id phòng ban muốn xóa
            select department_id into v_department_id
            from department
            where department_name =  in_department_name;
            
			if v_department_id is null then
				signal sqlstate '45000'
                set message_text = 'Không tìm thấy phòng ban';
			else
				update account
                set department_id = v_default_department_id
                where department_id = v_department_id;
                
                delete from department 
                where department_id = v_department_id;
			end if ;
            
        end $$
delimiter ;

CALL delete_department('Operation');

#Question 12: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong năm nay
#điều kiện where sẽ lấy chỉ trong năm nay, group by nhóm theo tháng và dùng count để dếm
delimiter $$
	create procedure count_question_in_month ()
		begin
			select month(create_date), count(question_id)
            from question
            where year(create_date) = year(now())
            group by month(create_date);
        end $$
delimiter ;
drop procedure count_question_in_month;
call count_question_in_month()

#Question 13: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong 6 tháng gần đây nhất
delimiter $$
	create procedure count_question_last6()
		begin
			select DATE_FORMAT(create_date, '%Y-%m') as thang,
				case
					when count(question_id) = 0
                    then 'Không có câu hỏi trong tháng'
                    else concat(count(question_id))
				end as kq
            from question
            where create_date >= date_sub(now(), interval 6 month)
            group by DATE_FORMAT(create_date, '%Y-%m');
		end $$
delimiter ;
drop procedure count_question_last6;
call count_question_last6()
