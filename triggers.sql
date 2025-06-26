

/* **************** Education **************** */
CREATE TRIGGER Education.trg_log_insert_student
ON Education.student
AFTER INSERT
AS
BEGIN
    INSERT INTO Education.log (table_name, operation_type, description)
    SELECT 'Education.student', 'INSERT', 'Student ' + CAST(student_id AS VARCHAR) + ' inserted'
    FROM inserted;
END;
go
CREATE TRIGGER Education.trg_log_grade_update
ON Education.takes
AFTER UPDATE
AS
BEGIN
    IF UPDATE(grade)
    BEGIN
        INSERT INTO Education.log (table_name, operation_type, description)
        SELECT 'Education.takes', 'UPDATE',
               'Grade updated for student ' + CAST(i.student_id AS VARCHAR) + ' in course ' + i.course_id
        FROM inserted i;
    END
END;
go
CREATE TRIGGER Education.trg_delete_instructor_employee
ON Education.instructor
AFTER DELETE
AS
BEGIN
    DELETE FROM Education.employee
    WHERE national_id IN (SELECT national_id FROM deleted);

    INSERT INTO Education.log (table_name, operation_type, description)
    SELECT 'Education.instructor/employee', 'DELETE',
           'Instructor and employee with NID ' + national_id + ' deleted'
    FROM deleted;
END;


go
-- this should be complete by library:
CREATE TRIGGER Education.trg_student_status_update
ON Education.student
AFTER UPDATE
AS
BEGIN
    IF UPDATE(education_status)
    BEGIN
        INSERT INTO Education.log (table_name, operation_type, description)
        SELECT 'Library.account', 'UPDATE',
               'Library access updated for student ' + CAST(i.student_id AS VARCHAR) +
               ' due to status change to ' + CAST(i.education_status AS VARCHAR)
        FROM inserted i;
    END
END;






/* **************** Library **************** */

------go 
------CREATE TRIGGER trg_insert_replace_fine
------ON library.fines
------INSTEAD OF INSERT
------AS
------BEGIN

------    WITH ExistingPaid AS (
------        SELECT borrowing_id, paid
------        FROM library.fines
------        WHERE borrowing_id IN (SELECT borrowing_id FROM inserted)
------    )

------    DELETE FROM library.fines
------    WHERE borrowing_id IN (SELECT borrowing_id FROM inserted);

------    INSERT INTO library.fines (borrowing_id, amount, fine_date, paid, payment_status, reason)
------    SELECT
------        i.borrowing_id,
------        i.amount,
------        i.fine_date,
------        ISNULL(e.paid, i.paid),
------        i.payment_status,
------        i.reason
------    FROM inserted i
------    LEFT JOIN ExistingPaid as e ON i.borrowing_id = e.borrowing_id;
------END;



--go
--CREATE TRIGGER trg_after_return_update_status
--ON library.borrowings
--AFTER UPDATE
--AS
--BEGIN

--    IF EXISTS (SELECT 1 FROM inserted WHERE return_date IS NOT NULL)
--    BEGIN
--        UPDATE library.borrowings
--        SET status = 'returnd'
--        FROM library.borrowings b
--        JOIN inserted i ON b.borrowing_id = i.borrowing_id
--        WHERE i.return_date IS NOT NULL;


--        UPDATE b
--        SET b.status = 'available'
--        FROM library.books b
--        JOIN inserted i ON b.book_id = i.item_id
--        WHERE i.item_type = 'book' AND i.return_date IS NOT NULL;

--        UPDATE m
--        SET m.status = 'available'
--        FROM library.Issue_magasines m
--        JOIN inserted i ON m.issue_id = i.item_id
--        WHERE i.item_type = 'magazines' AND i.return_date IS NOT NULL;

      
--         UPDATE a
--         SET a.status = 'available'
--         FROM library.articles a
--         JOIN inserted i ON a.article_id = i.item_id
--         WHERE i.item_type = 'article' AND i.return_date IS NOT NULL;
--    END
--END;




