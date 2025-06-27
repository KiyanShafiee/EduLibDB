delete from dbo.person
delete from Education.student
delete from Library.book_auhtor
delete from library.fines
DELETE from library.borrowings
delete from Library.books
DELETE from library.category
delete from Library.author
DELETE from Library.Issue_magasines


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
('Machine Learning', 6, '2022-11-05', 220000, 'available', 'English');

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
(1, 8, 'book', '2024-03-15', '2024-03-25', NULL, 'borrowd'),
(2, 9, 'book', '2024-02-10', '2024-02-20', NULL, 'borrowd'),
(3, 10, 'book', '2024-02-12', '2024-02-22', NULL, 'borrowd'),
(4, 11, 'book', '2024-02-14', '2024-02-24', NULL, 'borrowd');



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


INSERT INTO person (national_id, first_name, last_name, email, username, password_hash)
VALUES
(1274444608, 'Ali', 'Ahmadi', 'ali.ahmadi@test.com', 'ali.ahmadi', 'hashedpass1'),
(1274444675, 'Sara', 'Hosseini', 'sara.hosseini@test.com', 'sara.hosseini', 'hashedpass2'),
(1234896575, 'Reza', 'Mohammadi', 'reza.mohammadi@test.com', 'reza.mohammadi', 'hashedpass3'),
(1284725286, 'Maryam', 'Karimi', 'maryam.karimi@test.com', 'maryam.karimi', 'hashedpass4'),
(1141137399, 'Hossein', 'Safari', 'hossein.safari@test.com', 'hossein.safari', 'hashedpass5');



INSERT INTO Education.major (major_id, name)
VALUES (1, 'Software Engineering'), (2, 'Information Technology'), (3, 'Cybersecurity');

INSERT INTO Education.department (dept_name, building, budget)
VALUES
('CS', 'Computer and electric', 1000000),
('Math', 'Mathematics',900000),
('Physics', 'Physics', 1000000),
('General', 'General Studies', 5000000),
('Electrical', 'Electrical Engineering',2000000),
('IT', 'Information Technology',1000000),
('Security', 'Cybersecurity',1000000);


INSERT INTO Education.student (student_id, national_id, dept_name, major_id, advisor_id, tot_cred, education_status, current_term, level_id)
VALUES
(40234473, 1274444608, 'CS', 1, NULL, 20, 1, 6, 1),
(40225689, 1284725286, 'CS', 1, NULL, 50, 1, 4, 1),
(40258698, 1274444675, 'CS', 1, NULL, 80, 1, 7, 1);


INSERT INTO Education.special_package (package_id, name, major_id)
VALUES
(1, 'Artificial Intelligence Package', 1),
(2, 'Software Engineering Package', 1),
(3, 'IT Management Package', 2),
(4, 'Cybersecurity Package', 3);


INSERT INTO Education.course (course_id, title, dept_name, credits, suggested_term)
VALUES
('CS101', 'Introduction to Computer Science', 'CS', 3, 1),
('MATH101', 'Calculus I', 'Math', 3, 1),
('PHYS101', 'Physics I', 'Physics', 3, 1),
('ENG101', 'English I', 'General', 2, 1),
('ISLAM101', 'Islamic Studies I', 'General', 2, 1),

('CS102', 'Programming Fundamentals', 'CS', 3, 2),
('MATH102', 'Calculus II', 'Math', 3, 2),
('PHYS102', 'Physics II', 'Physics', 3, 2),
('ENG102', 'English II', 'General', 2, 2),
('ISLAM102', 'Islamic Studies II', 'General', 2, 2),

('CS201', 'Data Structures', 'CS', 3, 3),
('MATH201', 'Discrete Mathematics', 'Math', 3, 3),
('ELEC101', 'Electrical Circuits', 'Electrical', 3, 3),
('GEN101', 'General Psychology', 'General', 2, 3),

('CS202', 'Algorithms', 'CS', 3, 4),
('MATH202', 'Linear Algebra', 'Math', 3, 4),
('CS203', 'Computer Organization', 'CS', 3, 4),
('ELEC102', 'Digital Logic Design', 'Electrical', 3, 4),
('GEN102', 'Critical Thinking', 'General', 2, 4),

('CS301', 'Operating Systems', 'CS', 3, 5),
('CS302', 'Database Systems', 'CS', 3, 5),
('CS303', 'Software Engineering Principles', 'CS', 3, 5),
('NET301', 'Computer Networks', 'CS', 3, 5),
('GEN103', 'Entrepreneurship', 'General', 2, 5);


INSERT INTO Education.degree_level (level_id, name)
VALUES
(1, 'karshenasi');

DECLARE @major INT = 1;
WHILE @major <= 3
BEGIN
  INSERT INTO Education.course_plan (course_id, major_id, level_id, package_id, suggested_term, type)
  SELECT course_id, @major, 1, NULL, suggested_term, 'base'
  FROM Education.course
  WHERE suggested_term BETWEEN 1 AND 5;
  SET @major = @major + 1;
END;


INSERT INTO Education.prerequisite (course_id, preq_id)
VALUES
('CS102', 'CS101'),
('MATH102', 'MATH101'),
('PHYS102', 'PHYS101'),
('CS201', 'CS102'),
('CS202', 'CS201'),
('CS203', 'CS102'),
('CS301', 'CS202'),
('CS302', 'CS201'),
('CS303', 'CS202');

