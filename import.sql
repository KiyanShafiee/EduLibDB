SELECT * FROM Education.student;
SELECT * FROM Education.course_plan;
SELECT * FROM Library.books;

go
CREATE OR ALTER PROCEDURE Education.sp_import_students
    @file_path NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @sql NVARCHAR(MAX);

    -- غیرفعال کردن کلیدهای خارجی
    ALTER TABLE Education.student NOCHECK CONSTRAINT ALL;

    -- ساخت دستور BULK INSERT به‌صورت پویا
    SET @sql = N'
    BULK INSERT Education.student
    FROM ''' + @file_path + N'''
    WITH (
        FIELDTERMINATOR = '','',
        ROWTERMINATOR = ''\n'',
        FIRSTROW = 2,
        CODEPAGE = ''65001'',
        ERRORFILE = ''C:\Users\asus\OneDrive\Desktop\DB project\student_error.log''
    );';


    -- اجرای دستور پویا
    EXEC sp_executesql @sql;

   -- فعال کردن دوباره کلیدهای خارجی
    ALTER TABLE Education.student CHECK CONSTRAINT ALL;

    -- ثبت لاگ
    INSERT INTO Education.log (table_name, operation_type, description)
    VALUES ('Education.student', 'BULK INSERT', 'Imported students from ' + @file_path);
END;
GO

CREATE OR ALTER PROCEDURE Education.sp_import_course_plan
    @file_path NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @sql NVARCHAR(MAX);

    ALTER TABLE Education.course_plan NOCHECK CONSTRAINT ALL;

    SET @sql = N'
    BULK INSERT Education.course_plan
    FROM ''' + @file_path + N'''
    WITH (
        FIELDTERMINATOR = '','',
        ROWTERMINATOR = ''\n'',
        FIRSTROW = 2,
        CODEPAGE = ''65001'',
        ERRORFILE = ''C:\Users\asus\OneDrive\Desktop\DB project\course_plan_error.log''
    );';

    EXEC sp_executesql @sql;

    ALTER TABLE Education.course_plan CHECK CONSTRAINT ALL;

    INSERT INTO Education.log (table_name, operation_type, description)
    VALUES ('Education.course_plan', 'BULK INSERT', 'Imported course plan from ' + @file_path);
END;
GO

CREATE OR ALTER PROCEDURE Library.sp_import_books
    @file_path NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @sql NVARCHAR(MAX);

    ALTER TABLE Library.books NOCHECK CONSTRAINT ALL;

    SET @sql = N'
    BULK INSERT Library.books
    FROM ''' + @file_path + N'''
    WITH (
        FIELDTERMINATOR = '','',
        ROWTERMINATOR = ''\n'',
        FIRSTROW = 2,
        CODEPAGE = ''65001'',
        ERRORFILE = ''C:\Users\asus\OneDrive\Desktop\DB project\books_error.log''
    );';

    EXEC sp_executesql @sql;

    ALTER TABLE Library.books CHECK CONSTRAINT ALL;

    INSERT INTO Library.Libeventlog (user_id, resone)
    VALUES (NULL, N'Imported books from ' + @file_path);
END;
GO

-- تست Import جدول student
EXEC Education.sp_import_students @file_path = 'C:\Users\asus\OneDrive\Desktop\DB project\student.csv';
SELECT * FROM Education.student;
SELECT * FROM Education.log WHERE table_name = 'Education.student' AND operation_type = 'BULK INSERT';

-- تست Import جدول course_plan
EXEC Education.sp_import_course_plan @file_path = 'C:\Users\asus\OneDrive\Desktop\DB project\course_plan.csv';
SELECT * FROM Education.course_plan;
SELECT * FROM Education.log WHERE table_name = 'Education.course_plan' AND operation_type = 'BULK INSERT';

-- تست Import جدول books
EXEC Library.sp_import_books @file_path = 'C:\Users\asus\OneDrive\Desktop\DB project\books.csv';
SELECT * FROM Library.books;
SELECT * FROM Library.Libeventlog WHERE resone LIKE 'Imported books%';