CREATE TABLE person (
   national_id char(10) PRIMARY KEY,
   first_name NVARCHAR(50),
   last_name NVARCHAR(50),
   email NVARCHAR(50) null,
   username NVARCHAR(50),
   password_hash varchar(50)
);


CREATE TABLE Education.department (
    dept_name NVARCHAR(50) PRIMARY KEY,
    building NVARCHAR(50),
    budget FLOAT
);

CREATE TABLE Education.degree_level (
    level_id INT PRIMARY KEY,
    name NVARCHAR(50)
);

CREATE TABLE Education.major (
    major_id INT PRIMARY KEY,
    name NVARCHAR(100),
    dept_name NVARCHAR(50),
    FOREIGN KEY (dept_name) REFERENCES Education.department(dept_name)
);

CREATE TABLE Education.special_package (
    package_id INT PRIMARY KEY,
    name NVARCHAR(100),
    major_id INT,
    FOREIGN KEY (major_id) REFERENCES Education.major(major_id)
);

CREATE TABLE Education.instructor (
    instructor_id INT PRIMARY KEY,
    national_id char(10) UNIQUE,
    dept_name NVARCHAR(50),
    salary FLOAT,
    employment_status INT DEFAULT 1,
    FOREIGN KEY (national_id) REFERENCES person(national_id),
    FOREIGN KEY (dept_name) REFERENCES Education.department(dept_name)
);

/*education status 1-12 ok , 13 educated , 14 fired , 15 withdrow (cancelled edu) */
CREATE TABLE Education.student (
    student_id INT PRIMARY KEY,
    national_id char(10) UNIQUE,
    dept_name NVARCHAR(50),
    major_id INT,
    advisor_id INT,
    tot_cred INT,
    education_status INT,
    current_term INT,
    level_id INT,
    package_id INT NULL,
    FOREIGN KEY (national_id) REFERENCES dbo.person(national_id),
    FOREIGN KEY (dept_name) REFERENCES Education.department(dept_name),
    FOREIGN KEY (major_id) REFERENCES Education.major(major_id),
    FOREIGN KEY (advisor_id) REFERENCES Education.instructor(instructor_id),
    FOREIGN KEY (level_id) REFERENCES Education.degree_level(level_id),
    FOREIGN KEY (package_id) REFERENCES Education.special_package(package_id)
);

CREATE TABLE Education.course (
    course_id NVARCHAR(10) PRIMARY KEY,
    title NVARCHAR(100),
    dept_name NVARCHAR(50),
    credits INT,
    suggested_term INT,
    FOREIGN KEY (dept_name) REFERENCES Education.department(dept_name)
);

CREATE TABLE Education.course_plan (
    course_id NVARCHAR(10),
    major_id INT,
    level_id INT,
    package_id INT NULL,
    suggested_term INT,
    type NVARCHAR(20),
    PRIMARY KEY (course_id, major_id, level_id),
    FOREIGN KEY (course_id) REFERENCES Education.course(course_id),
    FOREIGN KEY (major_id) REFERENCES Education.major(major_id),
    FOREIGN KEY (level_id) REFERENCES Education.degree_level(level_id),
    FOREIGN KEY (package_id) REFERENCES Education.special_package(package_id)
);

CREATE TABLE Education.classroom (
    building NVARCHAR(50),
    room_number NVARCHAR(10),
    capacity INT,
    PRIMARY KEY (building, room_number)
);

CREATE TABLE Education.time_slot (
    time_slot_id NVARCHAR(10),
    day NVARCHAR(10),
    start_time TIME,
    end_time TIME,
    PRIMARY KEY (time_slot_id)
);

CREATE TABLE Education.section (
    course_id NVARCHAR(10),
    sec_id NVARCHAR(10),
    semester NVARCHAR(10),
    year INT,
    building NVARCHAR(50),
    room_number NVARCHAR(10),
    time_slot_id NVARCHAR(10),
    PRIMARY KEY (course_id, sec_id, semester, year),
    FOREIGN KEY (course_id) REFERENCES Education.course(course_id),
    FOREIGN KEY (building, room_number) REFERENCES Education.classroom(building, room_number),
    FOREIGN KEY (time_slot_id) REFERENCES Education.time_slot(time_slot_id)
);

CREATE TABLE Education.prerequisite (
    course_id NVARCHAR(10),
    preq_id NVARCHAR(10),
    PRIMARY KEY (course_id, preq_id),
    FOREIGN KEY (course_id) REFERENCES Education.course(course_id),
    FOREIGN KEY (preq_id) REFERENCES Education.course(course_id)
);

CREATE TABLE Education.corequisite (
    course_id NVARCHAR(10),
    coreq_id NVARCHAR(10),
    PRIMARY KEY (course_id, coreq_id),
    FOREIGN KEY (course_id) REFERENCES Education.course(course_id),
    FOREIGN KEY (coreq_id) REFERENCES Education.course(course_id)
);

CREATE TABLE Education.takes (
    student_id INT,
    course_id NVARCHAR(10),
    sec_id NVARCHAR(10),
    semester NVARCHAR(10),
    year INT,
    grade FLOAT,
    PRIMARY KEY (student_id, course_id, sec_id, semester, year),
    FOREIGN KEY (student_id) REFERENCES Education.student(student_id),
    FOREIGN KEY (course_id, sec_id, semester, year) REFERENCES Education.section(course_id, sec_id, semester, year)
);

