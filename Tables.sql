
--CREATE TABLE Education.time_slot (
--    time_slot_id VARCHAR(10) PRIMARY KEY,
--    day VARCHAR(10),
--    start_time TIME,
--    end_time TIME
--);

--CREATE TABLE Education.corequisite (
--    course_id VARCHAR(10),
--    coreq_id VARCHAR(10),
--    PRIMARY KEY (course_id, coreq_id),
--    FOREIGN KEY (course_id) REFERENCES Education.course(course_id),
--    FOREIGN KEY (coreq_id) REFERENCES Education.course(course_id)
--);
--CREATE TABLE Education.takes (
--    student_id INT,
--    course_id VARCHAR(10),
--    sec_id VARCHAR(10),
--    semester VARCHAR(10),
--    year INT,
--    grade CHAR(2),
--    PRIMARY KEY (student_id, course_id, sec_id, semester, year),
--    FOREIGN KEY (student_id) REFERENCES Education.student(student_id),
--    FOREIGN KEY (course_id, sec_id, semester, year) REFERENCES Education.section(course_id, sec_id, semester, year)
--);


--CREATE TABLE Education.teaches (
--    instructor_id INT,
--    course_id VARCHAR(10),
--    sec_id VARCHAR(10),
--    semester VARCHAR(10),
--    year INT,
--    PRIMARY KEY (instructor_id, course_id, sec_id, semester, year),
--    FOREIGN KEY (instructor_id) REFERENCES Education.instructor(instructor_id),
--    FOREIGN KEY (course_id, sec_id, semester, year) REFERENCES Education.section(course_id, sec_id, semester, year)
--);

--CREATE TABLE Education.TA (
--    student_id INT,
--    course_id VARCHAR(10),
--    sec_id VARCHAR(10),
--    semester VARCHAR(10),
--    year INT,
--    PRIMARY KEY (student_id, course_id, sec_id, semester, year),
--    FOREIGN KEY (student_id) REFERENCES Education.student(student_id),
--    FOREIGN KEY (course_id, sec_id, semester, year) REFERENCES Education.section(course_id, sec_id, semester, year)
--);

--CREATE TABLE Education.employee (
--    national_id CHAR(10) PRIMARY KEY,
--    role VARCHAR(50),
--    salary FLOAT,
--    FOREIGN KEY (national_id) REFERENCES Education.person(national_id)
--);

--CREATE TABLE Education.internship (
--    internship_id INT PRIMARY KEY,
--    student_id INT,
--    company_name VARCHAR(100),
--    start_date DATE,
--    end_date DATE,
--    supervisor_name VARCHAR(100),
--    status VARCHAR(20),
--    FOREIGN KEY (student_id) REFERENCES Education.student(student_id)
--);

--CREATE TABLE Education.research_project (
--    project_id INT PRIMARY KEY,
--    title VARCHAR(100),
--    start_date DATE,
--    end_date DATE,
--    budget FLOAT,
--    supervisor_id INT,
--    FOREIGN KEY (supervisor_id) REFERENCES Education.instructor(instructor_id)
--);

--CREATE TABLE Education.project_participation (
--    project_id INT,
--    student_id INT,
--    role VARCHAR(50),
--    PRIMARY KEY (project_id, student_id),
--    FOREIGN KEY (project_id) REFERENCES Education.research_project(project_id),
--    FOREIGN KEY (student_id) REFERENCES Education.student(student_id)
--);

--CREATE TABLE person (
--    national_id int PRIMARY KEY,
--    first_name VARCHAR(50),
--    last_name VARCHAR(50),
--    email VARCHAR(50) null,
--    username VARCHAR(50),
--    password_hash varchar(50)
--);

