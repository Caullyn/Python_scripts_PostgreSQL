CREATE OR REPLACE FUNCTION abuser.usp_band_add_update(
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
        IF _ban_email IS NOT NULL THEN
            INSERT INTO band.band (ban_asr_id, ban_email, ban_description)
            VALUES (_asr_id, i_ban_email, i_ban_description, DEFAULT)
            RETURNING ban_id INTO _ban_id;
            _status_id = 203;
            _status_desc = 'ban_id % inserted.' % _ban_id;
        ELSE
            UPDATE band.band 
               SET ban_description = i_ban_description,
                   ban_geo_id = i_geo_id
             WHERE ban_email = i_ban_email;
            _status_id = 202;
            _status_desc = 'ban_id % updated.' % _ban_id;
        END IF;
    END IF;
    RETURN QUERY SELECT _status_id, _status_desc;
END;
$$;