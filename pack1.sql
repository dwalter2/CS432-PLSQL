start proj2_tables;

create or replace trigger trig1
  after insert on logs
  declare
    cursor c1 is select lpad(logid, 7, '0') logid from logs;
    c1_rec c1%rowtype;
  begin
    if(not c1%isopen) then
      open c1;
    end if;
    fetch c1  into c1_rec;
    while c1%found loop
      dbms_output.put_line(c1_rec.logid);
      fetch c1 into c1_rec;
    end loop;
    close c1;
  end;
/
/* need to get it to print the logid being 7 characters long -- issue resolved with lpad */
insert into logs values(0111,'tim',date '1998-01-01','some','add','something');

create or replace procedure show_students
as begin
  declare
    cursor c2 is select sid,firstname,lastname,status,gpa,email from students;
    c2_rec c2%rowtype;
  begin
    if(not c2%isopen) then
      open c2;
    end if;
    fetch c2 into c2_rec;
    dbms_output.put_line('sid firstname lastname status gpa email');
    while c2%found loop
      dbms_output.put_line(c2_rec.sid || ' ' || c2_rec.firstname || ' ' || c2_rec.lastname || ' ' || c2_rec.status ||' ' || c2_rec.gpa || ' ' || c2_rec.email);
      fetch c2 into c2_rec;
    end loop;
    close c2;
  end;
end;
/
insert into students values('B001','tom','tim','freshman',3.9,'tim@binghampton.edu');
insert into students values('B002','tim','tom','freshman',3.9,'tom@binghampton.edu');

exec show_students;

create or replace procedure show_courses
as begin
  declare
    cursor c2 is select * from courses;
    c2_rec c2%rowtype;
  begin
    if(not c2%isopen) then
      open c2;
    end if;
    fetch c2 into c2_rec;
    while c2%found loop
      dbms_output.put_line(c2_rec.dept_code || ' ' || c2_rec.course_no || ' ' || c2_rec.title);
      fetch c2 into c2_rec;
    end loop;
    close c2;
  end;
end;
/

insert into courses values('CS',432,'Database Systems');
insert into courses values('MATH',327,'Prob Stats');

exec show_courses;

create or replace procedure show_prerequisites
as begin
  declare
    cursor c2 is select * from prerequisites;
    c2_rec c2%rowtype;
  begin
    if(not c2%isopen) then
      open c2;
    end if;
    fetch c2 into c2_rec;
    while c2%found loop
      dbms_output.put_line(c2_rec.dept_code || ' ' || c2_rec.course_no || ' ' || c2_rec.pre_dept_code || ' ' || c2_rec.pre_course_no);
      fetch c2 into c2_rec;
    end loop;
    close c2;
  end;
end;
/

insert into prerequisites values('CS',432,'MATH',327);

exec show_prerequisites;

create or replace procedure show_classes
as begin
  declare
    cursor c2 is select * from classes;
    c2_rec c2%rowtype;
  begin
    if(not c2%isopen) then
      open c2;
    end if;
    fetch c2 into c2_rec;
    while c2%found loop
      dbms_output.put_line(c2_rec.classid || ' ' || c2_rec.dept_code || ' ' || c2_rec.course_no || ' ' || c2_rec.sect_no || ' ' || c2_rec.year || ' ' || c2_rec.semester || ' ' || c2_rec.limit || ' ' || c2_rec.class_size);
      fetch c2 into c2_rec;
    end loop;
    close c2;
  end;
end;
/

insert into classes values('c0001','CS',432,01,2020,'Fall',100,99);

exec show_classes;

create or replace procedure show_enrollments
as begin
  declare
    cursor c2 is select * from enrollments;
    c2_rec c2%rowtype;
  begin
    if(not c2%isopen) then
      open c2;
    end if;
    fetch c2 into c2_rec;
    while c2%found loop
      dbms_output.put_line(c2_rec.sid || ' ' || c2_rec.classid || ' ' || c2_rec.lgrade);
      fetch c2 into c2_rec;
    end loop;
    close c2;
  end;
end;
/

insert into enrollments values('B001', 'c0001', 'A');

exec show_enrollments;

