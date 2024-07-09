-- FUNCTION: public.sel_reception(date)

-- DROP FUNCTION IF EXISTS public.sel_reception(date);

CREATE OR REPLACE FUNCTION public.sel_reception(
	dater date)
    RETURNS TABLE(id_reception integer, datereception date, timereception time without time zone, patientfullname character varying, statereception character varying, doctorfullname character varying, idp integer, idd integer) 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
	SELECT
		"Reception"."Id" AS Id_Reception,
		"Reception".date AS DateReception,
		"Reception".time AS TimeReception,
		"Patients".surname || ' ' || "Patients".name AS patientfullname,
		"State_Reception_Legend".Legend AS StateReception,
		"Doctors".namedoctor || ' ' || "Doctors".surnamedoctor AS doctorfullname,
		"Reception".idp AS IdP,
		"Reception".idd	AS IdD	
	FROM
		"Reception"
		LEFT JOIN "Patients"
		ON "Reception".idp = "Patients"."Id"
		LEFT JOIN	public."State_Reception_Legend"
		ON "Reception".state_reception = "State_Reception_Legend"."Id"	
		LEFT JOIN public."Doctors"
		ON "Reception".idd = "Doctors"."Id"
	WHERE
		"Reception".date = $1
	ORDER BY 
		"Reception".time;
$BODY$;

ALTER FUNCTION public.sel_reception(date)
    OWNER TO kartadmin;