go 
CREATE TRIGGER trg_before_insert_borrowing_check_availability
ON library.borrowings
INSTEAD OF INSERT
AS
BEGIN
   SET NOCOUNT ON;

   IF EXISTS (
       SELECT 1
       FROM inserted i
       JOIN library.books b ON i.item_id = b.book_id
       WHERE i.item_type = 'book' AND b.status <> 'available'
   )
   BEGIN
       RAISERROR('This book is not available for borrowing.', 16, 1);
       RETURN;
   END


   IF EXISTS (
       SELECT 1
       FROM inserted i
       JOIN library.Issue_magasines m ON i.item_id = m.issue_id
       WHERE i.item_type = 'magazines' AND m.status <> 'available'
   )
   BEGIN
       RAISERROR('This magazine is not available for borrowing.', 16, 1);
       RETURN;
   END


    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN library.articles a ON i.item_id = a.article_id
        WHERE i.item_type = 'article' AND a.status <> 'available'
    )
    BEGIN
        RAISERROR('This article is not available for borrowing.', 16, 1);
        RETURN;
    END


   INSERT INTO library.borrowings (user_id, item_id, item_type, borrow_date, due_time, return_date, status)
   SELECT user_id, item_id, item_type, borrow_date, due_time, return_date, status
   FROM inserted;
END;


--trg_after_return_update_status  Description

--This trigger is executed after an update on the library.borrowings table.
--It checks whether the return_date has been filled in (indicating the item was returned).
--If so:

--It updates the borrowing status to 'returnd'.

--It also sets the associated item's status (book or magazine) back to 'available', making it borrowable again.

-- trg_before_insert_borrowing_check_availability  Description

--This trigger runs instead of an insert into the library.borrowings table.
--Before inserting a new borrowing record, it checks whether the requested item (book or magazine) is currently available.
--If the item is already borrowed (i.e., not 'available'), the insert is blocked and an error message is raised.
--Otherwise, the borrowing record is successfully inserted.

go
create TRIGGER trg_user_log 
on library.users 
after INSERT 
as 
BEGIN 
insert into Library.Libeventlog (user_id,resone) 
select i.user_id , CONCAT('[ADD] NEW USER WITH PERSON_ID ',i.person_id , ' ADDED !')
FROM inserted AS I 
END

go
CREATE TRIGGER trg_log_reservation_status_change
ON library.reservation
AFTER UPDATE
AS
BEGIN
    INSERT INTO library.Libeventlog (user_id, resone)
    SELECT 
        i.user_id,
        CONCAT('[WARNING] Reservation status changed to ', i.status, ' for ', i.item_type, ' ID ', i.item_id)
    FROM inserted i
    JOIN deleted d ON i.reserve_id = d.reserve_id
    WHERE i.status <> d.status
END

 GO
 CREATE TRIGGER trg_log_borrowing
ON library.borrowings
AFTER INSERT
AS
BEGIN
    INSERT INTO library.Libeventlog (user_id, resone)
    SELECT 
        i.user_id,
        CONCAT('[WARNING] User borrowed a ', i.item_type, ' with ID ', i.item_id)
    FROM inserted i
END

go
create TRIGGER trg_add_user_student
on Education.student
after INSERT 
as 
begin 
begin try 
    INSERT into library.users (person_id , is_active, create_time , user_role)
    select i.national_id , 1,GETDATE(), 'student'
    from inserted as i 
end try 
BEGIN CATCH 
    ROLLBACK TRANSACTION
    return 
end CATCH
END

go
CREATE TRIGGER trg_disable_graduted_fired_withdrow_student 
on education.student
after UPDATE 
as 
begin 

    update Library.users
    set is_active =0
    WHERE person_id in (select i.national_id from inserted as i join deleted as d on i.student_id = d.student_id and i.education_status != d.education_status and i.education_status >=13)
end













