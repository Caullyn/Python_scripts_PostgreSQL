    CREATE OR REPLACE FUNCTION finance.usp_daily_report(
    	i_usr_email VARCHAR(255),
    	i_usr_salt VARCHAR(124), 
		i_usr_hash VARCHAR(124)
    )
    RETURNS RECORD
    LANGUAGE plpgsql
    AS $$
    DECLARE
    BEGIN
    
    	UPDATE 
usr_id BIGINT PRIMARY KEY, 
                usr_email VARCHAR(255) UNIQUE, 
                usr_salt VARCHAR(124), 
                usr_hash VARCHAR(124), 
                usr_created TIMESTAMP WITH TIME ZONE DEFAULT now(), 
                usr_modified TIMESTAMP WITH TIME ZONE DEFAULT now()
                usr_utp_id BIGINT REFERENCES user.user_type(utp_id) DEFAULT 1);
                 

    END;
    $$;