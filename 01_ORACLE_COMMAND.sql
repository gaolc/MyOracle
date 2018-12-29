远程桌面连接 win+r --> mstsc   3389

Start Jenkins
----------------------
/opt/jenkins/SOFTWARE/apache-tomcat-7.0.59/bin/startup.sh

Stop Jenkins
----------------------
/opt/jenkins/SOFTWARE/apache-tomcat-7.0.59/bin/shutdown.sh

Start Nginx
---------------------
cd /opt/jenkins/SOFTWARE/nginx/sbin
./nginx


Stop Nginx
-----------------------
cd /opt/jenkins/SOFTWARE/nginx/sbin
./nginx -s stop


------------------------------------------------------
--TO_CHAR 用法 转换的字段必须为时间类型
SELECT TO_CHAR(SYSDATE,'HH24:Mi:SS') FROM DUAL;

--TO_DATE用法 转换的字段必须为字符串类型
SELECT TO_DATE('20171203 13:30:00','YYYYMMDD HH24:Mi:SS') FROM DUAL;
--TO_TIMESTAMP用法 转换的字段必须为字符串类型
SELECT TO_TIMESTAMP(LOGIN_TIME,'YYYYMMDD HH24:Hi:SS.ff')
  FROM NHD.CONNECT_EVENT;
  
--REPLACE(COLUMN_1,'old_word','new_word')
SELECT REPLACE(GROUP_NAME,'ABCI','中国农行') GROUP_NAME 
  FROM LCM.LCM_USERS
  WHERE GROUP_NAME='ABCI' ;

--ROWNUM用法
SELECT * 
  FROM (SELECT * FROM LCM.LCM_USER_IN_OUT ORDER BY LOGIN_IN_TIME DESC)
  WHERE ROWNUM=1 
  
--ROW_NUMBER() OVER (PARTITION COLUMN_1 ORDER BY COLUMN_2) 用法PARTITION COLLUMN是可选项
SELECT *
  FROM (SELECT GROUP_NAME,
               LOGIN_IN_TIME,
               USER_TYPE,
               ROW_NUMBER() OVER( PARTITION BY GROUP_NAME ORDER BY LOGIN_IN_TIME DESC)
        FROM LCM.LCM_USER_IN_OUT )

--GROUP BY HAVING 用法 SELECT 后的字段和GROUP BY 的字段相同
SELECT GROUP_NAME,ROLE_NUM,COUNT(*)
  FROM LCM.LCM_USERS
  GROUP BY GROUP_NAME,ROLE_NUM
  HAVING COUNT(*) >=1
  
--SUBSTR (COLUMN,POSITION,LEN)
SELECT DISTINCT (UPPER(SUBSTR(LOGINID,LENGTH(LOGINID) - 3, 4))) FROM LCM.LCM_USERS ;

--ROWID 用法
SELECT USERNAME,ROWID FROM LCM.LCM_USERS ;

--IN  和 ONT IN  用法

/*      --EXISTS  和 NOT EXISTS 用法
    强调的是否返回结果，不要求知道返回什么
    SELECT 2 FROM STUDENT WHERE ...
    |-----------------------------------------|
    |表A                |表B                  |
    |ID       NAME      |ID     AID     NAME  |
    |1        A1        |1      1       B1    |
    |2        A2        |2      2       B2    |
    |3        A3        |3      2       B3    |
    |-----------------------------------------|
    