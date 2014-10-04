CREATE OR REPLACE FUNCTION abuser.usp_event_add_update(
    i_evt_name TEXT NOT NULL,
    i_evt_description TEXT NOT NULL,
    i_evt_start TIMESTAMP WITH TIME ZONE NOT NULL,
    i_evt_end TIMESTAMP WITH TIME ZONE NOT NULL,
    i_band TEXT,
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

    SELECT ban_id 
      FROM band.band
     WHERE ban_email = i_ban_email
      INTO _ban_id;
    IF _ban_id IS NOT NULL THEN
        INSERT INTO event.event (ban_asr_id, ban_email, ban_description)
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
    RETURN QUERY SELECT _status_id, _status_desc;
END;
$$;