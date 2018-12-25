ORA-00054资源正忙的解决办法
select session_id from v$locked_object;
SESSION_ID
----------
142
SELECT sid, serial#, username, osuser FROM v$session where sid = 142;
SID SERIAL# USERNAME OSUSER
---------- ---------- ------------------------------ ------------------------------
142 38 SCOTT LILWEN

ALTER SYSTEM KILL SESSION '142,38';

SQL> select t2.username,t2.sid,t2.serial#,t2.logon_time from v$locked_object t1,v$session t2 where t1.session_id=t2.sid order by t2.logon_time;
SQL> alter system kill session '3,449'; 

sqlplus haier_group/haier_group@192.168.2.200:1521/atsdb

ALTER TABLE LIMIT_DEAL ADD (BRANCH  VARCHAR2(30 BYTE));

解锁用户
ALTER USER scott ACCOUNT UNLOCK;

DML语言，比如update，delete，insert等修改表中数据的需要commit;
DDL语言，比如create，drop等改变表结构的，就不需要写commit（因为内部隐藏了commit）;
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
a.切换为 oracle 用户身份，也可以使用 su - 将 home 和 path 都切换到 oralce 用户。
su oracle
b.启动 Sqlplus（使用 sql 语句） 但不进行登录动作
sqlplus /nolog
c.使用数据库管理员连接数据库
connect /as sysdba
d.启动数据库，并退出 sqlplus 命令状态
startup  //开启监听前先退出 sqlplus
exit
e.启动监听，关闭数据库
lsnrctl start  
shutdown immediate  //关闭数据库
f.startup 一些常用参数
    不带参数，启动数据库实例并打开数据库，以便用户使用数据库，在多数情况下，使用这种方式！
    nomount，只启动数据库实例，但不打开数据库，在你希望创建一个新的数据库时使用，或者在你需要这样的时候使用！
    mount，在进行数据库更名的时候采用。这个时候数据库就打开并可以使用了！
g.shutdown 一些常用参数
    Normal 需要等待所有的用户断开连接
    Immediate 等待用户完成当前的语句
    Transactional 等待用户完成当前的事务
    Abort 不做任何等待，直接关闭数据库
    normal需要在所有连接用户断开后才执行关闭数据库任务，所以有的时候看起来好象命令没有运行一样！在执行这个命令后不允许新的连接
    immediate在用户执行完正在执行的语句后就断开用户连接，并不允许新用户连接。
    transactional 在拥护执行完当前事物后断开连接，并不允许新的用户连接数据库。
    abort 执行强行断开连接并直接关闭数据库。 

#_##############################
ORA-00020: maximum number of processes (100) exceeded

sqlplus -prelim / as sysdba
sqlplus / as sysdba
SQL> set linesize 500;
SQL> show parameter processes;
alter system set processes=1800 scope=spfile;
alter system set job_queue_processes=1000 scope=spfile;