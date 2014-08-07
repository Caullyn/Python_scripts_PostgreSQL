BEGIN;

CREATE TABLE gameplay.activity (
         act_id BIGSERIAL,
         act_date timestamp with time zone, 
         act_day_of_week INT, 
         act_week INT, 
         act_month INT, 
         act_quarter INT, 
         act_year INT,
         act_currency text, 
         act_game_category text, 
         act_game_name text, 
         act_bet_count BIGINT, 
         act_winning_bets_count BIGINT, 
         act_player_count BIGINT,   
         act_stake numeric(10,2),
         act_payout  numeric(10,2),
         act_opt_id BIGINT
        );
 

INSERT INTO gameplay.activity (act_date,act_day_of_week,act_week,act_month,act_quarter,act_year,act_currency,act_game_category,act_game_name,act_bet_count,act_winning_bets_count,act_player_count,act_stake,act_payout,act_opt_id)
SELECT date_trunc('day', gr_timestamp_updated)     AS Date,
       EXTRACT(DOW FROM  date_trunc('day', gr_timestamp_updated))     AS Day_of_week,
       EXTRACT(WEEK FROM  date_trunc('day', gr_timestamp_updated))    AS Week,
       EXTRACT(MONTH FROM  date_trunc('day', gr_timestamp_updated))   AS Month,
       EXTRACT(QUARTER FROM  date_trunc('day', gr_timestamp_updated)) AS Quarter,
       EXTRACT(YEAR FROM  date_trunc('day', gr_timestamp_updated))    AS Year,
       cur.cur_display_name AS Currency,
       gc.gc_display_name AS   Game_Category,
       gp.gp_display_name AS Game_Name,
--        15                   Play_Days,
       SUM(CASE
            WHEN gr.gr_stake > 0::numeric THEN 1
            ELSE 0
        END::bigint) Bet_Count, 
        SUM(CASE
            WHEN gr.gr_winlose = 0 THEN 1
            ELSE 0
        END)::bigint Winning_Bets_Count, 
        COUNT(gr.gr_playerid) Player_Count, 
        SUM(gr.gr_stake) Stake, 
        SUM(COALESCE(gr.gr_return, 0::numeric)) Payout, 
        gr.gr_opt_id AS gg_opt_id
   FROM gameplay.gamerounds gr
   JOIN gameplay.gamesessions gs ON gr.gr_gs_id = gs.gs_id AND gr.gr_opt_id = gs.gs_opt_id
   JOIN game.gameinstances gi ON gi.gi_id = gs.gs_gi_id
   JOIN game.gameversions gav ON gi.gi_gav_id = gav.gav_id
   JOIN game.games gam ON gav.gav_gam_id = gam.gam_id
   JOIN game.gameprofile gp ON gam.gam_id = gp.gp_gam_id
   JOIN game.game_gamecategory ggc ON gam.gam_id = ggc.ggc_gam_id
   JOIN game._gamecategories gc ON ggc.ggc_gc_id = gc.gc_id
   JOIN common._currencies cur ON gr.gr_cur_id = cur.cur_id
--     AND date_trunc('day', gr_timestamp_updated) > (now() - '2 days'::interval)
  GROUP BY date_trunc('day', gr_timestamp_updated), gr_opt_id, gp_display_name, cur_display_name, gc_display_name
  ORDER BY date_trunc('day', gr_timestamp_updated), gr_opt_id, gp_display_name, cur_display_name, gc_display_name;
  
COMMIT;