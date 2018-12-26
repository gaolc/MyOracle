SET TIMING ON ;  --显示SQL语句的运行时间。默认值为OFF。
SET HEADING OFF ;   --输出域标题，缺省为on
SET PAGESIZE 0;    --输出每页行数，避免分页设置为0
SET PAGESIZE OFF ; 
SET FEEDBACK OFF ;  --禁止最后的输出，缺省为24 ,如 n row selected 
SET LINESIZE 80 ;  --输出一行字符数，缺省为80
SET VERIFY OFF;    --可以打开和关闭提示确认信息 如old 1 new 1 的显示
SET ECHO OFF;      --显示文件中的每条命令及执行结果
SET TERM ON ;      --查询结果即显示于假脱机文件，又在sqlplus中显示
SET TERM OFF ;     --查询结果仅显示于假脱机文件中
SET TRIOUT ON ;
SET TRIMSPOOL ON ;   --去除重定向
SET TRIMOUT ON ;      --去除标准输出每行的拖尾空格，缺省为OFF
SET COLSEP ' '      --输出列之间的分隔符。
SET AUTOTRACE OFF;  --不生成AUTOTRACE 报告，这是缺省模式
SET AUTOTRACE ON;     --EXPLAIN：AUTOTRACE只显示优化器执行路径报告
SET AUTOTRACE ON;    --STATISTICS：只显示执行统计信息
SET AUTOTRACE ON;  -- 包含执行计划和统计信息
SET AUTOTRACE TRACEONLY;  --同SET AUTOTRACE ON，但是不显示查询输出 
SET SERVEROUTPUT ON;    --使用函数dbms_output.put_line()可以输出参数的值