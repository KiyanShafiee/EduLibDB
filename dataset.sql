delete from dbo.person
delete from Education.student
delete from Library.book_auhtor
delete from library.fines
DELETE from library.borrowings
delete from Library.books
DELETE from library.category
delete from Library.author
DELETE from Library.Issue_magasines

DELETE FROM Education.participation;
DELETE FROM Education.research_project;
DELETE FROM Education.internship;
DELETE FROM Education.employee;
DELETE FROM Education.TA;
DELETE FROM Education.teaches;
DELETE FROM Education.section;
DELETE FROM Education.time_slot;
DELETE FROM Education.classroom;
DELETE FROM Education.takes;
DELETE FROM Education.corequisite;
DELETE FROM Education.prerequisite;
DELETE FROM Education.course_plan;
DELETE FROM Education.course;
DELETE FROM Education.special_package;
DELETE FROM Education.student;
DELETE FROM Education.instructor;
DELETE FROM Education.degree_level;
DELETE FROM Education.major;
DELETE FROM Education.department;
DELETE FROM person;


INSERT INTO person (national_id, first_name, last_name, email, username, password_hash)
VALUES 
(1000000011, 'Ali', 'Ahmadi', 'ali.ahmadi@example.com', 'ali_user1', 'pass1'),
(1000000028, 'Sara', 'Moradi', 'sara.moradi@example.com', 'sara_user2', 'pass2'),
(1000000036, 'Reza', 'Jafari', 'reza.jafari@example.com', 'reza_user3', 'pass3'),
(1000000044, 'Niloofar', 'Karimi', 'niloofar.k@example.com', 'nilo_user4', 'pass4'),
(1000000052, 'Mohammad', 'Shiri', 'mohammad.sh@example.com', 'moh_user5', 'pass5');
-- add user
-- DECLARE @pid INT;

-- DECLARE user_cursor CURSOR FOR
-- SELECT national_id
-- FROM person
-- WHERE national_id NOT IN (
--     SELECT person_id FROM library.users
-- );

-- OPEN user_cursor;
-- FETCH NEXT FROM user_cursor INTO @pid;

-- WHILE @@FETCH_STATUS = 0
-- BEGIN
--     BEGIN TRY
--         EXEC library.create_lib_user @pid;
--     END TRY
--     BEGIN CATCH
--         PRINT 'Error for person ID: ' + CAST(@pid AS VARCHAR) + ' - ' + ERROR_MESSAGE();
--     END CATCH;

--     FETCH NEXT FROM user_cursor INTO @pid;
-- END

-- CLOSE user_cursor;
-- DEALLOCATE user_cursor;



INSERT INTO Library.category (category_name, description)
VALUES 
('Science', 'Scientific Books and Journals'),
('Technology', 'Tech-related Publications'),
('Art', 'Art and Design'),
('Education', 'Educational Materials'),
('History', 'Historical Resources');

INSERT INTO Library.books (book_title, category_id, publish_date, price, status, language)
VALUES 
('SQL Basics', 6, '2020-01-01', 150000, 'available', 'English'),
('Data Structures', 7, '2019-05-20', 180000, 'available', 'English'),
('Advanced C++', 7, '2021-03-15', 200000, 'available', 'English'),
('Database Design', 6, '2018-09-12', 175000, 'available', 'English'),
('Machine Learning', 6, '2022-11-05', 220000, 'available', 'English'),
('advance programing', 6, '2023-11-05', 220000, 'available', 'English'),
('fabel', 2, '2023-11-05', 220000, 'available', 'English');

INSERT INTO library.author (author_name, author_lastname, author_email, author_univercity)
VALUES 
('John', 'Doe', 'john.doe@example.com', 'MIT'),
('Anna', 'Smith', 'anna.smith@example.com', 'Harvard'),
('David', 'Clark', 'david.clark@example.com', 'Stanford'),
('Mary', 'Jones', 'mary.jones@example.com', 'Berkeley'),
('Ali', 'Zarei', 'ali.zarei@example.com', 'IUT'),
('Hassan', 'Najafi', 'hnajafi@example.com', 'University of Tehran'),
('Leila', 'Rahimi', 'lrahimi@example.com', 'Sharif University'),
('Omid', 'Hosseini', 'ohosseini@example.com', 'Isfahan University'),
('Fatemeh', 'Zarei', 'fzarei@example.com', 'IUT'),
('Nima', 'Khalili', 'nkhalili@example.com', 'AUT');


