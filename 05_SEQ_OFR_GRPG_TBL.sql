DECLARE   

    maxid number;

    i number;  

BEGIN   
    i :=0;
    select max(to_number(tbl.OFR_GRPG_ID)) into maxid from OFR_GRPG_TBL tbl;

     WHILE i<=maxid LOOP  
         select SEQ_OFR_GRPG_TBL.nextval into i from dual;   

      END LOOP;  

END;

/

