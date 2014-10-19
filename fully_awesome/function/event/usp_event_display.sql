CREATE OR REPLACE FUNCTION event.usp_event_display(
    i_asr_geo_id BIGINT,
    i_band TEXT
)
RETURNS TABLE(
    evt_name TEXT,
    evt_description TEXT,
    evt_start TIMESTAMP WITH TIME ZONE,
    evt_end TIMESTAMP WITH TIME ZONE,
    status_id INT,
    status_desc TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    _status_id INT;
    _status_desc TEXT;
BEGIN

    _status_id = 200;
    _status_desc = 'events returned: 15';
    RETURN QUERY 
    SELECT evt.evt_name, evt.evt_description, evt.evt_start, evt.evt_end, _status_id, _status_desc
      FROM event.event evt
     WHERE (evt.evt_start > now() OR evt.evt_end > now())
     ORDER BY evt.evt_start, evt_name
     LIMIT 15;
     
END;
$$;