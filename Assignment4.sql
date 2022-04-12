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
        
        dbms_output.put_line('Department table has been already dropped and created again because it existed; ');
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
    --execute immediate('ALTER TABLE department MODIFY dept_name char(40)');
    dbms_output.put_line('Table DEPARTMENT altered.');
end;
/

create or replace procedure delete_rows_department is
begin
    execute immediate('delete from department');
    dbms_output.put_line('All rows deleted');
    commit;
exception
when others then rollback;
end;
/

create or replace procedure insert_department(in_dept_name department.dept_name%TYPE, in_dept_location department.dept_location%TYPE)
is
v_NameExists number;
v_deptLength number;
v_deptNameType number;

e_deptNameFormat exception;
e_input_length exception;
e_accepted_locations exception;
begin
    
    v_NameExists := 0;

    begin
        if length(in_dept_name) != 0 then
        select to_number(in_dept_name) into v_deptNameType from dual; 
        raise e_deptNameFormat;
        end if;
    exception
    when invalid_number then null;
    end;

    select length(in_dept_name) into v_deptLength from dual;
    if v_deptlength > 20 then
        raise e_input_length;
    end if;
    
    if upper(in_dept_location) not in ('MA', 'TX', 'IL', 'CA', 'NY', 'NJ', 'NH', 'RH') then
        raise e_accepted_locations;
    end if;
    
    select count(*) into v_NameExists from department where initcap(dept_name) = initcap(in_dept_name);
    if v_NameExists = 0 then
        execute immediate('insert into department(dept_name, dept_location) values(initcap('''|| in_dept_name ||'''),upper('''|| in_dept_location ||''') )');
        dbms_output.put_line('New department ' || initcap(in_dept_name)||' inserted');
        commit;
    else
        execute immediate('update department set dept_location = upper(''' || in_dept_location || ''') where dept_name = initcap('''|| in_dept_name ||''')');
        dbms_output.put_line('Department ' || initcap(in_dept_name)|| ' already exists, it must be unique, updating the location only..');
        commit;
    end if;

exception
    when e_accepted_locations then
        dbms_output.put_line('Error: Allowed locations are MA, TX, IL, CA, NY, NJ, NH, RH');
    
    when e_input_length then
        dbms_output.put_line('Error: Allowed Max string length of 20 for Dept_Name');
        
    when e_deptNameFormat then
        dbms_output.put_line('Error: Please do not enter just numbers as input!');
        
    when others then   
        if sqlcode = -1400 then
            dbms_output.put_line('Do not enter NULL/Empty values!!');
        elsif sqlcode = -6550 then
            dbms_output.put_line('Enter correct number of arguments!!');
        else
            dbms_output.put_line('Operation not performed!! Contact Admin!!');
        end if;
    rollback;
end;
/


--- TEST CASES ---

--Insert 6 good values when department does not exist
exec insert_department('Dept 1', 'MA');
exec insert_department('Dept 2', 'TX');
exec insert_department('Dept 3', 'IL');
exec insert_department('Dept 4', 'CA');
exec insert_department('Dept 5', 'NY');
exec insert_department('Dept 6', 'RH');
exec delete_rows_department();

--Insert 6 good values to show handling of camel case when department does not exist
exec insert_department('dept jack', 'ma');
exec insert_department('dept hEnry', 'tX');
exec insert_department('dept mark', 'Il');
exec insert_department('dePt scOtt', 'Ca');
exec insert_department('john doe', 'Ny');
exec insert_department('test cAse', 'rh');
exec delete_rows_department();

--Insert values to show handling of dept_name length > 20
exec insert_department('dept jack', 'ma');
exec insert_department('dept henry', 'tX');
exec insert_department('Department of External Affairs Ministry', 'tX');
exec delete_rows_department();

--Update location when department exists
exec insert_department('Dept 1', 'MA');
exec insert_department('Dept 2', 'TX');
exec insert_department('Dept 1', 'rh');
exec delete_rows_department();

-- Raise error if department name is invalid (NULL, ZERO LENGTH)
exec insert_department('', 'MA');
exec insert_department(null, 'MA');

-- Raise error if department name is a number
exec insert_department('98765', 'MA');
exec insert_department(98765, 'MA');

-- Accepted locations must only be (MA, TX, IL, CA, NY, NJ, NH, RH)
exec insert_department('Dept 4', 'ND');

-- Department name is unique. It updates location but does not allow inserting same department again.
exec insert_department('Dept 1', 'MA');
exec insert_department('Dept 1', 'TX');

select * from department;

--insert, update, delete

/*
merge into department d_fin
    using (select dept_id, dept_name, dept_location FROM department where dept_name = '1h') d_sel
    on (d_fin.dept_id = d_sel.dept_id)
    when matched then update set d_fin.dept_location = 'IL' 
    delete where (d_sel.dept_location = 'MA')
    when not matched then insert (d_fin.dept_name, d_fin.dept_location) values ('1h','TX');
    
--insert into department(dept_name, dept_location) values ('1h', 'MA'); */