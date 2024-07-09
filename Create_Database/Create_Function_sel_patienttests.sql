-- FUNCTION: public.sel_patienttests(integer)

-- DROP FUNCTION IF EXISTS public.sel_patienttests(integer);

CREATE OR REPLACE FUNCTION public.sel_patienttests(
	idp integer)
    RETURNS TABLE(datetests date, namelaboratory character varying, resultanalysis text, nameanalysis character varying) 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 100

AS $BODY$
	SELECT 
		"Tests".datetests AS datetests, 
		"Tests".namelaboratory AS namelaboratory, 
		"Tests".resultanalysis AS resultanalysis, 
		"Tests".nameanalysis AS nameanalysis
	FROM 
		public."Tests"		
	WHERE
		idp = $1
	ORDER BY
		datetests DESC;
$BODY$;

ALTER FUNCTION public.sel_patienttests(integer)
    OWNER TO kartadmin;
