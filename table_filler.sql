--student
insert into Students values('B001','Jake','Whit','senior',4.0,'jwhit@bing');
insert into Students values('B002','David','Walt','senior',4.0,'dwalt@bing');
insert into Students values('B003','Theresa','Gun','senior',2.0,'tgun@bing');

--courses
insert into courses values('CS',432,'Database Systems');
insert into courses values('CS',457,'Distributed Systems');
insert into courses values('MATH',330,'Number Systems');

--classes
insert into classes values('c0001','CS',432,1,2020,'Fall',100,40);
insert into classes values('c0002','CS',457,1,2020,'Fall',100,1);
insert into classes values('c0003','MATH',330,1,2020,'Fall',100,29);

--enrollments
insert into enrollments values('B001','c0003','A');
insert into enrollments values('B002','c0003','A');
insert into enrollments values('B003','c0003','C');
insert into enrollments values('B003','c0002','C');
insert into enrollments values('B002','c0002','A');
insert into enrollments values('B002','c0001','A');

--prereqs
insert into prerequisites values('CS',432,'CS',457);
insert into prerequisites values('CS',457,'MATH',330);

