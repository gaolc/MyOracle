--1.用有dba权限的用户登录 
sqlplus / as sysdba
--2.创建一个新用户
CREATE USER glc IDENTIFIED BY glc;
--3.授予DBA权限
GRANT CONNECT,RESOURCE,DBA to glc;
