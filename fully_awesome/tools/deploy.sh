psql -f ../function/abuser/usp_abuser_add_update.sql wotjam postgres
psql -f ../function/abuser/_usp_abuser_pass_check.sql wotjam postgres
psql -f ../function/abuser/_usp_abuser_pass_add.sql wotjam postgres
psql -f ../function/band/usp_band_add_update.sql wotjam postgres
psql -f ../function/event/usp_event_add_update.sql wotjam postgres
psql -f ../function/event/usp_event_display.sql wotjam postgres
