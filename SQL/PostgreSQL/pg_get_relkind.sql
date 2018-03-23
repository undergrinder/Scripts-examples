/*PARAMETERS:    o av_name - Name of the object, we want to know it's type (table, view etc.)
                 o an_type - 0 : the result is short string like r, v, i etc.
				             1 : the result is long  string like table, view, index etc. (default)
                
        select 'table_name'               as name,
		        get_relkind('table_name') as obj_type;

        select 'table_name'               as name,
		        get_relkind('table_name',0) as obj_type; 

        select 'table_name'               as name,
		        get_relkind('table_name',1) as obj_type; 				
                     
  undergrinder 2018*/

CREATE OR REPLACE FUNCTION get_relkind(av_name varchar,
                                       an_type integer default 1)
    RETURNS varchar(30) AS $$
        DECLARE
            vv_return varchar(30) := 'object not found';
        BEGIN
            select case an_type when 0 then relkind
                                when 1 then case relkind when 'r' then 'table' 
                                                         when 'v' then 'view' 
                                                         when 'm' then 'materialized view' 
                                                         when 'i' then 'index' 
                                                         when 's' then 'sequence' 
                                                         when 's' then 'special' 
                                                         when 'f' then 'foreign table' 
                                                         when 'p' then 'table' 
                                            end
                    end into vv_return
            from pg_catalog.pg_class
            where relname = trim(lower(av_name));
            
            RETURN vv_return;
        END;
$$ LANGUAGE 'plpgsql';