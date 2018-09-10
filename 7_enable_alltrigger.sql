--禁用触发器和启用触发器
declare
  v_sql        varchar2(100);
  v_table_name varchar2(100);
  v_ref        sys_refcursor;
begin
  for v_ref in (select object_name
                  from user_objects
                 where object_type = 'TRIGGER') loop
    v_sql := 'alter trigger ' || v_ref.object_name || ' enable';  --将disable改为enable为启用
  
    execute immediate v_sql;
    dbms_output.put_line(v_sql);
  end loop;

exception
  when others then
    dbms_output.put_line(SQLCODE || ' ' || SQLERRM);
end;
/