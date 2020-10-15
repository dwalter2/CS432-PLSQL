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
