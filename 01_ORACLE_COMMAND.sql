Զ���������� win+r --> mstsc   3389

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
--TO_CHAR �÷� ת�����ֶα���Ϊʱ������
SELECT TO_CHAR(SYSDATE,'HH24:Mi:SS') FROM DUAL;

--TO_DATE�÷� ת�����ֶα���Ϊ�ַ�������
SELECT TO_DATE('20171203 13:30:00','YYYYMMDD HH24:Mi:SS') FROM DUAL;
--TO_TIMESTAMP�÷� ת�����ֶα���Ϊ�ַ�������
SELECT TO_TIMESTAMP(LOGIN_TIME,'YYYYMMDD HH24:Hi:SS.ff')
  FROM NHD.CONNECT_EVENT;
  
--REPLACE(COLUMN_1,'old_word','new_word')
SELECT REPLACE(GROUP_NAME,'ABCI','�й�ũ��') GROUP_NAME 
  FROM LCM.LCM_USERS
  WHERE GROUP_NAME='ABCI' ;

--ROWNUM�÷�
SELECT * 
  FROM (SELECT * FROM LCM.LCM_USER_IN_OUT ORDER BY LOGIN_IN_TIME DESC)
  WHERE ROWNUM=1 
  
--ROW_NUMBER() OVER (PARTITION COLUMN_1 ORDER BY COLUMN_2) �÷�PARTITION COLLUMN�ǿ�ѡ��
SELECT *
  FROM (SELECT GROUP_NAME,
               LOGIN_IN_TIME,
               USER_TYPE,
               ROW_NUMBER() OVER( PARTITION BY GROUP_NAME ORDER BY LOGIN_IN_TIME DESC)
        FROM LCM.LCM_USER_IN_OUT )

--GROUP BY HAVING �÷� SELECT ����ֶκ�GROUP BY ���ֶ���ͬ
SELECT GROUP_NAME,ROLE_NUM,COUNT(*)
  FROM LCM.LCM_USERS
  GROUP BY GROUP_NAME,ROLE_NUM
  HAVING COUNT(*) >=1
  
--SUBSTR (COLUMN,POSITION,LEN)
SELECT DISTINCT (UPPER(SUBSTR(LOGINID,LENGTH(LOGINID) - 3, 4))) FROM LCM.LCM_USERS ;

--ROWID �÷�
SELECT USERNAME,ROWID FROM LCM.LCM_USERS ;

--IN  �� ONT IN  �÷�

/*      --EXISTS  �� NOT EXISTS �÷�
    ǿ�����Ƿ񷵻ؽ������Ҫ��֪������ʲô
    SELECT 2 FROM STUDENT WHERE ...
    |-----------------------------------------|
    |��A                |��B                  |
    |ID       NAME      |ID     AID     NAME  |
    |1        A1        |1      1       B1    |
    |2        A2        |2      2       B2    |
    |3        A3        |3      2       B3    |
    |-----------------------------------------|
    