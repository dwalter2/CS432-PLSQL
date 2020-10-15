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