--CREATE TABLE Education.section (
--    course_id VARCHAR(10),
--    sec_id VARCHAR(10),
--    semester VARCHAR(10),
--    year INT,
--    building VARCHAR(50),
--    room_number VARCHAR(10),
--    time_slot_id VARCHAR(10),
--    PRIMARY KEY (course_id, sec_id, semester, year),
--    FOREIGN KEY (course_id) REFERENCES Education.course(course_id),
--    FOREIGN KEY (building, room_number) REFERENCES Education.classroom(building, room_number),
--    FOREIGN KEY (time_slot_id) REFERENCES Education.time_slot(time_slot_id)
--);
--CREATE TABLE Education.prerequisite (
--    course_id VARCHAR(10),
--    preq_id VARCHAR(10),
--    PRIMARY KEY (course_id, preq_id),
--    FOREIGN KEY (course_id) REFERENCES Education.course(course_id),
--    FOREIGN KEY (preq_id) REFERENCES Education.course(course_id)
--);

/* LIBRARY */

--create table Library.category(
--	category_id int identity primary key,
--	category_name varchar(50) not null,
--	description varchar(max) default null
--)


--create table Library.books (
--	book_id int primary key identity,
--	book_title varchar(50),
--	category_id int,
--	publish_date datetime,
--	price   int ,
--	status varchar(20) check(status in ('available','borrowed','disapear')),
--	language varchar(20),
--	foreign key(category_id) references Library.category	
--)

--create table library.magazines (
--magazines_id INT identity primary key,
--magazines_title varchar(50),
--category_id int ,
--publisher varchar(50),
--magazines_language varchar(50),
--periodicity varchar(20) check(periodicity in('daily','monthly','weekly','yearly') ),
--FOREIGN KEY (category_id) REFERENCES library.category(category_id)

--)


--create table Library.Issue_magasines(
--	issue_id int identity primary key,
--	magazines_id int foreign key references Library.magazines,
--	issue_number int,
--	volume_number int,
--	publish_date datetime ,
--	decription varchar(max),
-- status varchar(50) not null check(status in ('available','borrowed','disapear'))
--) 
 
-- create table library.articles(
--	article_id int identity primary key,
--	article_title varchar(50) not null,
--	abstract varchar(max),
--	publish_date datetime,
--	article_language varchar(50),
--  status varchar(50) not null check(status in ('available','borrowed','disapear'))
-- )

-- create table library.author(
-- author_id int identity primary key,
-- author_name varchar(50),
-- author_lastname varchar(50),
-- author_email varchar(50),
-- author_univercity varchar(50) null
-- )
 
 
-- create table library.article_author(
-- article_id int foreign key references library.articles,
-- author_id int foreign key references library.author,
-- primary key(author_id,article_id)
-- )


-- create table library.book_auhtor(
--	book_id int foreign key references library.books,
--	book_author int foreign key references library.author ,
--	primary key(book_id,book_author)
-- )

-- CREATE TABLE library.users (
--    user_id INT  identity PRIMARY KEY,
--    person_id INT foreign key references Education.person(national_id)
--    ,is_active BIT default 1,
--    create_time DATETIME DEFAULT GETDATE(),
--    user_role VARCHAR(50),
--    CONSTRAINT chk_user_role CHECK (user_role IN ('student', 'employee', 'instructor'))
--);

--create table library.borrowings (
--	borrowing_id int identity primary key,
--	user_id int foreign key references library.users,
--	item_id int ,
--	item_type varchar(14) check(item_type in ('book','atricle','magazines')),
--	borrow_date datetime,
--	due_time datetime,
--	return_date datetime null,
--	status varchar(15) not null default 'borrowed' check(status in ('borrowd','returnd','overdue') )
--)

--create table library.fines(
--	fine_id int identity primary key,
--	borrowing_id int ,
--	amount int,
--	fine_date datetime,
--	paid int,
--	payment_status varchar(50) check(payment_status in ('paid','unpaid')),
--	reason varchar(max) null,
--	foreign key (borrowing_id) references library.borrowings(borrowing_id)
--)


--create table library.reservation(
--	reserve_id int identity primary key,
--	user_id int,
--	item_id int,
--	item_type varchar(50) check(item_type in('book','magazines','articles')),
--	reservation_date datetime default getdate(),
--	status varchar(50) check(status in ('cancell','active','fullfild')),
--	expirt_date datetime not null
--	foreign key (user_id) references library.users(user_id) 
--)


