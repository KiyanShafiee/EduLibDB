-- print(library.is_item_available(21,'book'))
-- print( library.get_user_total_unpaid_fines(1))

-- select * from library.get_top_3_most_borrowed_book_category()

-- select * from library.get_top_3_most_borrowed_magazines_category()



select * from func_suggest_book(1)


INSERT INTO library.borrowings (user_id, item_id, item_type, borrow_date, due_time, return_date, status)
VALUES 
(5, 7, 'book', '2024-02-14', '2024-02-24', '2024-01-24', 'returnd'),
(1, 10, 'book', '2025-02-14', '2025-02-24', '2025-01-24', 'returnd');



SELECT * FROM Education.fn_suggest_courses(40225689)

SELECT * FROM Education.fn_suggest_courses(40234473); -- شماره دانشجویی را تغییر بده