INSERT INTO Education.corequisite (course_id, coreq_id)
VALUES
('PHYS102', 'MATH102');


-- نرم افزار
INSERT INTO Education.course (course_id, title, dept_name, credits, suggested_term)
VALUES
('CS401', 'Advanced Software Engineering', 'CS', 3, 6),
('CS402', 'Software Project Management', 'CS', 3, 6),
('CS403', 'Software Testing and QA', 'CS', 3, 7),
('CS404', 'Software Architecture', 'CS', 3, 7),
('CS405', 'Software Deployment', 'CS', 3, 8),
('CS406', 'Software Security', 'CS', 3, 8);

-- سیستم های هوشمند
INSERT INTO Education.course (course_id, title, dept_name, credits, suggested_term)
VALUES
('AI401', 'Introduction to AI', 'CS', 3, 6),
('AI402', 'Machine Learning', 'CS', 3, 6),
('AI403', 'Deep Learning', 'CS', 3, 7),
('AI404', 'Computer Vision', 'CS', 3, 7),
('AI405', 'Natural Language Processing', 'CS', 3, 8),
('AI406', 'AI Ethics and Society', 'CS', 3, 8);

-- فناوری اطلاعات
INSERT INTO Education.course (course_id, title, dept_name, credits, suggested_term)
VALUES
('IT401', 'IT Infrastructure', 'IT', 3, 6),
('IT402', 'Network Administration', 'IT', 3, 6),
('IT403', 'Cloud Computing', 'IT', 3, 7),
('IT404', 'IT Service Management', 'IT', 3, 7),
('IT405', 'Enterprise Systems', 'IT', 3, 8),
('IT406', 'IT Security Management', 'IT', 3, 8);

-- رایانش امن
INSERT INTO Education.course (course_id, title, dept_name, credits, suggested_term)
VALUES
('SEC401', 'Introduction to Cybersecurity', 'Security', 3, 6),
('SEC402', 'Network Security', 'Security', 3, 6),
('SEC403', 'Cryptography', 'Security', 3, 7),
('SEC404', 'Ethical Hacking', 'Security', 3, 7),
('SEC405', 'Digital Forensics', 'Security', 3, 8),
('SEC406', 'Secure Software Development', 'Security', 3, 8);

INSERT INTO Education.prerequisite (course_id, preq_id)
VALUES
('CS401', 'CS303'),
('CS402', 'CS401'),
('CS403', 'CS402'),
('CS404', 'CS403'),
('CS405', 'CS404'),
('CS406', 'CS405'),

('AI401', 'CS202'),
('AI402', 'AI401'),
('AI403', 'AI402'),
('AI404', 'AI402'),
('AI405', 'AI403'),
('AI406', 'AI405'),

('IT401', 'CS203'),
('IT402', 'IT401'),
('IT403', 'IT402'),
('IT404', 'IT402'),
('IT405', 'IT403'),
('IT406', 'IT405'),

('SEC401', 'CS203'),
('SEC402', 'SEC401'),
('SEC403', 'SEC402'),
('SEC404', 'SEC403'),
('SEC405', 'SEC404'),
('SEC406', 'SEC405');

-- نرم افزار
INSERT INTO Education.course_plan (course_id, major_id, level_id, package_id, suggested_term, type)
VALUES
('CS401', 1, 1, 2, 6, 'major'),
('CS402', 1, 1, 2, 6, 'major'),
('CS403', 1, 1, 2, 7, 'major'),
('CS404', 1, 1, 2, 7, 'major'),
('CS405', 1, 1, 2, 8, 'major'),
('CS406', 1, 1, 2, 8, 'major');

-- سیستم های هوشمند
INSERT INTO Education.course_plan (course_id, major_id, level_id, package_id, suggested_term, type)
VALUES
('AI401', 1, 1, 1, 6, 'major'),
('AI402', 1, 1, 1, 6, 'major'),
('AI403', 1, 1, 1, 7, 'major'),
('AI404', 1, 1, 1, 7, 'major'),
('AI405', 1, 1, 1, 8, 'major'),
('AI406', 1, 1, 1, 8, 'major');

-- فناوری اطلاعات
INSERT INTO Education.course_plan (course_id, major_id, level_id, package_id, suggested_term, type)
VALUES
('IT401', 2, 1, 3, 6, 'major'),
('IT402', 2, 1, 3, 6, 'major'),
('IT403', 2, 1, 3, 7, 'major'),
('IT404', 2, 1, 3, 7, 'major'),
('IT405', 2, 1, 3, 8, 'major'),
('IT406', 2, 1, 3, 8, 'major');

-- رایانش امن
INSERT INTO Education.course_plan (course_id, major_id, level_id, package_id, suggested_term, type)
VALUES
('SEC401', 3, 1, 4, 6, 'major'),
('SEC402', 3, 1, 4, 6, 'major'),
('SEC403', 3, 1, 4, 7, 'major'),
('SEC404', 3, 1, 4, 7, 'major'),
('SEC405', 3, 1, 4, 8, 'major'),
('SEC406', 3, 1, 4, 8, 'major');




INSERT INTO Education.takes (student_id, course_id, grade)
VALUES
(40234473, 101, 14), -- Programming Fundamentals
(40234473, 102, 16), -- Advanced Programming
(40234473, 103, 13), -- Discrete Mathematics
(40234473, 104, 12), -- Data Structures
(40234473, 105, 18); -- Computer Organization
