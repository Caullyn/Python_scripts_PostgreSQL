BEGIN;

    CREATE SCHEMA abuser;
    CREATE SCHEMA collection;
    CREATE SCHEMA geo;
    CREATE SCHEMA band;
    CREATE SCHEMA event;
    CREATE EXTENSION pgcrypto;

    CREATE TABLE abuser.abuser_type (
        ast_id BIGSERIAL PRIMARY KEY,
        ast_type TEXT NOT NULL,
        ast_created TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL, 
        ast_modified TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
        );
    
    INSERT INTO abuser.abuser_type 
    VALUES (DEFAULT, 'One Location', DEFAULT, DEFAULT);
    
    INSERT INTO abuser.abuser_type 
    VALUES (DEFAULT, 'Two Locations', DEFAULT, DEFAULT);
    
    INSERT INTO abuser.abuser_type 
    VALUES (DEFAULT, 'More Locations', DEFAULT, DEFAULT);
    
    CREATE TABLE geo.geo_location (
        geo_id BIGSERIAL PRIMARY KEY,
        geo_description TEXT,
        geo_created TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL, 
        geo_modified TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
        );
        
    INSERT INTO geo.geo_location
    VALUES (DEFAULT, 'North America', DEFAULT, DEFAULT);
    
    INSERT INTO geo.geo_location
    VALUES (DEFAULT, 'Europe', DEFAULT, DEFAULT);
    
    CREATE TABLE abuser.salt (
        sal_id BIGSERIAL PRIMARY KEY,
        sal_salt TEXT NOT NULL,
        sal_geo_id BIGINT REFERENCES geo.geo_location(geo_id) NOT NULL
        );
        
    CREATE TABLE abuser.abuser (
        asr_id BIGSERIAL PRIMARY KEY, 
        asr_email TEXT UNIQUE NOT NULL, 
        asr_password TEXT,
        asr_type_id BIGINT REFERENCES abuser.abuser_type(ast_id) NOT NULL DEFAULT 1,
        asr_geo_id BIGINT REFERENCES geo.geo_location(geo_id) NOT NULL,
        asr_created TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL, 
        asr_modified TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
        );
        
    CREATE TABLE band.band (
        ban_id BIGSERIAL PRIMARY KEY,
        ban_asr_id BIGINT REFERENCES abuser.abuser(asr_id) NOT NULL,
        ban_geo_id BIGINT REFERENCES geo.geo_location(geo_id) NOT NULL,
        ban_email TEXT UNIQUE NOT NULL,
        ban_description TEXT NOT NULL,
        ban_created TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL, 
        ban_modified TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
        );
        
    CREATE TABLE band.image (
        big_id BIGSERIAL PRIMARY KEY,
        big_ban_id BIGINT REFERENCES band.band(ban_id) NOT NULL,
        big_name TEXT NOT NULL,
        big_description TEXT NOT NULL,
        big_image BYTEA
        );
         
    CREATE TABLE event.event (
        evt_id BIGSERIAL PRIMARY KEY,
        evt_name TEXT NOT NULL,
        evt_description TEXT,
        evt_start TIMESTAMP WITH TIME ZONE NOT NULL,
        evt_end TIMESTAMP WITH TIME ZONE,
        evt_created TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL, 
        evt_modified TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
        );
    
    CREATE TABLE event.event_band(
        evb_id BIGSERIAL PRIMARY KEY,
        evb_ban_id BIGINT REFERENCES band.band(ban_id) NOT NULL,
        evb_evt_id BIGINT REFERENCES event.event(evt_id) NOT NULL
        );
    
    CREATE UNIQUE INDEX uqc_event_band ON event.event_band(evb_ban_id, evb_evt_id);
    
COMMIT;