CREATE TABLE Education.teaches (
    instructor_id INT,
    course_id NVARCHAR(10),
    sec_id NVARCHAR(10),
    semester NVARCHAR(10),
    year INT,
    PRIMARY KEY (instructor_id, course_id, sec_id, semester, year),
    FOREIGN KEY (instructor_id) REFERENCES Education.instructor(instructor_id),
    FOREIGN KEY (course_id, sec_id, semester, year) REFERENCES Education.section(course_id, sec_id, semester, year)
);

CREATE TABLE Education.TA (
    student_id INT,
    course_id NVARCHAR(10),
    sec_id NVARCHAR(10),
    semester NVARCHAR(10),
    year INT,
    PRIMARY KEY (student_id, course_id, sec_id, semester, year),
    FOREIGN KEY (student_id) REFERENCES Education.student(student_id),
    FOREIGN KEY (course_id, sec_id, semester, year) REFERENCES Education.section(course_id, sec_id, semester, year)
);

CREATE TABLE Education.employee (
    national_id char(10) PRIMARY KEY,
    role NVARCHAR(50),
    salary FLOAT,
    FOREIGN KEY (national_id) REFERENCES person(national_id)
);

CREATE TABLE Education.internship (
    internship_id INT PRIMARY KEY,
    student_id INT,
    company_name NVARCHAR(100),
    start_date DATE,
    end_date DATE,
    supervisor_name NVARCHAR(100),
    status NVARCHAR(20),
    FOREIGN KEY (student_id) REFERENCES Education.student(student_id)
);

CREATE TABLE Education.research_project (
    project_id INT PRIMARY KEY,
    title NVARCHAR(100),
    start_date DATE,
    end_date DATE,
    budget FLOAT,
    supervisor_id INT,
    FOREIGN KEY (supervisor_id) REFERENCES Education.instructor(instructor_id)
);

CREATE TABLE Education.participation (
    project_id INT,
    student_id INT,
    role NVARCHAR(50),
    PRIMARY KEY (project_id, student_id),
    FOREIGN KEY (project_id) REFERENCES Education.research_project(project_id),
    FOREIGN KEY (student_id) REFERENCES Education.student(student_id)
);

CREATE TABLE Education.log (
    log_id INT IDENTITY PRIMARY KEY,
    event_time DATETIME DEFAULT GETDATE(),
    table_name NVARCHAR(50),
    operation_type NVARCHAR(100),
    description NVARCHAR(MAX)
);


/* LIBRARY */

create table Library.category(
	category_id int identity primary key,
	category_name varchar(50) not null,
	description varchar(max) default null
)


create table Library.books (
	book_id int primary key identity,
	book_title varchar(50),
	category_id int,
	publish_date datetime,
	price   int ,
	status varchar(20) check(status in ('available','borrowed','disapear')),
	language varchar(20),
	foreign key(category_id) references Library.category	
)

create table library.magazines (
magazines_id INT identity primary key,
magazines_title varchar(50),
category_id int ,
publisher varchar(50),
magazines_language varchar(50),
periodicity varchar(20) check(periodicity in('daily','monthly','weekly','yearly') ),
FOREIGN KEY (category_id) REFERENCES library.category(category_id)

)


create table Library.Issue_magasines(
	issue_id int identity primary key,
	magazines_id int foreign key references Library.magazines,
	issue_number int,
	volume_number int,
	publish_date datetime ,
	decription varchar(max),
status varchar(50) not null check(status in ('available','borrowed','disapear'))
) 
 
create table library.articles(
	article_id int identity primary key,
	article_title varchar(50) not null,
	abstract varchar(max),
	publish_date datetime,
	article_language varchar(50),
 status varchar(50) not null check(status in ('available','borrowed','disapear'))
)

create table library.author(
author_id int identity primary key,
author_name varchar(50),
author_lastname varchar(50),
author_email varchar(50),
author_univercity varchar(50) null
)
 
 
create table library.article_author(
article_id int foreign key references library.articles,
author_id int foreign key references library.author,
primary key(author_id,article_id)
)


create table library.book_auhtor(
	book_id int foreign key references library.books,
	book_author int foreign key references library.author ,
	primary key(book_id,book_author)
)

CREATE TABLE library.users (
   user_id INT  identity PRIMARY KEY,
   person_id char(10) foreign key references person(national_id)
   ,is_active BIT default 1,
   create_time DATETIME DEFAULT GETDATE(),
   user_role VARCHAR(50),
   CONSTRAINT chk_user_role CHECK (user_role IN ('student', 'employee', 'instructor'))
);

create table library.borrowings (
	borrowing_id int identity primary key,
	user_id int foreign key references library.users,
	item_id int ,
	item_type varchar(14) check(item_type in ('book','atricle','magazine')),
	borrow_date datetime,
	due_time datetime,
	return_date datetime null,
	status varchar(15) not null default 'borrowed' check(status in ('borrowed','returnd','overdue') )
)

create table library.fines(
	fine_id int identity primary key,
	borrowing_id int ,
	amount int,
	fine_date datetime,
	paid int,
	payment_status varchar(50) check(payment_status in ('paid','unpaid')),
	reason varchar(max) null,
	foreign key (borrowing_id) references library.borrowings(borrowing_id)
)


create table library.reservation(
	reserve_id int identity primary key,
	user_id int,
	item_id int,
	item_type varchar(50) check(item_type in('book','magazine','article')),
	reservation_date datetime default getdate(),
	status varchar(50) check(status in ('cancell','active','fullfild')),
	expirt_date datetime not null
	foreign key (user_id) references library.users(user_id) 
)


create TABLE library.Libeventlog(
    log_id int IDENTITY PRIMARY KEY,
    user_id int FOREIGN key REFERENCES library.users(user_id),
    log_time datetime DEFAULT GETDATE(),
    resone NVARCHAR(100)  not NULL
)


