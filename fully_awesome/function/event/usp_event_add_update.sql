CREATE OR REPLACE FUNCTION event.usp_event_add_update(
    i_asr_email TEXT,
    i_evt_name TEXT,
    i_evt_description TEXT,
    i_evt_start TIMESTAMP WITH TIME ZONE,
    i_evt_end TIMESTAMP WITH TIME ZONE,
    i_evt_id BIGINT,
    i_evt_geo_id BIGINT,
    i_band TEXT,
    i_img TEXT,
    i_img_type TEXT
)
RETURNS TABLE(
    evt_id BIGINT,
    status_id INT,
    status_desc TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    _asr_id BIGINT;
    _evt_id TEXT;
    _status_id INT;
    _status_desc TEXT;
    _pass TEXT;
BEGIN

    SELECT asr_id
      FROM abuser.abuser
     WHERE asr_email = i_asr_email
      INTO _asr_id;
    
    IF i_evt_id IS NOT NULL THEN 
        UPDATE event.event 
           SET evt_description = i_evt_description,
               evt_name = i_evt_name,
               evt_start = i_evt_start,
               evt_end = i_evt_end,
               evt_modified = now()
         WHERE evt_id = i_evt_id;
        
        IF i_img IS NOT NULL THEN
            UPDATE event.event_image
               SET evi_default = FALSE
             WHERE evi_evt_id = i_evt_id;
        END IF;
        _evt_id = i_evt_id;
        _status_id = 200;
        _status_desc = 'evt_id updated: ' || i_evt_id::text;
    ELSE
        INSERT INTO event.event (evt_asr_id, evt_name, evt_description, evt_start, evt_end, evt_geo_id)
        VALUES (_asr_id, i_evt_name, i_evt_description, i_evt_start, i_evt_end, i_evt_geo_id)
        RETURNING evt_id INTO _evt_id;
        _status_id = 200;
        _status_desc = 'evt_id inserted: ' || _evt_id::text;
    END IF;
    IF i_img IS NOT NULL THEN
        INSERT INTO event.event_image (evi_evt_id, evi_img, evi_type, evi_default)
        SELECT _evt_id, i_img, i_img_type, 1;
    END IF;
    RETURN QUERY SELECT _evt_id, _status_id, _status_desc;
END;
$$;