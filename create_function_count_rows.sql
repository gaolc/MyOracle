create or replace function count_rows(table_name in varchar2,
                                      owner      in varchar2 default null)
  return number authid current_user IS
  num_rows number;
  stmt     varchar2(2000);
begin
  if owner is null then
    stmt := 'select count(*) from "' || table_name || '"';
  else
    stmt := 'select count(*) from "' || owner || '"."' || table_name || '"';
  end if;
  execute immediate stmt
    into num_rows;
  return num_rows;
end;


select table_name,count_rows(table_name) nrows from user_tables order by nrows desc;