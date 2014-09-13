CREATE OR REPLACE FUNCTION abuser._usp_abuser_pass_check(
    i_asr_id BIGINT
    i_email TEXT,
    i_pass TEXT
)
RETURNS RECORD
LANGUAGE plpgsql
AS $$
DECLARE
    _asr_id BIGINT;
    _salt TEXT;
    _pass TEXT;
    _status_id INT;
    _status_desc TEXT;
BEGIN

    SELECT sal_salt, asr_password
      INTO _salt, _pass
      FROM abuser.salt sal
      JOIN abuser.abuser asr ON asr.asr_geo_id = sal.sal_geo_id
     WHERE asr.asr_email = i_asr_email;
     
    IF asr_password = digest(_salt||i_pass||i_asr_id, "sha256") THEN
        _status = 200;
        _status_desc = 'Abuser Authenticated.'
    ELSE
        _status = 400;
        _status_desc = 'Abuser Authentication Failed.'
    END IF;    
    
    RETURN _status, _status_desc;
END;
$$;