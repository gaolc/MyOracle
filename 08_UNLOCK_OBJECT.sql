declare 
v_sql varchar(50);
v_sid varchar(20);
v_ref sys_refcursor;
begin 
for v_ref in (select distinct  ''''||t2.sid ||','|| t2.serial# ||'''' as v_sid from v$locked_object t1,v$session t2 where t1.session_id=t2.sid ) loop
 v_sql := 'ALTER SYSTEM KILL SESSION ' || v_ref.v_sid ;
     execute immediate v_sql;
    dbms_output.put_line(v_sql);
  end loop;
exception
  when others then
    dbms_output.put_line(SQLCODE || ' ' || SQLERRM);  
end;
/  


