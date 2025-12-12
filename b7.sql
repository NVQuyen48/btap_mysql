delimiter $$
-- Question 1: Tạo trigger không cho phép người dùng nhập vào Group có
-- ngày tạo trước 1 năm trước

create trigger	no_insert_group 
before insert  on `group`
for each row
begin
	if new.create_date < date_sub(curdate() , interval 1 year) then 
		signal sqlstate '45000'
         set message_text='Khong duoc tao group co ngay truoc 1 nam';
	end if ;
end $$
	
-- Question 2: Tạo trigger Không cho phép người dùng thêm bất kỳ user nào
-- vào department ;Sale; nữa, khi thêm thì hiện ra thông báo ;Department
-- t;Sale; cannot add more user;
create trigger not_user_department 
before insert on `account`
for each row
begin
	declare i_department_name  varchar(50);
    
    select department_name into i_department_name
    from department
	where department_id = new.department_id;
    
    if i_department_name = 'Sales' then
		signal sqlstate '45000'
        set message_text ='Department Sale cannot add more user';
    end if;
end $$

-- Question 3: Cấu hình 1 group có nhiều nhất là 5 user
create trigger group_5user 
before insert on `account`
for each row
begin
	declare user_count int;
    
    select count(* ) into user_count
    from `account`
    where account_id = new.account_id;
    
    if user_count >5 then
		signal sqlstate '45000'
        set message_text ='1 group co tai da 5 account';
	end if ;
end $$



-- Question 4: Cấu hình 1 bài thi có nhiều nhất là 10 Question
create trigger exam_max_question
before insert on exam_question
for each row
begin
	declare count_question int;
    
    select count(*) into count_question
    from exam_question
    where exam_id = NEW.exam_id;
    
    if count_question > 10 then
		signal sqlstate '45000'
        set message_text='1 bai thi co tai da 10 question';
    end if;
end $$

-- Question 5: Tạo trigger không cho phép người dùng xóa tài khoản có email
-- là admin@gmail.com (đây là tài khoản admin, không cho phép user xóa),
-- còn lại các tài khoản khác thì sẽ cho phép xóa và sẽ xóa tất cả các thông
-- tin liên quan tới user đó

create trigger question5
before  delete on `account`
for each row
begin
	if old.email = 'admin@gmail.com' then
		signal sqlstate '45000'
        set message_text ='Day la tai khoan admin';
    else
		delete from  department
        where department_id = old.department_id;
        
        delete from position
        where position_id =old.position_id;
    
    end if;
    
end $$

-- Question 6: Không sử dụng cấu hình default cho field DepartmentID của
-- table Account, hãy tạo trigger cho phép người dùng khi tạo account không điền
-- vào departmentID thì sẽ được phân vào phòng ban &quot;waiting Department&quot;
create trigger question6
before insert on `account`
for each row
begin
	if new.department_id is null then
		set new.department_id = 50;
	end if ;
end $$

-- Question 7: Cấu hình 1 bài thi chỉ cho phép user tạo tối đa 4 answers cho
-- mỗi question, trong đó có tối đa 2 đáp án đúng.
create trigger question7
before insert on answer
for each row
begin
	declare total_answer int;
    declare corret_answer int;
     select count(*) into total_answer
     from answeer
     where question_id = new.question_id;
     
     select count(*) into corret_answer
     from answer
     where question_id = new.question_id
		and is_correct = 1 ;
        
	if total_answer > 4 then
		signal sqlstate '45000'
        set message_text ='Mỗi question có tối đa 4 answer';
	end if ;
    
    if corret_answer = 1 and corret_answer= 2 then
		signal sqlstate'45000'
		set message_text ='Mỗi question chỉ có tối đa 2 đáp an đúng';
	end if ;
     
end $$

-- Question 9: Viết trigger không cho phép người dùng xóa bài thi mới tạo được 2 ngày
create trigger question9
before delete on exam
for each row
begin
	if old.create_date =date_sub(now(), interval 2 day) then
		signal sqlstate '45000'
        set message_text ='Bai thi moi tao 2 ngay truoc khong duoc xoa';
	end if;
end $$

-- Question 10: Viết trigger chỉ cho phép người dùng chỉ được update, delete
-- các question khi question đó chưa nằm trong exam nào
	create trigger question10
    before delete on question
    for each row
    begin
		declare exam_count int;
		select count(*) as exam_count
        from exam_question
        where question_id = old.question_id;
        
        if exam_count > 0 then
			signal sqlstate '45000'
            set message_text='Khong duoc xoa question nam trong exam';
		end if ;
    end $$
    
	create trigger question10_2
    before update on question
    for each row
    begin
		declare exam_count int;
		select count(*) as exam_count
        from exam_question
        where question_id = old.question_id;
        
        if exam_count > 0 then
			signal sqlstate '45000'
            set message_text='Khong duoc update question nam trong exam';
		end if ;
    end $$

-- Question 12: Lấy ra thông tin exam trong đó:
-- Duration &lt;= 30 thì sẽ đổi thành giá trị &quot;Short time&quot;
-- 30 &lt; Duration &lt;= 60 thì sẽ đổi thành giá trị &quot;Medium time&quot;
-- Duration &gt; 60 thì sẽ đổi thành giá trị &quot;Long time&quot;

create trigger question12
before update on exam
for each row
begin
	if new.duration <= 30 then
        set new.duration = 'Short' ;
	elseif new.duration > 30 and new.duration <= 60 then
        set new.duration ='Medium';
	elseif new.duration > 60 then
        set new.duration='Long time';
	end if ;
end $$


-- Question 13: Thống kê số account trong mỗi group và in ra thêm 1 column
-- nữa có tên là the_number_user_amount và mang giá trị được quy định như sau:
-- Nếu số lượng user trong group =&lt; 5 thì sẽ có giá trị là few
-- Nếu số lượng user trong group &lt;= 20 và &gt; 5 thì sẽ có giá trị là normal
-- Nếu số lượng user trong group &gt; 20 thì sẽ có giá trị là higher

   select group_id,count(account_id) as total_account,
		case 
			when count(account_id) <= 5 then 'few'
            when count(account_id) > 5 and count(account_id) <=20 then 'normal'
            when count(account_id) > 20 then 'higher'
		end as the_number_user_amount
    from group_account
    group by group_id;

-- Question 14: Thống kê số mỗi phòng ban có bao nhiêu user, nếu phòng ban
-- nào không có user thì sẽ thay đổi giá trị 0 thành &quot;Không có User&quot;
	select d.department_id, count(a.account_id),
		case 
			when count(a.account_id) = 0 then 'Khong có user'
            ELSE CAST(COUNT(a.account_id) AS CHAR)
		end as total_uer_in_group
    from department d
    left join `account` a
    on d.department_id = a.department_id
	group by d.department_id








delimiter ;