INSERT INTO library.book_auhtor (book_id, book_author)
VALUES 
(7,21),(8,22),(9,23),(10,24),(11,25);

INSERT INTO library.borrowings (user_id, item_id, item_type, borrow_date, due_time, return_date, status)
VALUES 
(1, 7, 'book', '2024-01-10', '2024-01-20', '2024-01-19', 'returnd'),
(1, 8, 'book', '2024-03-15', '2024-03-25', NULL, 'borrowed'),
(2, 9, 'book', '2024-02-10', '2024-02-20', NULL, 'borrowed'),
(3, 10, 'book', '2024-02-12', '2024-02-22', NULL, 'borrowed'),
(4, 11, 'book', '2024-02-14', '2024-02-24', NULL, 'borrowed'),
(1, 14, 'book', '2025-02-14', '2025-02-24', '2025-01-24', 'returnd'),
(1, 15, 'book', '2025-02-14', '2025-02-24', '2025-01-24', 'returnd'),
(2, 14, 'book', '2025-02-14', '2025-02-24', '2025-01-24', 'returnd'),
(2, 15, 'book', '2025-03-14', '2025-03-24', '2025-03-24', 'returnd');




INSERT INTO library.fines (borrowing_id, amount, fine_date, paid, payment_status, reason)
VALUES 
(7, 5000, '2024-01-25', 0, 'unpaid', 'Late return'),
(8, 10000, '2024-04-01', 0, 'unpaid', 'Still not returned');

INSERT INTO library.magazines (magazines_title, category_id, publisher, magazines_language, periodicity)
VALUES
('Tech Today', 7, 'TechHouse', 'English', 'monthly'),
('Science Weekly', 6, 'SciGroup', 'English', 'weekly'),
('Education Monthly', 9, 'EduPub', 'Persian', 'monthly'),
('Historical Times', 10, 'HistPress', 'English', 'yearly'),
('Creative Arts', 8, 'ArtPrint', 'English', 'monthly');

INSERT INTO Library.Issue_magasines (magazines_id, issue_number, volume_number, publish_date, decription, status)
VALUES 
(2, 1, 5, '2024-01-01', 'Tech Trends', 'available'),
(3, 12, 2, '2024-06-01', 'Weekly Science Digest', 'available'),
(4, 3, 1, '2024-04-01', 'Educational News', 'available'),
(5, 10, 6, '2023-12-20', 'History Journal', 'available'),
(6, 7, 3, '2024-02-01', 'Modern Art Topics', 'available');


INSERT INTO library.articles (article_title, abstract, publish_date, article_language, status)
VALUES
('AI in Education', 'The impact of AI in learning systems.', '2023-10-01', 'English', 'available'),
('Quantum Mechanics', 'Advanced theory in quantum science.', '2023-07-10', 'English', 'available'),
('Modern Art', 'Discussion on post-modern art.', '2024-01-15', 'English', 'available'),
('Data Privacy', 'GDPR and data protection.', '2022-11-11', 'English', 'available'),
('Climate Change', 'Environmental analysis.', '2023-03-05', 'English', 'available');


INSERT INTO library.article_author (article_id, author_id)
VALUES
(1, 26), (2, 27), (3, 28), (4, 29), (5, 30);

INSERT INTO library.reservation (user_id, item_id, item_type, status, expirt_date)
VALUES
(1, 7, 'book', 'active', '2024-07-10'),
(2, 2, 'magazines', 'active', '2024-07-12'),
(3, 3, 'articles', 'active', '2024-07-15'),
(4, 8, 'book', 'active', '2024-07-18'),
(5, 5, 'magazines', 'active', '2024-07-20');


