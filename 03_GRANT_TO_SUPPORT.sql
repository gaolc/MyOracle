/* Formatted on 2018/10/31 9:35:00 (QP5 v5.256.13226.35510) */
DECLARE
   P_OWNER_USER   VARCHAR2 (20);
   P_GRANT_USER   VARCHAR2 (20);
BEGIN
   P_OWNER_USER := 'TSDEV';
   P_GRANT_USER := 'SUPPORT';
   FOR P_SQL
      IN (SELECT DISTINCT 'GRANT SELECT ON ' || A.OBJECT_NAME || ' TO ' || P_GRANT_USER AS E_SQL
            FROM USER_OBJECTS A
           WHERE     A.OBJECT_TYPE IN ('SEQUENCE',
                                       'TABLE',
                                       'VIEW')
                 AND A.OBJECT_NAME NOT IN (SELECT DISTINCT B.TABLE_NAME
                                             FROM USER_TAB_PRIVS B
                                            WHERE B.OWNER = P_OWNER_USER)
          UNION ALL
          SELECT DISTINCT 'GRANT DEBUG ON ' || A.OBJECT_NAME || ' TO ' || P_GRANT_USER AS E_SQL
            FROM USER_OBJECTS A
           WHERE     A.OBJECT_TYPE IN ('PACKAGE', 'PROCEDURE')
                 AND A.OBJECT_NAME NOT IN (SELECT DISTINCT B.TABLE_NAME
                                         FROM USER_TAB_PRIVS B
                                        WHERE B.OWNER = P_OWNER_USER))
   LOOP
      DBMS_OUTPUT.PUT_LINE ('EXECUTE SQL : ' || P_SQL.E_SQL);

      EXECUTE IMMEDIATE P_SQL.E_SQL;
   END LOOP;
END;
/
