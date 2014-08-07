    CREATE OR REPLACE FUNCTION gameplay.usp_activity_query(
        i_dimension text,
        i_series text,
        i_where text[],
        i_start timestamp with time zone,
        i_end timestamp with time zone
    )
    RETURNS SETOF RECORD
        LANGUAGE plpgsql
    AS $uaq$                                                                                                     
    DECLARE       
        _stmt text;  
        _series text[];
        _s text;  
        _where text;
        _i text[];  
        _c int;   
                                                                                                                                                             
    BEGIN                                                                                                                                                                                
        _stmt = 'SELECT ' || i_dimension ;   
        RAISE NOTICE '%', _stmt;
        _series = string_to_array(i_series, ',');
        FOR _s IN array_lower(_series, 1) .. array_upper(_series, 1)
         LOOP                         
            RAISE NOTICE '%', _series[_s];                                                                                                                                                             
             _stmt=_stmt || ', SUM(' || _series[_s] || ')' ;   
        RAISE NOTICE '%', _stmt;
         END LOOP;                                            
        
        _stmt = _stmt || $$ FROM gameplay.activity WHERE act_date between '$$ || i_start || $$' AND '$$ || i_end || $$' $$;   
        RAISE NOTICE '%', _stmt;
        _c = 1;
        RAISE NOTICE '%', i_where;
        FOREACH _i SLICE 1 IN ARRAY i_where
        LOOP             
            _stmt=_stmt || ' AND ' || _i[1];
            _stmt=_stmt || $$ = '$$ || _i[2] || $$'$$;
            _c = _c + 1;
            RAISE NOTICE '%', _stmt;
            RAISE NOTICE '%', _i;
            RAISE NOTICE '%', 5;
        END LOOP;                                                                                      
        _stmt = _stmt || 'GROUP BY ' || i_dimension || ' ;';      
        RAISE NOTICE '%', _stmt;
        RAISE NOTICE '%', _stmt;
        EXECUTE _stmt;                                                                                                                                                             
     END;                                                                                                                                                                                 
    $uaq$;