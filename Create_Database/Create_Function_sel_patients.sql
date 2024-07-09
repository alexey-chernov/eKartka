-- FUNCTION: public.sel_patients()

-- DROP FUNCTION IF EXISTS public.sel_patients();

CREATE OR REPLACE FUNCTION public.sel_patients(
	)
    RETURNS TABLE(id_patient integer, patient character varying) 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
	SELECT 
		"Patients"."Id" AS id_patient, 
		"Patients".surname || ' ' || "Patients".name AS patient		
	FROM
		public."Patients"
	WHERE
		deleted_kart is not True
	ORDER BY
		surname;  
$BODY$;

ALTER FUNCTION public.sel_patients()
    OWNER TO kartadmin;
