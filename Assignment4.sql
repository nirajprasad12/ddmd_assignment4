/*
A. CREATE DEPT TABLE AND INSERT 6 RECORDS INTO IT (refer to Instructions for Schema) - 6 points

B. INSERT THE DEPARTMENT IF NAME DOESN'T EXISTS - 6 points

C. UPDATE THE DEPARTMENT LOCATION IF NAME EXISTS - 6 points

D. RAISE ERROR IF THE DEPARTMENT NAME IS INVALID (NULL, ZERO LENGTH) - 6 points

E. RAISE ERROR IF THE DEPARTMENT NAME IS A NUMBER - 6 points

F. ACCEPTED LOCATIONS SHOULD BE AS BELOW - 6 points

                MA, TX, IL, CA, NY, NJ, NH, RH

G. DEPARTMENT ID SHOULD BE AUTO-GENERATED - 6 points

H. LENGTH OF THE DEPARTMENT NAME CANNOT BE MORE THAN 20 CHARS - 6 points

I. WHILE INSERTING THE DEPARTMENT NAME CONVERT EVERYTHING TO CAMEL CASE - 6 points

J. MAKE SURE DEPARTMENT NAME IS UNIQUE - 6 points

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
v_cnt number;
begin
    execute immediate('insert into department(dept_name, dept_location) values(initcap('''|| in_dept_name ||'''),upper('''|| in_dept_location ||''') )');
    dbms_output.put_line('Running stored proc');
end;
/


exec insert_department('K', 'L')






