set serveroutput on;

start proj2_tables;

create or replace package pack1 as
  procedure show_students;
  procedure show_logs;
  procedure show_courses;
  procedure show_classes;
  procedure show_enrollments;
  procedure show_prerequisites;
  procedure add_student(
    input_sid in students.sid%type,
    fname in students.firstname%type,
    lname in students.lastname%type,
    st in students.status%type,
    gp in students.gpa%type,
    em in students.email%type);
  procedure display_enrolled_classes(input_sid in students.sid%type);
  procedure find_all_prereq(dc in courses.dept_code%type,cn in courses.course_no%type);
  procedure show_all_enrolled(cid in classes.classid%type);
  procedure drop_student(stid in students.sid%type, clid in classes.classid%type);
  procedure enroll_student(studentid in students.sid%type, cid in classes.classid%type);
  procedure delete_student(stid in students.sid%type);
end;
/
show errors
