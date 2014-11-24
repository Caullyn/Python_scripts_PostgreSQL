CREATE OR REPLACE FUNCTION abuser._usp_abuser_gen_user()
RETURNS BIGINT
LANGUAGE plpgsql
AS $$
BEGIN

    PERFORM ((EXTRACT(epoch from now()) * 100000)::TEXT || 100::TEXT)::BIGINT;
END;
$$;