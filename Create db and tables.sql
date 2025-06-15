create database EduLibDB;

Create schema Education;

CREATE TABLE Education.person (
    national_id CHAR(10) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

CREATE TABLE Education.department (
    dept_name VARCHAR(50) PRIMARY KEY,
    building VARCHAR(50),
    budget FLOAT
);

CREATE TABLE Education.instructor (
    instructor_id INT PRIMARY KEY,
    national_id CHAR(10) UNIQUE,
    dept_name VARCHAR(50),
    salary FLOAT,
    FOREIGN KEY (national_id) REFERENCES Education.person(national_id),
    FOREIGN KEY (dept_name) REFERENCES Education.department(dept_name)
);

CREATE TABLE Education.student (
    student_id INT PRIMARY KEY,
    national_id CHAR(10) UNIQUE,
    dept_name VARCHAR(50),
    advisor_id INT,
    tot_cred INT,
    FOREIGN KEY (national_id) REFERENCES Education.person(national_id),
    FOREIGN KEY (dept_name) REFERENCES Education.department(dept_name),
    FOREIGN KEY (advisor_id) REFERENCES Education.instructor(instructor_id)
);

CREATE TABLE Education.course (
    course_id VARCHAR(10) PRIMARY KEY,
    title VARCHAR(100),
    dept_name VARCHAR(50),
    credits INT,
    FOREIGN KEY (dept_name) REFERENCES Education.department(dept_name)
);

CREATE TABLE Education.classroom (
    building VARCHAR(50),
    room_number VARCHAR(10),
    capacity INT,
    PRIMARY KEY (building, room_number)
);


CREATE TABLE Education.time_slot (
    time_slot_id VARCHAR(10),
    day VARCHAR(10),
    start_time TIME,
    end_time TIME,
    PRIMARY KEY (time_slot_id)
);

CREATE TABLE Education.section (
    course_id VARCHAR(10),
    sec_id VARCHAR(10),
    semester VARCHAR(10),
    year INT,
    building VARCHAR(50),
    room_number VARCHAR(10),
    time_slot_id VARCHAR(10),
    PRIMARY KEY (course_id, sec_id, semester, year),
    FOREIGN KEY (course_id) REFERENCES Education.course(course_id),
    FOREIGN KEY (building, room_number) REFERENCES Education.classroom(building, room_number),
    FOREIGN KEY (time_slot_id) REFERENCES Education.time_slot(time_slot_id)
);

CREATE TABLE Education.prerequisite (
    course_id VARCHAR(10),
    preq_id VARCHAR(10),
    PRIMARY KEY (course_id, preq_id),
    FOREIGN KEY (course_id) REFERENCES Education.course(course_id),
    FOREIGN KEY (preq_id) REFERENCES Education.course(course_id)
);

CREATE TABLE Education.corequisite (
    course_id VARCHAR(10),
    coreq_id VARCHAR(10),
    PRIMARY KEY (course_id, coreq_id),
    FOREIGN KEY (course_id) REFERENCES Education.course(course_id),
    FOREIGN KEY (coreq_id) REFERENCES Education.course(course_id)
);

CREATE TABLE Education.takes (
    student_id INT,
    course_id VARCHAR(10),
    sec_id VARCHAR(10),
    semester VARCHAR(10),
    year INT,
    grade CHAR(2),
    PRIMARY KEY (student_id, course_id, sec_id, semester, year),
    FOREIGN KEY (student_id) REFERENCES Education.student(student_id),
    FOREIGN KEY (course_id, sec_id, semester, year) REFERENCES Education.section(course_id, sec_id, semester, year)
);

CREATE TABLE Education.teaches (
    instructor_id INT,
    course_id VARCHAR(10),
    sec_id VARCHAR(10),
    semester VARCHAR(10),
    year INT,
    PRIMARY KEY (instructor_id, course_id, sec_id, semester, year),
    FOREIGN KEY (instructor_id) REFERENCES Education.instructor(instructor_id),
    FOREIGN KEY (course_id, sec_id, semester, year) REFERENCES Education.section(course_id, sec_id, semester, year)
);

CREATE TABLE Education.TA (
    student_id INT,
    course_id VARCHAR(10),
    sec_id VARCHAR(10),
    semester VARCHAR(10),
    year INT,
    PRIMARY KEY (student_id, course_id, sec_id, semester, year),
    FOREIGN KEY (student_id) REFERENCES Education.student(student_id),
    FOREIGN KEY (course_id, sec_id, semester, year) REFERENCES Education.section(course_id, sec_id, semester, year)
);

CREATE TABLE Education.employee (
    national_id CHAR(10) PRIMARY KEY,
    role VARCHAR(50),
    salary FLOAT,
    FOREIGN KEY (national_id) REFERENCES Education.person(national_id)
);

CREATE TABLE Education.internship (
    internship_id INT PRIMARY KEY,
    student_id INT,
    company_name VARCHAR(100),
    start_date DATE,
    end_date DATE,
    supervisor_name VARCHAR(100),
    status VARCHAR(20),
    FOREIGN KEY (student_id) REFERENCES Education.student(student_id)
);

CREATE TABLE Education.research_project (
    project_id INT PRIMARY KEY,
    title VARCHAR(100),
    start_date DATE,
    end_date DATE,
    budget FLOAT,
    supervisor_id INT,
    FOREIGN KEY (supervisor_id) REFERENCES Education.instructor(instructor_id)
);

CREATE TABLE Education.participation (
    project_id INT,
    student_id INT,
    role VARCHAR(50),
    PRIMARY KEY (project_id, student_id),
    FOREIGN KEY (project_id) REFERENCES Education.research_project(project_id),
    FOREIGN KEY (student_id) REFERENCES Education.student(student_id)
);



/* Log table */
CREATE TABLE Education.log (
    log_id INT IDENTITY PRIMARY KEY,
    event_time DATETIME DEFAULT GETDATE(),
    table_name VARCHAR(50),
    operation_type VARCHAR(10),
    description NVARCHAR(MAX)
);


/* Functions */
CREATE FUNCTION Education.fn_calculate_gpa (@student_id INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @gpa FLOAT;

    SELECT @gpa = AVG(
        CASE grade
            WHEN 'A' THEN 4.0
            WHEN 'B' THEN 3.0
            WHEN 'C' THEN 2.0
            WHEN 'D' THEN 1.0
            ELSE 0.0
        END
    )
    FROM Education.takes
    WHERE student_id = @student_id;

    RETURN @gpa;
END;



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
        AND grade IN ('A', 'B', 'C')
    )
        RETURN 1;
    RETURN 0;
END;



/* Procedures */
CREATE PROCEDURE Education.sp_register_student
    @student_id INT,
    @national_id CHAR(10),
    @dept_name VARCHAR(50),
    @advisor_id INT,
    @tot_cred INT
AS
BEGIN
    INSERT INTO Education.student VALUES (@student_id, @national_id, @dept_name, @advisor_id, @tot_cred);

    INSERT INTO Education.log (table_name, operation_type, description)
    VALUES ('Education.student', 'INSERT', 'Added student ID = ' + CAST(@student_id AS VARCHAR));
END;


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


/* Trigger */ 
CREATE TRIGGER Education.trg_log_insert_student
ON Education.student
AFTER INSERT
AS
BEGIN
    INSERT INTO Education.log (table_name, operation_type, description)
    SELECT 'Education.student', 'INSERT', 'Student ' + CAST(student_id AS VARCHAR) + ' inserted'
    FROM inserted;
END;



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
