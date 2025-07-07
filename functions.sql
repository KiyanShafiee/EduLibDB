/* **************** Education **************** */
CREATE FUNCTION Education.fn_get_gpa(@student_id INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @gpa FLOAT;
    SELECT @gpa = AVG(grade)
    FROM Education.takes
    WHERE student_id = @student_id AND grade IS NOT NULL;
    RETURN @gpa;
END;
GO


CREATE FUNCTION Education.fn_total_credits(@student_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @total INT;
    SELECT @total = SUM(c.credits)
    FROM Education.takes t
    JOIN Education.course c ON t.course_id = c.course_id
    WHERE t.student_id = @student_id AND t.grade IS NOT NULL;
    RETURN @total;
END;
GO


CREATE FUNCTION Education.fn_current_term(@student_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @term INT;
    SELECT @term = current_term
    FROM Education.student
    WHERE student_id = @student_id;
    RETURN @term;
END;
GO



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


CREATE FUNCTION Education.fn_is_valid_national_id(@NationalID char(10))
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

GO
CREATE FUNCTION Education.fn_suggest_courses (
    @student_id INT
)
RETURNS TABLE
AS
RETURN
(
    WITH student_info AS (
        SELECT 
            current_term,
            major_id,
            level_id
        FROM Education.student
        WHERE student_id = @student_id
    ),
    avg_grade_calc AS (
        SELECT 
            AVG(CAST(grade AS FLOAT)) AS avg_grade
        FROM Education.takes
        WHERE student_id = @student_id
    ),
    max_units_calc AS (
        SELECT 
            CASE 
                WHEN ISNULL(avg_grade, 20) < 12 THEN 14
                ELSE 20
            END AS max_units
        FROM avg_grade_calc
    ),
    passed_courses AS (
        SELECT course_id
        FROM Education.takes
        WHERE student_id = @student_id AND grade >= 10
    ),
    all_suggestions AS (
        SELECT 
            c.course_id, 
            c.title, 
            c.credits, 
            cp.suggested_term,
            CASE 
                WHEN cp.suggested_term < si.current_term THEN 1
                WHEN cp.suggested_term = si.current_term THEN 2
                ELSE 3
            END AS priority
        FROM Education.course_plan cp
        JOIN Education.course c ON c.course_id = cp.course_id
        CROSS JOIN student_info si
        WHERE cp.major_id = si.major_id
          AND cp.level_id = si.level_id
          AND cp.course_id NOT IN (SELECT course_id FROM passed_courses)
    ),
    ordered_courses AS (
        SELECT *,
               SUM(credits) OVER (ORDER BY priority, suggested_term, course_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_credits
        FROM all_suggestions
    ),
    final_courses AS (
        SELECT *
        FROM ordered_courses
        WHERE running_credits <= (SELECT max_units FROM max_units_calc)
    )
    SELECT 
        course_id,
        title,
        credits,
        suggested_term
    FROM final_courses
);


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
		when @status is not  null or @status = 'returnd'then 1 
	else 0 end;
end 


go

create function library.get_user_total_unpaid_fines (
	@p_user_id int
)
returns int 
as
begin 
	declare @total_pay int ;
	set @total_pay = 0;
	select @total_pay = sum(f.amount)
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
where b.item_type = 'magazine'
group by c.category_id , c.category_name 
order by borrow_count desc
)

GO
create VIEW frequenty_of_book_borrowing  as (
select item_id , count(*) as frequency
from library.borrowings
where item_type = 'book'
GROUP by item_id
)

go
create function func_suggest_book (@user_id int) 
returns @sug table(book_id int)
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
    INSERT into @sug (book_id)
    select * from arranged_base_on_frequency
    RETURN
end 

































	