go
/* **************** Education **************** */
CREATE FUNCTION Education.fn_calculate_gpa (@student_id INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @gpa FLOAT;
    SELECT @gpa = AVG(grade)
    FROM Education.takes
    WHERE student_id = @student_id;

    RETURN @gpa;
END;

go
CREATE FUNCTION Education.fn_count_students_by_dept (@dept_name VARCHAR(50))
RETURNS INT
AS
BEGIN
    RETURN (
        SELECT COUNT(*)
        FROM Education.student
        WHERE dept_name = @dept_name
    );
END;

go
CREATE FUNCTION Education.fn_has_passed (
    @student_id INT,
    @course_id VARCHAR(10)
)
RETURNS BIT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Education.takes
        WHERE student_id = @student_id AND course_id = @course_id
        AND grade >= 10.0
    )
        RETURN 1;
    RETURN 0;
END;

go
CREATE FUNCTION Education.fn_student_term_status (@student_id INT)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @status TINYINT, @desc VARCHAR(50)
    SELECT @status = education_status FROM Education.student WHERE student_id = @student_id

    SET @desc = CASE 
        WHEN @status BETWEEN 1 AND 12 THEN 'student in term ' + CAST(@status AS VARCHAR)
        WHEN @status = 13 THEN 'graduate'
        WHEN @status = 14 THEN 'dropout'
        WHEN @status = 15 THEN 'expulsion'
        ELSE 'Not in range!'
    END

    RETURN @desc
END;
GO
--  this function should be edited:
CREATE FUNCTION Education.fn_suggest_courses (
    @student_id INT
)
RETURNS TABLE
AS
RETURN
SELECT c.course_id, c.title, c.suggested_term
FROM Education.course c
WHERE NOT EXISTS (
    SELECT 1
    FROM Education.takes t
    WHERE t.student_id = @student_id AND t.course_id = c.course_id
)
AND c.suggested_term = (
    SELECT education_status
    FROM Education.student
    WHERE student_id = @student_id AND education_status BETWEEN 1 AND 12
);
go
CREATE FUNCTION Education.fn_is_valid_national_id(@NationalID CHAR(10))
RETURNS BIT
AS
BEGIN
	DECLARE @res BIT = 1;

	IF LEN(@NationalID) <> 10 OR ISNUMERIC(@NationalID + '.0e0') = 0 OR 
	   @NationalID IN ('0000000000','1111111111','2222222222','3333333333',
					   '4444444444','5555555555','6666666666','7777777777',
					   '8888888888','9999999999') 
	BEGIN
		RETURN 0;
	END

	DECLARE @b INT = (
		10*SUBSTRING(@NationalID,1,1) + 9*SUBSTRING(@NationalID,2,1) + 
		8*SUBSTRING(@NationalID,3,1) + 7*SUBSTRING(@NationalID,4,1) +
		6*SUBSTRING(@NationalID,5,1) + 5*SUBSTRING(@NationalID,6,1) +
		4*SUBSTRING(@NationalID,7,1) + 3*SUBSTRING(@NationalID,8,1) +
		2*SUBSTRING(@NationalID,9,1)
	) % 11;

	DECLARE @ctrl TINYINT = SUBSTRING(@NationalID,10,1);

	IF (@b < 2 AND @ctrl != @b) OR (@b >= 2 AND @ctrl != 11 - @b)
		SET @res = 0;

	RETURN @res;
END;


/* **************** Library **************** */

--/* TODO : TEST THIS FUNCTIONS*/
go
create function library.is_item_available (
	@f_item_id int,
	@f_item_type varchar(50)
)
returns bit 
as 
begin 
	 declare @status varchar(20);
	 select top 1 @status = status 
	 from Library.borrowings as b where
	 item_id = @f_item_id and item_type = @f_item_type 
		return case 
		when @status is null or @status = 'returnd'then 1 
	else 0 end;
end 
go
create function get_user_total_unpaid_fines (
	@p_user_id int
)
returns int 
as
begin 
	declare @total_pay int ;
	set @total_pay = 0;
	select @total_pay = sum(f.paid)
	from library.fines as f join Library.borrowings as b on f.borrowing_id = b.borrowing_id
	where f.payment_status = 'unpaid' and b.user_id = @p_user_id
	return @total_pay;
end
go
create function library.get_top_3_most_borrowed_book_category()
returns table
as 
return 
(
select top (3) c.category_id , c.category_name, count(*) as borrow_count
from Library.borrowings as b 
join Library.books as bk on bk.book_id = b.item_id
join Library.category as c on c.category_id = bk.category_id
where b.item_type = 'book'
group by c.category_id , c.category_name 
order by borrow_count desc
)

go

create function library.get_top_3_most_borrowed_magazines_category()
returns table
as 
return 
(
select top (3) c.category_id , c.category_name, count(*) as borrow_count
from Library.borrowings as b 
join Library.magazines as m on m.magazines_id= b.item_id
join Library.category as c on c.category_id = m.category_id
where b.item_type = 'magazines'
group by c.category_id , c.category_name 
order by borrow_count desc
)




























	