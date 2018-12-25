--生成updae语句
declare
  v_table_name  varchar2(100) := 'PERSON_INFO';
  v_table_alias varchar2(10);
  cursor c_utc is
    select *
      from user_tab_cols utc
     where utc.table_name = v_table_name
       and utc.hidden_column = 'NO'
     order by utc.column_id asc;
  v_row_count number;
  v_row       c_utc%rowtype;
  v_length    number;
  v_alias     varchar2(4000) := '';
begin
  for i in 1 .. length(v_table_name) loop
    if (i = 1) then
      v_table_alias := lower(substr(v_table_name, 1, 1));
    elsif (substr(v_table_name, i - 1, 1) = '_') then
      v_table_alias := v_table_alias || lower(substr(v_table_name, i, 1));
    else
      continue;
    end if;
  end loop;
  select count(*)
    into v_row_count
    from user_tab_cols utc
   where utc.table_name = v_table_name
     and utc.hidden_column = 'NO';
  dbms_output.put_line('update ' || lower(v_table_name) || ' ' ||
                       v_table_alias || ' set ');
  open c_utc;
  loop
    fetch c_utc
      into v_row;
    exit when(c_utc%notfound);
    select length(v_row.column_name) into v_length from dual;
    v_alias := '';
    for i in 1 .. v_length loop
      if (substr(v_row.column_name, i, 1) = '_') then
        continue;
      elsif (substr(v_row.column_name, i - 1, 1) = '_') then
        v_alias := v_alias || substr(v_row.column_name, i, 1);
      else
        v_alias := v_alias || lower(substr(v_row.column_name, i, 1));
      end if;
    end loop;
    if (c_utc%rowcount != v_row_count) then
      dbms_output.put_line(v_table_alias || '.' || lower(v_row.column_name) || ' = ' || v_alias || ',');
    else
      dbms_output.put_line(v_table_alias || '.' || lower(v_row.column_name) || ' = ' || v_alias);
    end if;
  end loop;
  close c_utc;
  dbms_output.put_line('where ' || v_table_alias || '.id = ''''');
end;
/