CREATE OR REPLACE FUNCTION abuser._usp_abuser_pass_check(
    i_email TEXT,
    i_pass TEXT
)
RETURNS TABLE(
    status_id INT,
    status_desc TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    _salt TEXT;
    _pass TEXT;
    _status_id INT;
    _status_desc TEXT;
    _auth bytea;
BEGIN

    SELECT sal_salt, asr_password
      INTO _salt, _pass
      FROM abuser.salt sal
      JOIN abuser.abuser asr ON asr.asr_geo_id = sal.sal_geo_id
     WHERE asr.asr_email = i_email;
    
    _auth = digest(_salt||i_pass||i_email::text, 'sha256');
    
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