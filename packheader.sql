set serveroutput on;

start proj2_tables;

create or replace package pack2 as
  type ref_cursor is ref cursor;
  function show_students return ref_cursor;
  function show_logs return ref_cursor;
  function show_courses return ref_cursor;
  function show_classes return ref_cursor;
  function show_enrollments return ref_cursor;
  function show_prerequisites return ref_cursor;
  function add_student(
    input_sid in students.sid%type,
    fname in students.firstname%type,
    lname in students.lastname%type,
    st in students.status%type,
    gp in students.gpa%type,
    em in students.email%type) return number;
  function display_enrolled_classes(input_sid in students.sid%type) return number;
  procedure find_all_prereq(dc in courses.dept_code%type,cn in courses.course_no%type);
  procedure show_all_enrolled(cid in classes.classid%type);
  procedure drop_student(stid in students.sid%type, clid in classes.classid%type);
  procedure enroll_student(studentid in students.sid%type, cid in classes.classid%type);
  procedure delete_student(stid in students.sid%type);
end;
/
show errors
