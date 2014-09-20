CREATE OR REPLACE FUNCTION abuser.usp_abuser_add_update(
    i_asr_email TEXT,
    i_asr_pass bytea,
    i_geo_id BIGINT
)
RETURNS TABLE(
    status_id INT,
    status_desc TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    _asr_id BIGINT;
    _status_id INT;
    _status_desc TEXT;
    _pass TEXT;
BEGIN


    SELECT asr_id
      INTO _asr_id
      FROM abuser.abuser
     WHERE asr_email = i_asr_email;
    
    IF _asr_id IS NOT NULL THEN
    
        SELECT status_id, status_desc
          FROM abuser._usp_abuser_pass_check(i_asr_email, i_asr_pass)
          INTO _status_id, _status_desc;
          
        UPDATE abuser.abuser
           SET asr_password = i_asr_pass,
               asr_modified = now()
         WHERE asr_email = i_asr_email
     RETURNING asr_id INTO _asr_id;
        _status_id = 201;
        _status_desc = 'Abuser Updated.';
    ELSE
        SELECT pass, status_id, status_desc
          FROM abuser._usp_abuser_pass_add(i_asr_email, i_asr_pass)
          INTO _pass, _status_id, _status_desc;
          
        INSERT INTO abuser.abuser (asr_email, asr_password, asr_geo_id)
        VALUES (i_asr_email, _pass, i_geo_id);
        _status_id = 200;
        _status_desc = 'Abuser Added.';
    END IF;    
    
    RETURN QUERY SELECT _status_id, _status_desc;
END;
$$;