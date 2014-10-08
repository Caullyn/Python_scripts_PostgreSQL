CREATE OR REPLACE FUNCTION abuser.usp_band_add_update(
    i_asr_email TEXT,
    i_ban_name TEXT,
    i_ban_email TEXT,
    i_ban_description TEXT,
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
    _ban_id TEXT;
    _status_id INT;
    _status_desc TEXT;
    _pass TEXT;
BEGIN
    SELECT asr_id
      INTO _asr_id
      FROM abuser.abuser
     WHERE asr_email = i_asr_email;
    
    IF _asr_id IS NOT NULL THEN
        SELECT ban_id 
          FROM band.band
         WHERE ban_email = i_ban_email
          INTO _ban_id;
        IF _ban_id IS NOT NULL THEN
            UPDATE band.band 
               SET ban_name = i_ban_name,
                   ban_description = i_ban_description,
                   ban_geo_id = i_geo_id,
                   ban_modified = now()
             WHERE ban_email = i_ban_email;
            _status_id = 200;
            _status_desc = 'ban_id updated: ' || _ban_id::text;
        ELSE
            INSERT INTO band.band (ban_asr_id, ban_name, ban_email, ban_description, ban_geo_id)
            VALUES (_asr_id, i_ban_name, i_ban_email, i_ban_description, i_geo_id)
            RETURNING ban_id INTO _ban_id;
            _status_id = 200;
            _status_desc = 'ban_id inserted: ' ||  _ban_id::text;
        END IF;
    ELSE
        _status_id = 402;
        _status_desc = 'User does not exist.';
    END IF;
    RETURN QUERY SELECT _status_id, _status_desc;
END;
$$;