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
