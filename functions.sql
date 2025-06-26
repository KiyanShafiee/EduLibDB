--/* Functions */
--CREATE FUNCTION Education.fn_calculate_gpa (@student_id INT)
--RETURNS FLOAT
--AS
--BEGIN
--    DECLARE @gpa FLOAT;

--    SELECT @gpa = AVG(
--        CASE grade
--            WHEN 'A' THEN 4.0
--            WHEN 'B' THEN 3.0
--            WHEN 'C' THEN 2.0
--            WHEN 'D' THEN 1.0
--            ELSE 0.0
--        END
--    )
--    FROM Education.takes
--    WHERE student_id = @student_id;

--    RETURN @gpa;
--END;



--CREATE FUNCTION Education.fn_count_students_by_dept (@dept_name VARCHAR(50))
--RETURNS INT
--AS
--BEGIN
--    RETURN (
--        SELECT COUNT(*)
--        FROM Education.student
--        WHERE dept_name = @dept_name
--    );
--END;


--CREATE FUNCTION Education.fn_has_passed (
--    @student_id INT,
--    @course_id VARCHAR(10)
--)
--RETURNS BIT
--AS
--BEGIN
--    IF EXISTS (
--        SELECT 1
--        FROM Education.takes
--        WHERE student_id = @student_id AND course_id = @course_id
--        AND grade IN ('A', 'B', 'C')
--    )
--        RETURN 1;
--    RETURN 0;
--END; 
--/* TODO : TEST THIS FUNCTIONS*/
-- create function library.is_item_available (
--	@f_item_id int,
--	@f_item_type varchar(50)
-- )
-- returns bit 
-- as 
-- begin 
--	 declare @status varchar(20);
--	 select top 1 @status = status 
--	 from Library.borrowings as b where
--	 item_id = @f_item_id and item_type = @f_item_type 
--		return case 
--		when @status is null or @status = 'returnd'then 1 
--	else 0 end;
--end 

--create function get_user_total_unpaid_fines (
--	@p_user_id int
--)
--returns int 
--as
--begin 
--	declare @total_pay int ;
--	set @total_pay =0;
--	select @total_pay = sum(f.paid)
--	from library.fines as f join on Library.borrowings as b on f.borrowing_id = b.borrowing_id
--	where f.status = 'unpaid' and b.user_id = @p_user_id
--	return @total_paid;
--end

--create function get_top_3_most_borrowed_book_category()
--returns table
--as 
--return 
--(
--select top (3) c.category_id , c.category_name, count(*) as borrow_count
--from Library.borrowings as b 
--join Library.books as bk on bk.book_id = b.item_id
--join Library.category as c on c.category_id = bk.category_id
--where b.item_type = 'book'
--group by c.category_id , c.category_name 
--order by borrow_count desc
--)



--create function get_top_3_most_borrowed_magazines_category()
--returns table
--as 
--return 
--(
--select top (3) c.category_id , c.category_name, count(*) as borrow_count
--from Library.borrowings as b 
--join Library.magazines as m on m.magazines_id= b.item_id
--join Library.category as c on c.category_id = m.category_id
--where b.item_type = 'magazines'
--group by c.category_id , c.category_name 
--order by borrow_count desc
--)




























	