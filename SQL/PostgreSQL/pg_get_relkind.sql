/*PARAMETERS:    o av_name - Name of the object, we want to know it's type (table, view etc.)
                 o an_type - 0 : the result is short string like r, v, i etc.
				             1 : the result is long  string like table, view, index etc. (default)
                
        select 'table_name'               as name,
		        get_relkind('table_name') as obj_type;

        select 'table_name'               as name,
		        get_relkind('table_name',0) as obj_type; 

        select 'table_name'               as name,
		        get_relkind('table_name',1) as obj_type; 

        select relname,
               get_relkind(cast(relname as varchar),0) as shortname,
               get_relkind(cast(relname as varchar),1) as longname,
               get_relkind(cast(relname as varchar))   as default       
        from pg_class;				
                     
  undergrinder 2018*/

CREATE OR REPLACE FUNCTION get_relkind(av_name varchar,
                                       an_type integer default 1)
    RETURNS varchar(30) AS $$
        DECLARE
            vv_return varchar(30);
        BEGIN
            select case an_type when 0 then relkind
                                when 1 then case relkind when 'r' then 'table - ordinary' 
								                         when 'c' then 'composite type'
                                                         when 'v' then 'view' 
                                                         when 'm' then 'materialized view' 
                                                         when 'i' then 'index' 
                                                         when 'S' then 'sequence' 
                                                         when 's' then 'special' 
                                                         when 'f' then 'table - foreign' 
                                                         when 'p' then 'table' 
														 when 't' then 'table - TOAST'
                                            end
                    end into vv_return
            from pg_catalog.pg_class
            where relname = trim(lower(av_name));
            
            RETURN coalesce(vv_return,'object not found');
        END;
$$ LANGUAGE 'plpgsql';