BEGIN;

    SELECT * FROM abuser.usp_abuser_add_update('ex@mple.com','asdfasdf',1::BIGINT);
    
    SELECT * FROM band.usp_band_add_update(
        'ex@mple.com',
        'wotjam ample sample example',
        'wase@gmail.com',
        'Just a band example.',
        1);
        
    SELECT * FROM event.usp_event_add_update(
        'ex@mple.com'::TEXT,
        'Pre-show jam'::TEXT,
        'An intimate jam to get ready for our big show.'::TEXT,
        (now() + '1 week'::interval)::TIMESTAMPTZ,
        (now() + '1 week'::interval + '3 hours'::interval)::TIMESTAMPTZ,
        NULL::BIGINT,
        1::BIGINT,
        '1');
        
    SELECT * FROM event.usp_event_add_update(
        'ex@mple.com',
        'The big show',
        'Our big show.',
        now() + '8 days'::interval,
        now() + '8 days'::interval + '3 hours'::interval,
        NULL,
        1,
        '1');
        
    SELECT * FROM event.usp_event_add_update(
        'ex@mple.com',
        'Post-show chillout',
        'An event to celebrate our big show.',
        now() + '9 days'::interval,
        now() + '9 days'::interval + '3 hours'::interval,
        NULL,
        1,
        '1');
        
COMMIT;