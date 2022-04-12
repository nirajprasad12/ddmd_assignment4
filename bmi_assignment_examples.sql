--create table BMI (id number, month varchar(10), bmi_val varchar(20));
--drop table bmi;
insert into BMI values(1, 'January', 28.5);
insert into BMI values(2, 'February', 27.5);
insert into BMI values(3, 'March', 26.5);
insert into BMI values(4, 'April', 25.5);

select id, month, bmi_val, LEAD(bmi_val, 1, 'fool') over (order by ID) as next_bmi from BMI;


--print total rows in BMI table
set serveroutput on;

declare
v_cnt number;
begin
    select count(*) into v_cnt from BMI; 
    dbms_output.put_line('Count = '||v_cnt);
exception
    when no_data_found then dbms_output.put_line('sorry, no data has been found');
end;
/

declare 
   v_id number;
   v_month varchar(10);
   v_bmi_val varchar(20);
   cursor c_bmi is 
      select id, month, bmi_val from BMI; --EXPLICIT CURSOR
begin 
   open c_bmi; 
   loop 
   fetch c_bmi into v_id, v_month, v_bmi_val; 
      exit when c_bmi%notfound; --IMPLICIT CURSOR
      dbms_output.put_line(v_id || ' ' || v_month || ' ' || v_bmi_val); 
   end loop; 
   close c_bmi; 
end; 
/

/*
merge into department d_fin
    using (select dept_id, dept_name, dept_location FROM department where dept_name = '1h') d_sel
    on (d_fin.dept_id = d_sel.dept_id)
    when matched then update set d_fin.dept_location = 'IL' 
    delete where (d_sel.dept_location = 'MA')
    when not matched then insert (d_fin.dept_name, d_fin.dept_location) values ('1h','TX');
    
--insert into department(dept_name, dept_location) values ('1h', 'MA'); */