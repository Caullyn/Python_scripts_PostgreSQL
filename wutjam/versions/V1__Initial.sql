BEGIN;

    CREATE SCHEMA abuser;
    CREATE SCHEMA collection;
    
    CREATE TABLE collection.type(
        typ_id BIGSERIAL PRIMARY KEY,
        typ_class TEXT NOT NULL,
        typ_class_id INTEGER NOT NULL,
        typ_description TEXT NOT NULL,
        typ_created TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
        typ_updated TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
        );
        
    CREATE UNIQUE INDEX uqc_collection_type ON collection.type(typ_class, typ_class_id);
        
    INSERT INTO collection.type
    VALUES (DEFAULT, 'abuser_type', 1, 'one_zone', now(), now());
    
    INSERT INTO collection.type
    VALUES (DEFAULT, 'abuser_type', 2, 'two_zone', now(), now());
    
    INSERT INTO collection.type
    VALUES (DEFAULT, 'abuser_type', 3, 'plus_zone', now(), now());
    
    CREATE TABLE abuser.abuser (
        asr_id BIGSERIAL PRIMARY KEY, 
        asr_email TEXT UNIQUE NOT NULL, 
        asr_salt TEXT NOT NULL, 
        asr_hash TEXT NOT NULL, 
        asr_created TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL, 
        asr_modified TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
        asr_utp_id BIGINT REFERENCES collection.type(typ_class_id) NOT NULL DEFAULT 1
        );
        
COMMIT;