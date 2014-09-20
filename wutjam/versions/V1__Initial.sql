BEGIN;

    CREATE SCHEMA abuser;
    CREATE SCHEMA collection;
    CREATE SCHEMA geo;
    CREATE EXTENSION pgcrypto;
    -- 
--     CREATE TABLE collection.type(
--         typ_id BIGSERIAL PRIMARY KEY,
--         typ_class TEXT NOT NULL,
--         typ_class_id INTEGER NOT NULL,
--         typ_description TEXT NOT NULL,
--         typ_created TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
--         typ_updated TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
--         );
--         
--     CREATE UNIQUE INDEX uqc_collection_type ON collection.type(typ_class, typ_class_id);
--         
--     INSERT INTO collection.type
--     VALUES (DEFAULT, 'abuser_type', 1, 'one_zone', now(), now());
--     
--     INSERT INTO collection.type
--     VALUES (DEFAULT, 'abuser_type', 2, 'two_zone', now(), now());
--     
--     INSERT INTO collection.type
--     VALUES (DEFAULT, 'abuser_type', 3, 'plus_zone', now(), now());
--     
--     INSERT INTO collection.type
--     VALUES (DEFAULT, 'geo_type', 1, 'America', now(), now());
--     
--     INSERT INTO collection.type
--     VALUES (DEFAULT, 'geo_type', 2, 'Europe', now(), now());
--

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
        
COMMIT;