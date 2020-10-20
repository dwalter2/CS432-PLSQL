create or replace package body pack2 as
function show_students
  return ref_cursor as rc ref_cursor;
  begin
    open rc for select * from students;
    return rc;
  end;
function show_courses
  return ref_cursor as rc ref_cursor;
  begin
    open rc for select * from courses;
    return rc;
  end;

function show_prerequisites
  return ref_cursor as rc ref_cursor;
  begin
    open rc for select * from prerequisites;
    return rc;
  end;
function show_classes
  return ref_cursor as rc ref_cursor;
  begin
    open rc for select * from classes;
    return rc;
  end;

function show_enrollments
  return ref_cursor as rc ref_cursor;
  begin
    open rc for select * from enrollments;
    return rc;
  end;
function show_logs
  return ref_cursor as rc ref_cursor;
  begin
    open rc for select lpad(logid, 7, '0') logid,who,time,table_name,operation,key_value from logs;
    return rc;
  end;

function add_student(
  input_sid in students.sid%type,
  fname in students.firstname%type,
  lname in students.lastname%type,
  st in students.status%type,
  gp in students.gpa%type,
  em in students.email%type)
  return number as ret_val number(1);
  begin
  declare
    cursor c1 is select * from students where sid = input_sid;
    c1_rec c1%rowtype;
    begin
    if(not c1%isopen) then
      open c1;
    end if;
    fetch c1 into c1_rec;
    if(c1%notfound) then
    insert into students values(input_sid,fname,lname,st,gp,em);
    ret_val := 1;
    else
    ret_val := 0;
    end if;
    return ret_val;
  end;
end;


function display_enrolled_classes(input_sid in students.sid%type) return number as ret_val number(1);
  begin
  declare
    cursor c1 is select sid,firstname,lastname,status from students where sid = input_sid;
    c1_rec c1%rowtype;
    cursor c2 is select classid,dept_code,course_no,title from courses natural join classes where classid in (
      select classid from enrollments where sid = input_sid);
    c2_rec c2%rowtype;
    begin
    if(not c2%isopen) then
      open c2;
    end if;
    fetch c2 into c2_rec;
    if(not c1%isopen) then
      open c1;
    end if;
    fetch c1 into c1_rec;
    if(c1%notfound) then
      ret_val := 0;
      dbms_output.put_line('The SID is invalid.');
    elsif(c2%notfound) then
      dbms_output.put_line(c1_rec.sid || ' ' || c1_rec.firstname || ' ' || c1_rec.lastname || ' ' || c1_rec.status);
      dbms_output.put_line('The student has not taken any course');
      ret_val := 1;
    else
      ret_val := 2;
      dbms_output.put_line(c1_rec.sid || ' ' || c1_rec.firstname || ' ' || c1_rec.lastname || ' ' || c1_rec.status);
      while c2%found loop
        dbms_output.put_line(c2_rec.classid || ' ' || c2_rec.dept_code || ' ' || c2_rec.course_no || ' ' || c2_rec.title);
        fetch c2 into c2_rec;
      end loop;
    end if;
      close c2;
      close c1;
      return ret_val;
    end;
  end;

procedure find_all_prereq(dc in courses.dept_code%type,cn in courses.course_no%type) is
  begin
  declare
    cursor c1 is select pre_dept_code,pre_course_no from prerequisites where dept_code = dc and course_no = cn;
    c1_rec c1%rowtype;
  begin
    if(not c1%isopen) then
      open c1;
    end if;
    fetch c1 into c1_rec;
    if c1%found then
      dbms_output.put_line(c1_rec.pre_dept_code || c1_rec.pre_course_no);
    end if;
    while c1%found loop
      find_all_prereq(c1_rec.pre_dept_code,c1_rec.pre_course_no);
      fetch c1 into c1_rec;
    end loop;
  end;
end;

procedure show_all_enrolled(cid in classes.classid%type) is
  begin
  declare
    cursor c1 is select classid,title,semester,year from classes natural join courses where cid = classid;
    c1_rec c1%rowtype;
    cursor c2 is select sid,firstname,lastname from students where sid in(
      select sid from enrollments where classid = cid
    );
    c2_rec c2%rowtype;
    begin
    if(not c2%isopen) then
      open c2;
    end if;
    if(not c1%isopen) then
      open c1;
    end if;
    fetch c1 into c1_rec;
    fetch c2 into c2_rec;
    if c1%notfound then
      dbms_output.put_line('The classid is invalid.');
    elsif c2%notfound then
      dbms_output.put_line(c1_rec.classid || ' ' || c1_rec.title || ' ' || c1_rec.semester || ' ' ||c1_rec.year);
      dbms_output.put_line('No student is enrolled in the class');
    else
      dbms_output.put_line(c1_rec.classid || ' ' || c1_rec.title || ' ' || c1_rec.semester || ' ' ||c1_rec.year);
      while c2%found loop
        dbms_output.put_line(c2_rec.sid || ' ' || c2_rec.firstname || ' ' || c2_rec.lastname);
        fetch c2 into c2_rec;
      end loop;
    end if;
  end;
end;

