--生成insert语句
select 'insert into ' || lower(utc.TABLE_NAME),
       lower(utc.column_name) || ',',
       '#{' ||
       lower(regexp_substr(utc.column_name, '[a-z0-9]+', 1, 1, 'i')) ||
       nls_initcap(lower(regexp_substr(utc.column_name,
                                       '[a-z0-9]+',
                                       1,
                                       2,
                                       'i'))) ||
       nls_initcap(lower(regexp_substr(utc.column_name,
                                       '[a-z0-9]+',
                                       1,
                                       3,
                                       'i'))) ||
       nls_initcap(lower(regexp_substr(utc.column_name,
                                       '[a-z0-9]+',
                                       1,
                                       4,
                                       'i'))) || ',' || 'jdbcType=VARCHAR},'
  from user_tab_cols utc
 where utc.table_name = 'table_name';
