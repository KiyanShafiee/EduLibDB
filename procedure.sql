
/* **************** Education **************** */
CREATE PROCEDURE Education.sp_register_student
    @student_id INT,
    @national_id CHAR(10),
    @dept_name VARCHAR(50),
    @advisor_id INT,
    @tot_cred INT
AS
BEGIN
    IF Education.fn_is_valid_national_id(@national_id) = 0
    BEGIN
        RAISERROR(N'The national code is invalid.', 16, 1);
        RETURN;
    END

    INSERT INTO Education.student (student_id, national_id, dept_name, advisor_id, tot_cred)
    VALUES (@student_id, @national_id, @dept_name, @advisor_id, @tot_cred);

    INSERT INTO Education.log (table_name, operation_type, description)
    VALUES ('Education.student', 'INSERT', 'Added student ID = ' + CAST(@student_id AS VARCHAR));
END;
go
CREATE PROCEDURE Education.sp_change_advisor
    @student_id INT,
    @new_advisor_id INT
AS
BEGIN
    UPDATE Education.student
    SET advisor_id = @new_advisor_id
    WHERE student_id = @student_id;

    INSERT INTO Education.log (table_name, operation_type, description)
    VALUES ('Education.student', 'UPDATE', 'Changed advisor for student ID = ' + CAST(@student_id AS VARCHAR));
END;
go
CREATE PROCEDURE Education.sp_drop_course
    @student_id INT,
    @course_id VARCHAR(10),
    @sec_id VARCHAR(10),
    @semester VARCHAR(10),
    @year INT
AS
BEGIN
    DELETE FROM Education.takes
    WHERE student_id = @student_id
    AND course_id = @course_id
    AND sec_id = @sec_id
    AND semester = @semester
    AND year = @year;

    INSERT INTO Education.log (table_name, operation_type, description)
    VALUES ('Education.takes', 'DELETE', 'Dropped course ' + @course_id + ' for student ' + CAST(@student_id AS VARCHAR));
END;

go
CREATE PROCEDURE Education.register_course
    @student_id INT,
    @course_id NVARCHAR(10),
    @sec_id NVARCHAR(10),
    @semester NVARCHAR(10),
    @year INT
AS
BEGIN
    INSERT INTO Education.takes(student_id, course_id, sec_id, semester, year, grade)
    VALUES (@student_id, @course_id, @sec_id, @semester, @year, NULL);
END;
GO





/* **************** Library **************** */
/*sub_proceduers*/

go
create procedure library.change_book_state_to_borrowed (@book_id int)
as 
begin
	update Library.books
	set status = 'borrowed'
	where book_id = @book_id
end

go
create procedure library.change_magazines_state_to_borrowed (@issue_id int)
as 
begin
	update Library.Issue_magasines
	set status = 'borrowed'
	where issue_id = @issue_id
end

go
create procedure library.change_article_state_to_borrowed (@article_id int)
as 
begin
	update Library.articles
	set status = 'borrowed'
	where article_id = @article_id
end

go
create procedure library.proc_change_book_to_available(@book_id int)
as 
begin
	update Library.books
	set status = 'available'
	where book_id =@book_id
end

go
create procedure library.proc_change_magasines_to_available(@m_id int)
as 
begin
	update Library.Issue_magasines
	set status = 'available'
	where issue_id =@m_id
end


go
create procedure library.proc_change_article_to_available(@article_id int)
as 
begin
	update Library.books
	set status = 'available'
	where book_id =@article_id
end


go
create procedure library.create_lib_user(@person_id char(10))
as 
begin 
	declare @is_frequent bit
	set @is_frequent =0
		select @is_frequent =1 from Library.users 
		where person_id = @person_id;
	if @is_frequent = 0 
	insert into Library.users (person_id,is_active,user_role) values (@person_id ,1 , 'student')

	else 
	begin
	RAISERROR('User already defined!',16,1)
	return
	end

end




go
create procedure library.borrrow_item (@item_id int , @item_type varchar(20),@user_id int)
as
begin
		begin TRANSACTION tran_borrow
			if(NOT EXISTS( SELECT 1 FROM Library.borrowings WHERE item_id =@item_id and item_type = @item_type and [status] = 'borrowed' )and  exists(select 1 from Library.users where is_active =1 and user_id = @user_id ))
			BEGIN
			insert into Library.borrowings (user_id,item_id,item_type,borrow_date,due_time,return_date) values 
			(@user_id,@item_id,@item_type,getdate(),DATEADD(DAY , 14 , getdate()),null)
			end
			else
			begin 
				ROLLBACK tran tran_borrow
				return
			end
			if @item_type = 'book'
				exec library.change_book_state_to_borrowed @item_id
			else if @item_type = 'magazine'
				exec library.change_magazines_state_to_borrowed @item_id
			else if @item_type = 'article'
				exec library.change_article_state_to_borrowed @item_id
			else 
			begin
				RAISERROR('book type not defined !',16,1)
				ROLLBACK tran tran_borrow
				return
			end
			commit TRAN tran_borrow
		
end


go
create procedure library.reserve_item (@item_id int , @item_type varchar(10), @user_id int, @expaire_date datetime)
as 
begin
if (exists (select 1 from library.borrowings where item_id = @item_id and item_type = @item_type ) and  exists(select 1 from Library.users where is_active =1 and user_id = @user_id ) )
	and not exists( select 1 from Library.reservation where item_id = @item_id and item_type = @item_type)
	begin
	insert into Library.reservation (user_id,item_id,item_type , reservation_date,expirt_date,status) values 
	(@user_id , @item_id , @item_type,getdate(),@expaire_date,'active')
	end
else 
	begin
	raiserror('You Can not reserve this item !',16,1)
	return
	end
end

go
create procedure library.poc_calculate_fine
as  
begin 
	insert into Library.fines (borrowing_id,amount,fine_date,paid,payment_status,reason) 
	select borrowing_id ,DATEDIFF(DAY,due_time,GETDATE()) * 500 ,GETDATE(),0,'unpaid','overdued'
	from Library.borrowings
	where getdate() > due_time and status != 'returnd'
end



go 
create procedure library.proc_suggest_book (@user_id int) 
as
begin 
    WITH his_book as
    (select item_id as book_id 
    from Library.borrowings  as b
    where b.user_id = @user_id
    and item_type = 'book'
    ),student_same_book as
    (select user_id 
    from Library.borrowings
    where item_type = 'book' and item_id in (select * from his_book) and user_id != @user_id
    GROUP by user_id
    having count(*)>1
    ),not_borrowing_book as (
    select item_id as book_id
    FROM Library.borrowings as b 
    where item_type = 'book' and user_id in (select * from student_same_book) and item_id not in (select * from his_book)
    ), arranged_base_on_frequency as (
    select top(3) book_id 
    from not_borrowing_book as nb 
    join frequenty_of_book_borrowing as fb on fb.item_id = nb.book_id
    ORDER by fb.frequency desc 
    )
    select * from arranged_base_on_frequency
end 
