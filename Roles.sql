-- ایجاد نقش‌ها
CREATE ROLE Admin;
CREATE ROLE Librarian;
CREATE ROLE Student;

-------------------------------------------------------------
-- نقش Admin: فقط اجازه افزودن دانشجو جدید در Education.student
GRANT INSERT ON Education.student TO Admin;

-------------------------------------------------------------
-- نقش Librarian: فقط اجازه ثبت و بازگرداندن کتاب در borrowing
GRANT INSERT, UPDATE ON library.borrowings TO Librarian;
GRANT INSERT, UPDATE ON library.fines TO Librarian;
GRANT INSERT, UPDATE ON library.reservation TO Librarian;

-------------------------------------------------------------
-- اعطای مجوز اجرای توابع به نقش Student
GRANT EXECUTE ON Education.fn_get_gpa TO Student;
GRANT EXECUTE ON Education.fn_total_credits TO Student;
GRANT EXECUTE ON Education.fn_current_term TO Student;

-------------------------------------------------------------
-- فقط انتخاب واحد از طریق پراسیجر مجاز است
-- مجوز اجرای پراسیجر به 
GRANT EXECUTE ON Education.register_course TO Student;

-- حذف دسترسی مستقیم به جدول takes از نقش Student
REVOKE INSERT, UPDATE, DELETE ON Education.takes FROM Student;