create or replace procedure show_logs
as begin
  declare
    cursor c2 is select * from logs;
    c2_rec c2%rowtype;
  begin
    if(not c2%isopen) then
      open c2;
    end if;
    fetch c2 into c2_rec;
    while c2%found loop
      dbms_output.put_line(c2_rec.logid || ' ' || c2_rec.who || ' ' || c2_rec.time || ' ' || c2_rec.table_name || ' ' || c2_rec.operation || ' ' || c2_rec.key_value);
      fetch c2 into c2_rec;
    end loop;
    close c2;
  end;
end;
/

exec show_logs;

create or replace procedure add_student(
  input_sid in students.sid%type,
  fname in students.firstname%type,
  lname in students.lastname%type,
  st in students.status%type,
  gp in students.gpa%type,
  em in students.email%type) is
begin
  begin
  insert into students values(input_sid,fname,lname,st,gp,em);
  end;
end;
/

exec add_student('B004','tod','toad','senior',3.1,'tt@bing.edu');

exec show_students;

create or replace procedure display_enrolled_classes(input_sid in students.sid%type) is
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
      dbms_output.put_line('The SID is invalid.');
    elsif(c2%notfound) then
      dbms_output.put_line(c1_rec.sid || ' ' || c1_rec.firstname || ' ' || c1_rec.lastname || ' ' || c1_rec.status);
      dbms_output.put_line('The student has not taken any course');
    else
      dbms_output.put_line(c1_rec.sid || ' ' || c1_rec.firstname || ' ' || c1_rec.lastname || ' ' || c1_rec.status);
      while c2%found loop
        dbms_output.put_line(c2_rec.classid || ' ' || c2_rec.dept_code || ' ' || c2_rec.course_no || ' ' || c2_rec.title);
        fetch c2 into c2_rec;
      end loop;
    end if;
      close c2;
      close c1;
    end;
  end;
/
exec display_enrolled_classes('B001');
exec display_enrolled_classes('B002');
exec display_enrolled_classes('B003');

create or replace procedure find_all_prereq(dc in courses.dept_code%type,cn in courses.course_no%type) is
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
/
show errors

insert into courses values('MATH',314,'Discrete');
insert into prerequisites values('MATH',327,'MATH',314);

exec find_all_prereq('CS',432);

create or replace procedure show_all_enrolled(cid in classes.classid%type) is
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
/

insert into enrollments values('B002','c0001','B');

exec show_all_enrolled('c0001');
exec show_all_enrolled('c0003');
insert into courses values('CS',240,'Data Structures');
insert into classes values('c0003','CS',240,01,2020,'Fall',100,99);
exec show_all_enrolled('c0003');

create or replace procedure enroll_student(studentid in students.sid%type, cid in classes.classid%type) is
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
/

/*create or replace trigger trig2
  before insert on enrollments
  declare
    cursor c1 is select * from logs where time = max(time) and operation = 'insert' and table_name = 'enrollments';
    c1_rec c1%rowtype;
  begin
    if(not c1%isopen) then
      open c1;
    end if;
    fetch c1 into c1_rec;
    if c1%found then
      update classes
        set class_size = class_size + 1
        where classid = c1_rec.key_value.classid;
    end if;
  end;
/
*/
insert into classes values('c0002','MATH',327,1,2020,'Fall',100,20);
insert into courses values('CS',101,'Ethics');
insert into classes values('c0004','CS',101,1,2020,'Fall',60,1);
insert into enrollments values('B004','c0004',null);
insert into enrollments values('B001','c0002','B');

create or replace procedure drop_student(stid in students.sid%type, clid in classes.classid%type) is
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
/
show errors

exec drop_student('B001','c0002');
exec drop_student('B009','c0001');
exec drop_student('B001','c0009');
exec drop_student('B004','c0004');

create or replace trigger trig3
  before delete on students
  declare
    referencing old as deletedrow;
  begin
      delete from enrollments where sid = deletedrow.sid;
  end;
/

show errors
create or replace procedure delete_student(stid in students.sid%type) is begin
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
      delete from students where sid = stid;
    end if;
  end;
end;
/
exec delete_student('B009');
insert into students values('B003','Princess','Peach','junior',2.2,'peachy@bing.edu');
exec delete_student('B003');
insert into enrollments values('B004','c0001','A');
/*exec show_students;
exec show_enrollments;

create or replace trigger trig4
  after insert or delete on
*/
