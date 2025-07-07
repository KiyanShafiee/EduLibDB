
go
CREATE OR ALTER PROCEDURE Education.sp_import_students
    @file_path NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @sql NVARCHAR(MAX);

    ALTER TABLE Education.student NOCHECK CONSTRAINT ALL;

    SET @sql = N'
    BULK INSERT Education.student
    FROM ''' + @file_path + N'''
    WITH (
        FIELDTERMINATOR = '','',
        ROWTERMINATOR = ''\n'',
        FIRSTROW = 1,
        CODEPAGE = ''65001'',
        ERRORFILE = ''F:\EduLibDB\project\EduLibDB\course_plan.txt''
    );';


    EXEC sp_executesql @sql;

    ALTER TABLE Education.student CHECK CONSTRAINT ALL;

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
        ERRORFILE = ''F:\EduLibDB\project\EduLibDB\course_plan.txt''
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
        FIRSTROW = 1,
        CODEPAGE = ''65001'',
        ERRORFILE = ''F:\EduLibDB\project\EduLibDB\book.txt''
    );';

    EXEC sp_executesql @sql;

    ALTER TABLE Library.books CHECK CONSTRAINT ALL;

    INSERT INTO Library.Libeventlog (user_id, resone)
    VALUES (NULL, N'Imported books from ' + @file_path);
END;
GO

EXEC Education.sp_import_students @file_path = 'F:\EduLibDB\project\EduLibDB\student.csv';
SELECT * FROM Education.student;
SELECT * FROM Education.log WHERE table_name = 'Education.student' AND operation_type = 'BULK INSERT';

EXEC Education.sp_import_course_plan @file_path = 'F:\EduLibDB\project\EduLibDB\course_plan.csv';
SELECT * FROM Education.course_plan;
SELECT * FROM Education.log WHERE table_name = 'Education.course_plan' AND operation_type = 'BULK INSERT';

EXEC Library.sp_import_books @file_path = 'F:\EduLibDB\project\EduLibDB\book.csv';
SELECT * FROM Library.books;
SELECT * FROM Library.Libeventlog WHERE resone LIKE 'Imported books%';


