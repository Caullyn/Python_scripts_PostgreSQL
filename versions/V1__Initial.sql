BEGIN;

    CREATE SCHEMA abuser;    
    CREATE TABLE abuser.user_type (
				utp_id BIGSERIAL,
				utp_display_name VARCHAR(64)
				);
	INSERT INTO abuser.user_type VALUES (DEFAULT, 'Normal');
	INSERT INTO abuser.user_type VALUES (DEFAULT, 'Traveller');
	
    CREATE TABLE abuser.user_pass (
                usr_id BIGINT PRIMARY KEY, 
                usr_email VARCHAR(255) UNIQUE, 
                usr_salt VARCHAR(124), 
                usr_hash VARCHAR(124), 
                usr_created TIMESTAMP WITH TIME ZONE DEFAULT now(), 
                usr_modified TIMESTAMP WITH TIME ZONE DEFAULT now()
                usr_utp_id BIGINT REFERENCES user.user_type(utp_id) DEFAULT 1);
                 
    CREATE SCHEMA common;
    CREATE TABLE common.country (
    			cnt_id BIGSERIAL,
    			cnt_display_name VARCHAR(255) UNIQUE,
    			cnt_code VARCHAR(10) UNIQUE
    			);
    
    CREATE SCHEMA location;
    CREATE TABLE location.server (
    			srv_id BIGSERIAL,
    			srv_display_name VARCHAR(255) UNIQUE,
    			srv_cnt_id BIGINT REFERENCES common.country(cnt_id)
    			);
    			
    CREATE TABLE location.user_location (
    			ul_id BIGSERIAL,
    			ul_srv_id BIGINT REFERENCES location.server(srv_id),
    			ul_up_id BIGINT REFERENCES user.user_pass(usr_id)
    			);
    			
    CREATE SCHEMA venue;
    CREATE TABLE venue.venue_location (
    			ven_id BIGINT PRIMARY KEY,
    			ven_display_name VARCHAR(255) UNIQUE,
    			ven_cnt_id BIGINT REFERENCES common.country(cnt_id),
    			ven_usr_id BIGINT REFERENCES user.user_pass(usr_id),
    			ven_created TIMESTAMP WITH TIME ZONE DEFAULT now(),
    			ven_updated TIMESTAMP WITH TIME ZONE DEFAULT now()
    			);
COMMIT;