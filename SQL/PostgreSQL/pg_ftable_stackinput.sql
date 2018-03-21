/*PARAMETERS:    o input_table - The table to be stacked
              o id_column   - The column, that store the ID, the other columns will be stack along
              
  EXAMPLE: o INPUT: ID; name;   price            
                     1; apple;  12
                     2; pearl;  16
                     3; orange; 5
                     
           o EXECUTE SELECT * FROM FTABLE_STACKINPUT('FRUITS','ID')
           
           o OUTPUT: ID; COLUMN_NAME; DATE_TYPE; VALUE
                     1;  NAME;        VARCHAR;   APPLE
                     1;  PRICE;       INTEGER;   12
                     2;  NAME         VARCHAR;   PEARL
                     2;  PRICE;       INTEGER;   16
                     3;  NAME;        VARCHAR;   ORANGE
                     3;  PRICE;       INTEGER;   5
                     
                     
  TEST: create table fruits(id integer,
                            name varchar,
                            price integer);
                
        insert into fruits values(1,'apple' ,12),
                                 (2,'pearl' ,16),
                                 (3,'orange',5);
                
        select * from ftable_stackinput('fruits','ID');                      
                     
  undergrinder 2018*/

CREATE OR REPLACE FUNCTION ftable_stackinput(input_table varchar,
                                              id_column   varchar)
RETURNS table(id         integer,
             column_name varchar,
             data_type   varchar,
             value       varchar) AS $$
    DECLARE
        vv_dynamic_sql varchar;
        va_columns_arr varchar[];
        vv_columns     varchar;
        vn_iter        integer;
    BEGIN
        va_columns_arr := array(select cast(isc.column_name as varchar) from information_schema.columns isc where isc.table_name = lower(input_table) and isc.column_name != lower(id_column) order by isc.ordinal_position);
        
        FOR vn_iter IN 1..array_upper(va_columns_arr,1)
        LOOP
            IF vn_iter = 1 THEN
                vv_columns := 'cast('||va_columns_arr[vn_iter]||' as varchar)';
            ELSE
                vv_columns := vv_columns||',cast('||va_columns_arr[vn_iter]||' as varchar)';
            END IF;
        END LOOP;
    
        vv_dynamic_sql := 'SELECT '||id_column||' AS '||id_column||',';
        vv_dynamic_sql := vv_dynamic_sql || 'unnest(array(select cast(column_name as varchar) from information_schema.columns where table_name = '''|| lower(input_table) ||''' and column_name !='''||lower(id_column)||''' order by ordinal_position)) AS column_name,';
        vv_dynamic_sql := vv_dynamic_sql || 'unnest(array(select cast(data_type as varchar) from information_schema.columns where table_name = '''|| lower(input_table) ||''' and column_name !='''||lower(id_column)||''' order by ordinal_position)) AS data_type,';
        vv_dynamic_sql := vv_dynamic_sql || 'unnest(array['||vv_columns||']) AS value ';
        vv_dynamic_sql := vv_dynamic_sql || 'FROM '||input_table||';';
    
        RETURN QUERY EXECUTE vv_dynamic_sql;    
    END;
$$ LANGUAGE 'plpgsql';   