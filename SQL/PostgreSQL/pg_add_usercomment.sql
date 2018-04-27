CREATE OR REPLACE FUNCTION add_usercomment(av_rolname varchar,
                                           av_comment varchar)
    RETURNS boolean AS $$
        BEGIN
           IF EXISTS (
              SELECT rolname
                FROM pg_catalog.pg_roles
               WHERE rolname=av_rolname) THEN
                  EXECUTE 'COMMENT ON ROLE "'|| av_rolname ||'" IS '''|| av_comment||'''';
                  RETURN TRUE;
           ELSE
              RAISE EXCEPTION 'The rolname is not exist: %', av_rolname;
           END IF;
        END;
$$ LANGUAGE 'plpgsql' VOLATILE SECURITY DEFINER;