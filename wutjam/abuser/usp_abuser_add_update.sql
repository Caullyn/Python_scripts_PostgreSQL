CREATE OR REPLACE FUNCTION abuser.usp_abuser_add_update(
    i_asr_email TEXT,
    i_asr_pass TEXT
)
RETURNS RECORD
LANGUAGE plpgsql
AS $$
DECLARE
    _asr_id BIGINT;
    _status_id INT;
    _status_desc TEXT;
BEGIN

    UPDATE abuser.abuser
       SET asr_salt = i_asr_salt,
           asr_pass = i_asr_pass,
           asr_modified = now()
     WHERE asr_email = i_asr_email
 RETURNING asr_id INTO _asr_id;
    IF _asr_id IS NULL THEN
        INSERT INTO abuser.abuser (asr_email, asr_salt, asr_hash)
        VALUES i_asr_email, i_asr_salt, i_asr_hash;
        _status = 200;
        _status_desc = 'Abuser Added.'
    ELSE
        _status = 201;
        _status_desc = 'Abuser Updated.'
    END IF;    
    
    RETURN _status, _status_desc;
END;
$$;