----- ******* education dataset ****** -------
-- درج داده‌ها در جدول person
INSERT INTO person (national_id, first_name, last_name, email, username, password_hash)
VALUES
(1274444608, N'علی', N'احمدی', 'ali.ahmadi@test.com', 'ali.ahmadi', 'hashedpass1'),
(1274444675, N'سارا', N'حسینی', 'sara.hosseini@test.com', 'sara.hosseini', 'hashedpass2'),
(1234896575, N'رضا', N'محمدی', 'reza.mohammadi@test.com', 'reza.mohammadi', 'hashedpass3'),
(1284725286, N'مریم', N'کریمی', 'maryam.karimi@test.com', 'maryam.karimi', 'hashedpass4'),
(1000000052, N'حسین', N'صفری', 'hossein.safari@test.com', 'hossein.safari', 'hashedpass5'),
(1000000044, N'محمد', N'رضایی', 'mohammad.rezaei@test.com', 'mohammad.rezaei', 'hashedpass6'),
(1000000036, N'فاطمه', N'علوی', 'fateme.alavi@test.com', 'fateme.alavi', 'hashedpass7'),
(1000000028, N'نیما', N'یوسفی', 'nima.yousefi@test.com', 'nima.yousefi', 'hashedpass8');

-- درج داده‌ها در جدول department
INSERT INTO Education.department (dept_name, building, budget)
VALUES
(N'CS', N'رایانه و برق', 1000000),
(N'Math', N'ریاضی', 900000),
(N'Physics', N'فیزیک', 1000000),
(N'General', N'مطالعات عمومی', 5000000),
(N'Electrical', N'مهندسی برق', 2000000),
(N'IT', N'فناوری اطلاعات', 1000000),
(N'Security', N'امنیت سایبری', 1000000);

-- درج داده‌ها در جدول degree_level
INSERT INTO Education.degree_level (level_id, name)
VALUES
(1, N'کارشناسی'),
(2, N'کارشناسی ارشد');

-- درج داده‌ها در جدول major
INSERT INTO Education.major (major_id, name, dept_name)
VALUES
(1, N' مهندسی کامیپوتر', N'CS'),
(2, N'مهدسی برق', N'IT'),
(3, N'مهندسی معماری', N'Security');

-- درج داده‌ها در جدول instructor
INSERT INTO Education.instructor (instructor_id, national_id, dept_name, salary, employment_status)
VALUES
(1, 1234896575, N'CS', 28000000, 1),
(2, 1000000052, N'IT', 25000000, 1),
(3, 1000000028, N'Security', 27000000, 1);

-- درج داده‌ها در جدول special_package
INSERT INTO Education.special_package (package_id, name, major_id)
VALUES
(1, N'بسته هوش مصنوعی', 1),
(2, N'بسته مهندسی نرم‌افزار', 1),
(3, N'بسته مدیریت فناوری اطلاعات', 2),
(4, N'بسته امنیت سایبری', 3);

-- درج داده‌ها در جدول student
INSERT INTO Education.student (student_id, national_id, dept_name, major_id, advisor_id, tot_cred, education_status, current_term, level_id, package_id)
VALUES
(40234473, 1274444608, N'CS', 1, 1, 20, 1, 6, 1, 2), -- در حال تحصیل
(40225689, 1284725286, N'IT', 2, 2, 50, 13, 8, 1, 3), -- فارغ‌التحصیل
(40258698, 1274444675, N'Security', 3, 3, 80, 14, 7, 1, 4), -- انصرافی
(40298765, 1000000044, N'CS', 1, 1, 30, 15, 5, 1, 2); -- اخراجی



-- درج داده‌ها در جدول course
INSERT INTO Education.course (course_id, title, dept_name, credits, suggested_term)
VALUES
('CS101', N'مقدمه‌ای بر علوم کامپیوتر', N'CS', 3, 1),
('MATH101', N'حساب دیفرانسیل و انتگرال ۱', N'Math', 3, 1),
('PHYS101', N'فیزیک ۱', N'Physics', 3, 1),
('CS102', N'مبانی برنامه‌نویسی', N'CS', 3, 2),
('MATH102', N'حساب دیفرانسیل و انتگرال ۲', N'Math', 3, 2),
('CS201', N'ساختمان داده‌ها', N'CS', 3, 3),
('CS301', N'سیستم‌های عامل', N'CS', 3, 5),
('AI401', N'مقدمه‌ای بر هوش مصنوعی', N'CS', 3, 6),
('IT401', N'زیرساخت فناوری اطلاعات', N'IT', 3, 6),
('SEC401', N'مقدمه‌ای بر امنیت سایبری', N'Security', 3, 6);

