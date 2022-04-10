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
        execute immediate ('Department table created');
    else:
        dbms_output.put_line('Department table already exists');
    end if;
end;

















