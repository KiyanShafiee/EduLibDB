﻿print(library.is_item_available(1,'book'))

print( library.get_user_total_unpaid_fines(1))

select * from library.get_top_3_most_borrowed_book_category()

select * from library.get_top_3_most_borrowed_magazines_category()

select * from func_suggest_book(1);
SELECT * from Library.borrowings

--error
exec library.create_lib_user 1000000011

--new person
insert into person (national_id,first_name,last_name,email,username,password_hash)
VALUES
(1000000060,'alireza','roholahi','gmilvp,','fjksldf','fklsdjflsdfjksl');

exec library.create_lib_user 1000000060
select * from Library.users

SELECT * from Library.Issue_magasines

exec library.borrrow_item 1,'magazine',2 

 select * from library.borrowings 

 exec library.reserve_item 1 ,'magazine',3,'2025-07-03'
select * from Library.reservation

exec library.poc_calculate_fine


select * from library.fines


SELECT * FROM Education.fn_suggest_courses(40225689)

SELECT * FROM Education.fn_suggest_courses(40298765); 



exec Education.register_course '40225689',MATH101,1,'پاییز',2023

select * from education.takes
