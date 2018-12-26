--1.用有dba权限的用户登录 
sqlplus / as sysdba
--2.创建一个新用户
CREATE USER glc IDENTIFIED BY glc;
--3.授予DBA权限
GRANT CONNECT,RESOURCE,DBA to glc;

--首先是CPR账号
--授权表上的读写权限
select 'grant all on '||owner||'.'||table_name||' to hisuser;' from dba_tables
where owner = 'CPR';
select 'grant read on 'owner||'.'||table_name||'to tsdeal;' from user_tables;
--授权视图上的读写权限
select 'grant all on '||owner||'.'||view_name||' to hisuser;' from dba_views
where owner = 'CPR';
--授权函数和存储过程的读写权限
select 'grant execute on '||owner||'.'||name||' to hisuser;' from dba_source
where owner = 'CPR' and type in ('PROCEDURE','FUNCTION','PACKAGE','PACKAGE BODY','TYPE BODY','TRIGGER','TYPE') ;
--授权序列的读写权限
select 'grant all on '||sequence_owner||'.'||sequence_name||' to hisuser;' from dba_sequences where sequence_owner = 'CPR' ;
--创建同义词
select 'create or replace public synonym '||synonym_name||' for '||table_owner||'.'||table_name||' ;' from dba_synonyms
where table_owner='CPR' ;
select 'create or replace public synonym '||view_name||' for '||owner||'.'||view_name||' ;' from dba_views
where owner = 'CPR' and (owner NOT LIKE '%$%' OR view_name NOT LIKE '%$%') ;

后是system账号
--授权表上的读写权限
select 'grant all on '||owner||'.'||table_name||' to hisuser;' from dba_tables
where owner = 'SYSTEM' and table_name NOT LIKE '%$%';

--授权视图上的读写权限
select 'grant all on '||owner||'.'||view_name||' to hisuser;' from dba_views
where owner = 'SYS';    

--授权函数和存储过程的读写权限
select DISTINCT 'grant execute on '||owner||'.'||name||' to hisuser;' from dba_source
where owner = 'SYS' and type in ('PROCEDURE','FUNCTION','PACKAGE','PACKAGE BODY','TYPE BODY','TRIGGER','TYPE') AND name NOT LIKE '%$%'

--授权序列的读写权限
select 'grant all on '||sequence_owner||'.'||sequence_name||' to hisuser;' from dba_sequences where sequence_owner = 'SYSTEM' AND sequence_name NOT LIKE '%$%';

--创建同义词
select 'create or replace public synonym '||synonym_name||' for '||table_owner||'.'||table_name||' ;' from dba_synonyms
where table_owner='SYS' and synonym_name NOT LIKE '%$%';

select 'create or replace public synonym '||view_name||' for '||owner||'.'||view_name||' ;' from dba_views
where owner = 'SYS' and (owner NOT LIKE '%$%' OR view_name NOT LIKE '%$%') ; 


--批量收回用户对象权限，收回用户chenmh在架构zhang下的所有权限
SELECT 'REVOKE '||PRIVILEGE||' ON '||OWNER||'.'||TABLE_NAME||' FROM CHENMH;' FROM DBA_Tab_Privs WHERE GRANTEE='CHENMH' AND OWNER='ZHANG'
ORDER BY TABLE_NAME,PRIVILEGE;

--批量收回角色权限
SELECT 'REVOKE '||GRANTED_ROLE||' FROM CHENMH;' FROM DBA_ROLE_PRIVS WHERE GRANTEE='CHENMH';