procedure enroll_student(studentid in students.sid%type, cid in classes.classid%type) is
  begin
  declare
    prereq_taken_count number(2);
    prereq_total_count number(2);
    class_count number(2);
    class_year classes.year%type;
    class_semester classes.semester%type;
    class_dc classes.dept_code%type;
    class_cn classes.course_no%type;
    cursor c1 is select sid from students where sid = studentid;
    c1_rec c1%rowtype;
    cursor c2 is select classid,limit,class_size from classes where classid = cid;
    c2_rec c2%rowtype;
    cursor c3 is select classid from classes where classid = cid and classid in (
      select classid from enrollments where sid = studentid
    );
    c3_rec c3%rowtype;
    cursor c4 is select * from enrollments where sid = studentid and classid in (
      select classid from classes where classid = cid
    );
    c4_rec c4%rowtype;
    begin
    select year,semester,dept_code,course_no into class_year,class_semester,class_dc,class_cn from classes where classid = cid;
    select count(*) into class_count from enrollments where sid = studentid and classid in (
      select classid from classes where year = class_year and semester = class_semester
    );
    select count(*) into prereq_taken_count from classes where classid in (
      select classid from enrollments where sid = studentid and lgrade = 'A' or lgrade = 'B' or lgrade = 'C'
    ) and (dept_code,course_no) in (
      select pre_dept_code,pre_course_no from prerequisites where dept_code = class_dc and course_no = class_cn);
    select count(*) into prereq_total_count from prerequisites where dept_code = class_dc and course_no = class_cn;
    if(not c1%isopen) then
      open c1;
    end if;
    if(not c2%isopen) then
      open c2;
    end if;
    if(not c3%isopen) then
      open c3;
    end if;
    fetch c1 into c1_rec;
    fetch c2 into c2_rec;
    fetch c3 into c3_rec;
    if c1%notfound then
      dbms_output.put_line('sid not found');
    elsif c2%notfound then
      dbms_output.put_line('The classid in invalid');
    elsif c2_rec.limit = c2_rec.class_size then
      dbms_output.put_line('The class is full');
    elsif c3%found then
      dbms_output.put_line('The student is already enrolled in this class');
    elsif class_count > 2 then
      dbms_output.put_line('You are overloaded');
    elsif prereq_taken_count != prereq_total_count then
      dbms_output.put_line('Prerequisite courses have not been completed');
    else
      insert into enrollments values(studentid,cid,'I');
      dbms_output.put_line('Student successfully enrolled');
    end if;
  end;
end;

procedure drop_student(stid in students.sid%type, clid in classes.classid%type) is
  begin
  declare
    num_students number(3);
    num_classes number(1);
    cnum courses.course_no%type;
    dc courses.dept_code%type;
    cnum2 courses.course_no%type;
    dc2 courses.dept_code%type;
    cursor c1 is select * from students where stid = sid;
    c1_rec c1%rowtype;
    cursor c2 is select * from classes where classid = clid;
    c2_rec c2%rowtype;
    cursor c3 is select * from enrollments where sid = stid and classid = clid;
    c3_rec c3%rowtype;
    cursor c4 is select * from enrollments where sid = stid and classid in (select classid from classes where (dept_code,course_no) in (select dept_code,course_no from prerequisites where (pre_dept_code,pre_course_no) in (select dept_code,course_no from courses where (dept_code,course_no) in (select dept_code,course_no from classes where classid = clid))));
    c4_rec c4%rowtype;
    begin
      if(not c1%isopen) then
        open c1;
      end if;
      if(not c2%isopen) then
        open c2;
      end if;
      if(not c3%isopen) then
        open c3;
      end if;
      if(not c4%isopen) then
        open c4;
      end if;
      fetch c1 into c1_rec;
      fetch c2 into c2_rec;
      fetch c3 into c3_rec;
      fetch c4 into c4_rec;
      if (c1%notfound) then
        dbms_output.put_line('sid not found.');
      elsif (c2%notfound) then
        dbms_output.put_line('classid not found.');
      elsif (c4%found) then
        dbms_output.put_line('The drop is not permitted because another class uses it as a prerequisite.');
      else
        select course_no,dept_code into cnum,dc from classes where classid = clid;
        select count(*) into num_classes from enrollments where sid = stid and classid != clid;
        select class_size into num_students from classes where classid = clid;
        if (num_classes = 0) then
          dbms_output.put_line('The student is enrolled in no class.');
        end if;
        if (num_students - 1 = 0) then
          dbms_output.put_line('The class now has no students.');
        end if;
        delete from enrollments where sid = stid and classid = clid;
      end if;
    end;
  end;
procedure delete_student(stid in students.sid%type) is begin
  declare
  cursor c1 is select * from students where sid = stid;
  c1_rec c1%rowtype;
  begin
    if(not c1%isopen) then
      open c1;
    end if;
    fetch c1 into c1_rec;
    if (c1%notfound) then
      dbms_output.put_line('sid is invalid.');
    else
      --delete from enrollments where sid = stid;
      delete from students where sid = stid;
    end if;
  end;
end;
end;
/
show errors
