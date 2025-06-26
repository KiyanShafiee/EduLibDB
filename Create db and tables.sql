CREATE TABLE Education.department (
    dept_name VARCHAR(50) PRIMARY KEY,
    building VARCHAR(50),
    budget FLOAT
);

CREATE TABLE Education.instructor (
    instructor_id INT PRIMARY KEY,
    national_id CHAR(11) UNIQUE,
    dept_name VARCHAR(50),
    salary FLOAT,
    employment_status INT DEFAULT 1, --1:Employed & 2:Retired
    FOREIGN KEY (national_id) REFERENCES Education.person(national_id),
    FOREIGN KEY (dept_name) REFERENCES Education.department(dept_name)
);

CREATE TABLE Education.student (
    student_id INT PRIMARY KEY,
    national_id CHAR(10) UNIQUE,
    dept_name VARCHAR(50),
    major_id INT,
    advisor_id INT,
    tot_cred INT,
    education_status INT,
    current_term INT,
    level_id INT,
    package_id INT NULL,
    FOREIGN KEY (national_id) REFERENCES Education.person(national_id),
    FOREIGN KEY (dept_name) REFERENCES Education.department(dept_name),
    FOREIGN KEY (major_id) REFERENCES Education.major(major_id),
    FOREIGN KEY (advisor_id) REFERENCES Education.instructor(instructor_id),
    FOREIGN KEY (level_id) REFERENCES Education.degree_level(level_id),
    FOREIGN KEY (package_id) REFERENCES Education.special_package(package_id)
);


CREATE TABLE Education.major (
    major_id INT PRIMARY KEY,
    name NVARCHAR(100),
    dept_name VARCHAR(50),
    FOREIGN KEY (dept_name) REFERENCES Education.department(dept_name)
);

CREATE TABLE Education.degree_level (
    level_id INT PRIMARY KEY, --1:bachelor,2:master, 3:doctorate
    name NVARCHAR(50)
);

CREATE TABLE Education.special_package (
    package_id INT PRIMARY KEY,
    name NVARCHAR(100),
    major_id INT,
    FOREIGN KEY (major_id) REFERENCES Education.major(major_id)
);


CREATE TABLE Education.course (
    course_id VARCHAR(10) PRIMARY KEY,
    title VARCHAR(100),
    dept_name VARCHAR(50),
    credits INT,
    suggested_term TINYINT,
    FOREIGN KEY (dept_name) REFERENCES Education.department(dept_name)
);


CREATE TABLE Education.course_plan (
    course_id VARCHAR(10),
    major_id INT,
    level_id INT,
    package_id INT NULL,
    suggested_term INT,
    type VARCHAR(20),
    PRIMARY KEY (course_id, major_id, level_id, ISNULL(package_id, 0)),
    FOREIGN KEY (course_id) REFERENCES Education.course(course_id),
    FOREIGN KEY (major_id) REFERENCES Education.major(major_id),
    FOREIGN KEY (level_id) REFERENCES Education.degree_level(level_id),
    FOREIGN KEY (package_id) REFERENCES Education.special_package(package_id)
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
    grade FLOAT,
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

CREATE TABLE Education.log (
    log_id INT IDENTITY PRIMARY KEY,
    event_time DATETIME DEFAULT GETDATE(),
    table_name VARCHAR(50),
    operation_type VARCHAR(10),
    description NVARCHAR(MAX)
);