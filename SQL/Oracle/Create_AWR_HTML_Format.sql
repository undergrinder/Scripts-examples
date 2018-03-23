/************************************************************
   Create AWR html report, after the given begin timestamp
*************************************************************/
DECLARE
    vd_dt            date := to_date('2018-02-26 12:30','yyyy-mm-dd hh24:mi');
    vv_instance_name varchar(100);
    cursor c_snapshot is SELECT  dbid 
                            ,instance_number 
                            ,min(snap_id) as min_id
                            ,max(snap_id) as max_id
                            ,sum(1) as db
                    FROM dba_hist_snapshot 
                    WHERE begin_interval_time >= vd_dt
                    GROUP BY dbid
					        ,instance_number;
                    
    c_row c_snapshot%rowtype;
    
    cursor c_awr_html(dbid            number
                    ,instance_number  number
                    ,min_id           number
                    ,max_id           number ) is SELECT output 
                                                  FROM table(dbms_workload_repository.AWR_REPORT_HTML(dbid
                                                                                                     ,instance_number
                                                                                                     ,min_id
                                                                                                     ,max_id));
    c_awr c_awr_html%ROWTYPE;
BEGIN
    OPEN c_snapshot;
    FETCH c_snapshot INTO c_row;
    CLOSE c_snapshot; /*Egy sort kapunk el, nem kell iteralni*/
    
    IF c_row.db is null THEN
       
      dbms_output.put_line(to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'));
      
      SELECT t.host_name||'.'||t.instance_name||'.'||user INTO vv_instance_name 
      FROM v$instance t; 
      
      dbms_output.put_line('Instance: '||vv_instance_name);     
      dbms_output.put_line('---------------------------------------------');
      dbms_output.put_line('There is no snapshot, at the given timeperiod');
     
    ELSE
      
       FOR c_awr in c_awr_html(c_row.dbid,c_row.instance_number,c_row.min_id, c_row.max_id)
         LOOP
           dbms_output.put_line(c_awr.output);
         END LOOP;
         
    END IF;
END;       
