-- mkdir -p /home/oracle/dbUpdate/1.9.8.0
-- sqlplus  / as sysdba
-- create directory TS_198 as '/home/oracle/dbupdate/1.9.8.0';
-- grant read,write on directory TS_198 to username;
-- exec sp_insert_data ('V_name','insert_table_name','TS_198','export_filename.sql');
create or replace procedure sp_insert_data(
v_s_table varchar2,
v_d_table varchar2,
v_directory_name varchar2,
v_file_name varchar2
)
as
  v_insert_sql varchar2(32767);
  v_column_name varchar2(32767);
  v_column_value varchar2(32767);
  v_select_sql varchar2(32767);
 -- v_select_value varchar2(32767);
  v_select_value clob;
  v_select_value2 clob;
  v_total varchar2(32767);

  TYPE tcur IS REF CURSOR;
  cur tcur;

  filehandle utl_file.file_type;

begin

  filehandle := utl_file.fopen(upper(v_directory_name),
                               v_file_name,
                               'w',
                               32767);
  utl_file.put_line(filehandle, 'set define off;');
  utl_file.put_line(filehandle, 'set sqlblankline on;');

  v_insert_sql :='insert into '||v_d_table||' ('||chr(13)||chr(10);
  v_select_sql :='select to_clob('''')||';
  for i in (select t.COLUMN_NAME,t.DATA_TYPE
              from user_tab_columns t
             where t.TABLE_NAME=v_s_table
             order by column_id ) loop
    v_column_name :=v_column_name||i.column_name||','||chr(13)||chr(10);
    --dbms_output.put_line(i.column_name);
    if i.data_type in ('VARCHAR2','VARCHAR','CHAR') then
   --  dbms_output.put_line('char');
      --v_column_value :=v_column_value||'case when '||i.column_name|| ' is null then ''null'' else ''replace(''''''||'||i.column_name||'||'''''','''''''''''''''','''''''''''''''''''''''')'' end' ;
      v_column_value :=v_column_value||'to_clob('''')||case when '||i.column_name|| ' is null then ''null'' else  ''''''''||replace('||i.column_name||','''''''','''''''''''')|| '''''''' end' ;

    elsif i.data_type='DATE' then
   --  dbms_output.put_line('date');
      v_column_value :=v_column_value||'to_clob('''')||case when '||i.column_name|| ' is null then ''null'' else ''to_date(''''''||to_char('||i.column_name||',''yyyymmdd hh24:mi:ss'')||'''''',''''yyyymmdd hh24:mi:ss'''')'' end' ;

    elsif i.data_type like 'TIMESTAMP%' then
    -- dbms_output.put_line('time');
      v_column_value :=v_column_value||'to_clob('''')||case when '||i.column_name|| ' is null then ''null'' else ''to_timestamp(''''''||to_char('||i.column_name||',''yyyymmdd hh24:mi:ss.ff'')||'''''',''''yyyymmdd hh24:mi:ss.ff'''')'' end' ;

    else
   --  dbms_output.put_line('else');
      v_column_value :=v_column_value||'to_clob('''')||case when '||i.column_name|| ' is null then ''null'' else to_char('||i.column_name||') end' ;

    end if;

    --v_column_value:=v_column_value||'||'','''||chr(13)||chr(10)||'||';
    v_column_value:=v_column_value||'||'',''||chr(13)||chr(10)'||chr(13)||chr(10)||'||';
  end loop;

  --dbms_output.put_line(v_column_name);

  v_insert_sql:=v_insert_sql||rtrim(v_column_name,','||chr(13)||chr(10))||' ) values ('||chr(13)||chr(10);
  --v_select_sql :=v_select_sql||rtrim(v_column_value,','||chr(13)||chr(10))||' from '||v_s_table;
  v_select_sql :=v_select_sql||rtrim(v_column_value,'||,'||chr(13)||chr(10)||'||')||' from '||v_s_table||' ';

  --dbms_output.put_line(v_insert_sql);
  --dbms_output.put_line(v_select_sql);

  --execute immediate v_select_sql into v_select_value2;

  --dbms_output.put_line(v_select_value2);

  open cur for v_select_sql;
  loop
    fetch cur
      into v_select_value;
    exit when cur%notfound;
    v_total :=v_insert_sql||rtrim(v_select_value,','||chr(13)||chr(10))||');';
    --dbms_output.put_line(v_total);
    utl_file.put_line(filehandle, v_total);
  end loop;
  utl_file.put_line(filehandle, 'commit;');
  utl_file.fclose(filehandle);

 end;
/

