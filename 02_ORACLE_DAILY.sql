
1. 清理adump目录

SQL> show parameter audit_file_dest
NAME			    TYPE                    VALUE
------------------  ----------------------  ---------------------------------
audit_file_dest     string                  /opt/app/oracle/admin/atsdb/adump

find /opt/app/oracle/admin/atsdb/adump -mtime +7 -name "*.aud" |xargs rm -f 


2. 清理trace文件
清理参数background_dump_dest指定的目录，清理的文件为.tr

SQL> show parameter background_dump_dest
NAME				    TYPE          VALUE
----------------------- ------------- --------------------------------------------
background_dump_dest	string        /opt/app/oracle/diag/rdbms/atsdb/atsdb/trace


find /opt/app/oracle/diag/rdbms/atsdb/atsdb/trace -mtime +7 -name "*.trc" | xargs rm -f
find /opt/app/oracle/diag/rdbms/atsdb/atsdb/trace -mtime +7 -name "*.trm" | xargs rm -f

3. 清理xml日志
清理路径为：$ORACLE_BASE/diag/rdbms/$DB_UNIQUE_NAME/ORACLE_SID/alert，清理文件为log_*.xml
find $ORACLE_BASE/diag/rdbms/$DB_UNIQUE_NAME/ORACLE_SID/alert -mtime +7 -name "log_*.xml" | xargs rm -f
4. 清理监听日志

清理路径为：$GRID_BASE/diag/tnslsnr/NODE_NAME/listener/alert，清理文件为log_*.xml
find $GRID_BASE/diag/tnslsnr/NODE_NAME/listener/alert -mtime +7 -name "log_*.xml" | xargs rm -f

#oracle 设置不区分大小写
alter system set sec_case_sensitive_logon=false ;


/u01/app/oracle/admin/orcl/adump

find /u01/app/oracle/admin/orcl/adump -mtime +7 -name "*.aud" |xargs rm -f

find /u01/app/oracle/diag/rdbms/orcl/orcl/trace -mtime +7 -name "*.trc" | xargs rm -f
find /u01/app/oracle/diag/rdbms/orcl/orcl/trace -mtime +7 -name "*.trm" | xargs rm -f

/u01/app/oracle/diag/rdbms/orcl/orcl/trace

