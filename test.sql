-- print(library.is_item_available(21,'book'))
-- print( library.get_user_total_unpaid_fines(1))

-- select * from library.get_top_3_most_borrowed_book_category()

-- select * from library.get_top_3_most_borrowed_magazines_category()

-- select * from func_suggest_book(1);

-- --error
-- exec library.create_lib_user 1000000011

-- --new person
-- insert into person (national_id,first_name,last_name,email,username,password_hash)
-- VALUES
-- (1000000060,'alireza','roholahi','gmilvp,','fjksldf','fklsdjflsdfjksl');

-- exec library.create_lib_user 1000000060

-- SELECT * from Library.Issue_magasines

exec library.borrrow_item 13,'book',2 

-- select * from library.borrowings 

-- exec library.reserve_item 3 ,'magazine',3,'2025-07-03'
-- select * from Library.reservation

-- exec library.poc_calculate_fine
-- select * from library.fines



/********************************************************/
/* ********* تست توابع ********* */

SELECT * FROM Education.fn_suggest_courses(40225689)

-- SELECT * FROM Education.fn_suggest_courses(40234473); -- شماره دانشجویی را تغییر بده



/* تست fn_calculate_gpa */
SELECT Education.fn_calculate_gpa(40234473) AS gpa;
-- نتیجه مورد انتظار: میانگین نمرات دانشجوی 40234473 (17.5 + 16 + 15 + 18 + 17.5 + 16) / 6 = 16.6667

SELECT Education.fn_calculate_gpa(40225689) AS gpa;
-- 9

/* تست fn_count_students_by_dept */
SELECT Education.fn_count_students_by_dept(N'CS') AS student_count;
-- نتیجه مورد انتظار: 2 (دو دانشجو در دپارتمان CS)

SELECT Education.fn_count_students_by_dept(N'IT') AS student_count;
-- نتیجه مورد انتظار: 1 (یک دانشجو در دپارتمان IT)

SELECT Education.fn_count_students_by_dept(N'Security') AS student_count;
-- نتیجه مورد انتظار: 1 (یک دانشجو در دپارتمان Security)

/* تست fn_has_passed */
SELECT Education.fn_has_passed(40234473, 'CS101') AS has_passed;
-- نتیجه مورد انتظار: 1 (دانشجو درس CS101 را با نمره 17.5 پاس کرده است)

SELECT Education.fn_has_passed(40225689, 'CS101') AS has_passed;
-- نتیجه مورد انتظار: 0 (دانشجو درس CS101 را با نمره 9 پاس نکرده است)

/* تست fn_student_term_status */
SELECT student_id, Education.fn_student_term_status(student_id) AS term_status
FROM Education.student;
-- نتایج مورد انتظار:
-- 40234473: 'student in term 1'
-- 40225689: 'graduate'
-- 40258698: 'dropout'
-- 40298765: 'expulsion'

/* تست fn_is_valid_national_id */
SELECT Education.fn_is_valid_national_id(1274444608) AS is_valid;
-- نتیجه مورد انتظار: 1 (کدملی معتبر فرض شده است)

SELECT Education.fn_is_valid_national_id(1111111111) AS is_valid;
-- نتیجه مورد انتظار: 0 (کدملی غیرمعتبر)

/* تست fn_suggest_courses */
SELECT * FROM Education.fn_suggest_courses(40234473);
-- نتیجه مورد انتظار: لیستی از دروس پیشنهادی برای دانشجوی 40234473 که:
-- - در major_id=1 و level_id=1 باشند
-- - دانشجو قبلاً پاس نکرده باشد
-- - مجموع واحدها تا 20 باشد (چون معدل بالای 12 است)
-- دروس پیشنهادی ممکن است شامل CS301 و AI401 باشد (بسته به ترم پیشنهادی و پیش‌نیازها)

/* ********* تست پروسیجرها ********* */

/* تست sp_register_student */
EXEC Education.sp_register_student @student_id = 40300000, @national_id = '1000000086', @dept_name = N'CS', @advisor_id = 1, @tot_cred = 0;
-- نتیجه مورد انتظار: درج دانشجوی جدید در جدول student و ثبت لاگ در جدول log
SELECT * FROM Education.student WHERE student_id = 40234473;
SELECT * FROM Education.log --WHERE table_name = N'student' AND operation_type = N'INSERT';

/* تست sp_change_advisor */
EXEC Education.sp_change_advisor @student_id = 40234473, @new_advisor_id = 2;
-- نتیجه مورد انتظار: تغییر advisor_id به 2 برای دانشجوی 40234473 و ثبت لاگ
SELECT * FROM Education.student WHERE student_id = 40234473;
SELECT * FROM Education.log WHERE table_name = N'student' AND operation_type = N'UPDATE';

/* تست sp_drop_course */
EXEC Education.sp_drop_course @student_id = 40234473, @course_id = 'CS101', @sec_id = '1', @semester = N'پاییز', @year = 2023;
-- نتیجه مورد انتظار: حذف درس CS101 از جدول takes و ثبت لاگ
SELECT * FROM Education.takes WHERE student_id = 40234473;
SELECT * FROM Education.log WHERE table_name = N'Education.takes' AND operation_type = N'DELETE';

/* ********* تست تریگرها ********* */

/* تست trg_log_insert_student (با اجرای sp_register_student تست می‌شود) */
-- نتیجه مورد انتظار: هنگام درج دانشجوی جدید، یک لاگ در جدول log ثبت می‌شود (در بالا تست شده)

/* تست trg_log_grade_update */
UPDATE Education.takes
SET grade = 18.5
WHERE student_id = 40234473 AND course_id = 'CS101' AND sec_id = '1' AND semester = N'پاییز' AND year = 2023;
-- نتیجه مورد انتظار: ثبت لاگ در جدول log برای به‌روزرسانی نمره
SELECT * FROM Education.log WHERE table_name = N'Education.takes' AND operation_type = N'UPDATE';

/* تست trg_delete_instructor_employee */
DELETE FROM Education.instructor WHERE instructor_id = 2;
-- نتیجه مورد انتظار: حذف استاد با instructor_id=2 از جدول instructor و حذف ردیف مربوطه از جدول employee
-- همچنین ثبت لاگ در جدول log
SELECT * FROM Education.instructor WHERE instructor_id = 2;
SELECT * FROM Education.employee WHERE national_id = 1298765432;
SELECT * FROM Education.log WHERE table_name = N'Education.instructor/employee' AND operation_type = N'DELETE';

/* تست trg_student_status_update */
UPDATE Education.student
SET education_status = 2
WHERE student_id = 40234473;
-- نتیجه مورد انتظار: ثبت لاگ در جدول log برای تغییر education_status
SELECT * FROM Education.log WHERE table_name = N'Library.account' AND operation_type = N'UPDATE';