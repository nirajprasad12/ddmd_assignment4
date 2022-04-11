/*
A. CREATE DEPT TABLE AND INSERT 6 RECORDS INTO IT (refer to Instructions for Schema) - 6 points DONE

B. INSERT THE DEPARTMENT IF NAME DOESN'T EXISTS - 6 points DONE

C. UPDATE THE DEPARTMENT LOCATION IF NAME EXISTS - 6 points DONE

D. RAISE ERROR IF THE DEPARTMENT NAME IS INVALID (NULL, ZERO LENGTH) - 6 points DONE

E. RAISE ERROR IF THE DEPARTMENT NAME IS A NUMBER - 6 points

F. ACCEPTED LOCATIONS SHOULD BE AS BELOW - 6 points DONE

                MA, TX, IL, CA, NY, NJ, NH, RH

G. DEPARTMENT ID SHOULD BE AUTO-GENERATED - 6 points DONE

H. LENGTH OF THE DEPARTMENT NAME CANNOT BE MORE THAN 20 CHARS - 6 points DONE

I. WHILE INSERTING THE DEPARTMENT NAME CONVERT EVERYTHING TO CAMEL CASE - 6 points DONE

J. MAKE SURE DEPARTMENT NAME IS UNIQUE - 6 points DONE

*/

set serveroutput on;

declare
v_cnt number;
begin
    select count(*) into v_cnt from user_tables where table_name = upper('department');
    if v_cnt = 0 then
        execute immediate ('CREATE TABLE DEPARTMENT(
                            dept_id number(5) NOT NULL PRIMARY KEY,
                            dept_name varchar(40) NOT NULL,
                            dept_location varchar(40) NOT NULL)');
        
        dbms_output.put_line('Department table created');
    else
        execute immediate ('drop table department');
        execute immediate ('CREATE TABLE DEPARTMENT(
                            dept_id number(5) NOT NULL PRIMARY KEY,
                            dept_name varchar(40) NOT NULL,
                            dept_location varchar(40) NOT NULL)');
        
        dbms_output.put_line('Department table already exists; dropped and created again');
    end if;
end;
/

declare
v_cnt number;
begin
    select count(*) into v_cnt from user_sequences where sequence_name = upper('auto_increment_x1');
    if v_cnt = 0 then
        execute immediate('CREATE SEQUENCE auto_increment_x1
                            MINVALUE 10000
                            MAXVALUE 99999
                            START WITH 10000
                            INCREMENT BY 1');
        dbms_output.put_line('Sequence has been created');
    else
        execute immediate('drop sequence auto_increment_x1');
        execute immediate('CREATE SEQUENCE auto_increment_x1
                            MINVALUE 10000
                            MAXVALUE 99999
                            START WITH 10000
                            INCREMENT BY 1');
        dbms_output.put_line('Sequence already exists; dropped and created again');
        
    end if;
    execute immediate('ALTER TABLE department MODIFY dept_id NUMBER DEFAULT auto_increment_x1.NEXTVAL');
    dbms_output.put_line('Table DEPARTMENT altered.');
end;
/


    

create or replace procedure insert_department(in_dept_name department.dept_name%TYPE, in_dept_location department.dept_location%TYPE)
is
v_NameExists number;
v_deptLength number;

queryCheck varchar(200);


e_input_length exception;
e_accepted_locations exception;
begin
    
    v_NameExists := 0;
    
    select length(in_dept_name) into v_deptLength from dual;
    
    if v_deptlength > 20 then
        raise e_input_length;
    end if;
    
    if upper(in_dept_location) not in ('MA', 'TX', 'IL', 'CA', 'NY', 'NJ', 'NH', 'RH') then
        raise e_accepted_locations;
    end if;
    
    select count(*) into v_NameExists from department where dept_name = initcap(in_dept_name);
    if v_NameExists = 0 then
        execute immediate('insert into department(dept_name, dept_location) values(initcap('''|| in_dept_name ||'''),upper('''|| in_dept_location ||''') )');
        
        dbms_output.put_line('New department inserted');
        commit;
    else
        execute immediate('update department set dept_location = upper(''' || in_dept_location || ''') where dept_name = initcap('''|| in_dept_name ||''')');
        dbms_output.put_line(queryCheck);
        dbms_output.put_line('Department already exists, it must be unique, updating the location only..');
        commit;
    end if;

exception
    when e_accepted_locations then
        dbms_output.put_line('Error: Allowed locations are MA, TX, IL, CA, NY, NJ, NH, RH');
    
    when e_input_length then
        dbms_output.put_line('Error: Allowed Max string length of 20 for Dept_Name');
        
    when others then   
        if sqlcode = -1400 then
            dbms_output.put_line('Do not enter NULL/Empty values!!');
        elsif sqlcode = -6550 then
            dbms_output.put_line('Enter correct number of argumentS!!');
        else
            dbms_output.put_line('Operation not performed!! Contact Admin!!');
        end if;
    rollback;
end;
/

exec insert_department('This is a long department', 'Nj');

select * from department;



