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

create or replace trigger trig10_1
  before insert on students
    for each row
    declare
      user_name varchar2(10);
    begin
      select user into user_name from dual;
      insert into logs values(0,user_name,SYSTIMESTAMP,'students','insert',:new.sid);
    end;
/
show errors
-- need to get it to print the logid being 7 characters long -- issue resolved with lpad */



create or replace trigger trig4
  before delete on students
  for each row
  begin
    delete from enrollments where sid = :old.sid;
  end;
/
show errors
