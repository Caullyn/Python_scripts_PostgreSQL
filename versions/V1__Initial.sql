BEGIN;

    CREATE SCHEMA user;
    
    CREATE TABLE user.user_pass (
                 up_id BIGSERIAL, 
                 up_email VARCHAR(255) UNIQUE, 
                 up_salt VARCHAR(124), 
                 up_hash VARCHAR(124), 
                 up_created TIMESTAMP WITH TIME ZONE, 
                 up_modified TIMESTAMP WITH TIME ZONE);
                 
    