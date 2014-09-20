CREATE OR REPLACE FUNCTION abuser._usp_abuser_pass_add(
    i_email TEXT,
    i_geo_id TEXT,
    i_pass TEXT
)
RETURNS TABLE(
    pass TEXT,
    status INT,
    status_desc TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    _asr_id BIGINT;
    _salt TEXT;
    _pass TEXT;
    _status_id INT;
    _status_desc TEXT;
    _auth bytea;
BEGIN

    SELECT sal_salt
      INTO _salt
      FROM abuser.salt sal
     WHERE sal.sal_geo_id = i_geo_id;
    
    _auth = digest(_salt||i_pass||_asr_id::text, 'sha256');
    
    IF _auth::text = _pass THEN
        _status_id = 200;
        _status_desc = 'Abuser Authenticated.';
    ELSE
        _status_id = 400;
        _status_desc = 'Abuser Authentication Failed.';
    END IF;    
    
    RETURN QUERY SELECT _status_id, _status_desc;
END;
$$;