-- درج داده‌ها در جدول course_plan
DECLARE @major INT = 1;
WHILE @major <= 3
BEGIN
  INSERT INTO Education.course_plan (course_id, major_id, level_id, package_id, suggested_term, type)
  SELECT course_id, @major, 1, NULL, suggested_term, 'base'
  FROM Education.course
  WHERE suggested_term BETWEEN 1 AND 5;
  SET @major = @major + 1;
END;

-- درج دروس تخصصی برای بسته‌ها
INSERT INTO Education.course_plan (course_id, major_id, level_id, package_id, suggested_term, type)
VALUES
('AI401', 1, 1, 1, 6, 'major'),
('IT401', 2, 1, 3, 6, 'major'),
('SEC401', 3, 1, 4, 6, 'major');

-- درج پیش‌نیازها
INSERT INTO Education.prerequisite (course_id, preq_id)
VALUES
('CS102', 'CS101'),
('MATH102', 'MATH101'),
('CS201', 'CS102'),
('CS301', 'CS201'),
('AI401', 'CS201'),
('IT401', 'CS101'),
('SEC401', 'CS101');

-- درج کلاس‌ها
INSERT INTO Education.classroom (building, room_number, capacity)
VALUES 
(N'ابوریحان', '101', 50),
(N'تالارها', 'A1', 120),
(N'خوارزمی', '202', 40);

-- درج بازه‌های زمانی
INSERT INTO Education.time_slot (time_slot_id, day, start_time, end_time)
VALUES 
('TS1', N'شنبه', '08:00', '10:00'),
('TS2', N'یک‌شنبه', '10:00', '12:00'),
('TS3', N'دوشنبه', '13:00', '15:00'),
('TS4', N'سه‌شنبه', '08:00', '10:00');

SELECT * FROM Education.SECTION

-- درج بخش‌ها
INSERT INTO Education.section (course_id, sec_id, semester, year, building, room_number, time_slot_id)
VALUES 
('CS101', '1', N'پاییز', 2023, N'ابوریحان', '101', 'TS1'),
('CS102', '1', N'پاییز', 2024, N'ابوریحان', '101', 'TS2'),
('CS201', '1', N'پاییز', 2024, N'خوارزمی', '202', 'TS3'),
('AI401', '1', N'پاییز', 2024, N'تالارها', 'A1', 'TS4'),
('MATH101', '1', N'پاییز', 2023, N'تالارها', 'A1', 'TS1'),
('PHYS101', '1', N'پاییز', 2023, N'تالارها', 'A1', 'TS2'),
('MATH102', '1', N'بهار', 2024, N'تالارها', 'A1', 'TS1'),
('CS201', '2', N'تابستان', 2024, N'خوارزمی', '202', 'TS3');

-- درج داده‌ها در جدول takes
INSERT INTO Education.takes (student_id, course_id, sec_id, semester, year, grade)
VALUES
(40234473, 'CS101', '1', N'پاییز', 2023, 17.5),
(40234473, 'MATH101', '1', N'پاییز', 2023, 16.0),
(40234473, 'PHYS101', '1', N'پاییز', 2023, 15.0),
(40234473, 'CS102', '1', N'پاییز', 2024, 18.0),
(40234473, 'MATH102', '1', N'بهار', 2024, 17.5),
(40234473, 'CS201', '2', N'تابستان', 2024, 16.0),
(40225689, 'CS101', '1', N'پاییز', 2023, 9.0); -- نمره زیر 10 برای تست


-- درج داده‌ها در جدول teaches
INSERT INTO Education.teaches (instructor_id, course_id, sec_id, semester, year)
VALUES 
(1, 'CS101', '1', N'پاییز', 2023),
(1, 'CS102', '1', N'پاییز', 2024),
(2, 'MATH101', '1', N'پاییز', 2023),
(3, 'PHYS101', '1', N'پاییز', 2023);

-- درج داده‌ها در جدول employee
INSERT INTO Education.employee (national_id, role, salary)
VALUES 
(1284725286, N'مدیر آموزش', 18000000),
(1000000044, N'کارشناس آموزش', 12500000);
