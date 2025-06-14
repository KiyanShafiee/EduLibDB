create database EduLibDB;

Create schema Education;




CREATE TABLE Education.time_slot (
    time_slot_id VARCHAR(10) PRIMARY KEY,
    day VARCHAR(10),
    start_time TIME,
    end_time TIME
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
CREATE TABLE takes (
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

CREATE TABLE Education.project_participation (
    project_id INT,
    student_id INT,
    role VARCHAR(50),
    PRIMARY KEY (project_id, student_id),
    FOREIGN KEY (project_id) REFERENCES Education.research_project(project_id),
    FOREIGN KEY (student_id) REFERENCES Education.student(student_id)
);
