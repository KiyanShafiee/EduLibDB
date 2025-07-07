
CREATE ROLE Admin;
CREATE ROLE Librarian;
CREATE ROLE Student;

GRANT INSERT ON Education.student TO Admin;

GRANT INSERT, UPDATE ON library.borrowings TO Librarian;
GRANT INSERT, UPDATE ON library.fines TO Librarian;
GRANT INSERT, UPDATE ON library.reservation TO Librarian;

GRANT EXECUTE ON Education.fn_get_gpa TO Student;
GRANT EXECUTE ON Education.fn_total_credits TO Student;
GRANT EXECUTE ON Education.fn_current_term TO Student;

GRANT EXECUTE ON Education.register_course TO Student;

REVOKE INSERT, UPDATE, DELETE ON Education.takes FROM Student;



