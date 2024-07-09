-- FUNCTION: public.sel_patientone(integer)

-- DROP FUNCTION IF EXISTS public.sel_patientone(integer);

CREATE OR REPLACE FUNCTION public.sel_patientone(
	idp integer)
    RETURNS TABLE(id_patient integer, patientfullname character varying, patient_address character varying, patient_email character varying, patient_telnumber character varying, parentfullname character varying, patient_dateofbirth date) 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1

AS $BODY$
	SELECT 
		"Id" AS id_patient, 		
		name || ' ' || surname AS patientfullname,
		address AS patient_address, 
		emailaddress AS patient_email, 
		telnumber AS patient_telnumber, 
		parent_name || ' ' || parent_surname AS parentfullname,
		dateofbirth AS patient_dateofbirth
	FROM 
		public."Patients"
	WHERE "Id" = $1;  
$BODY$;

ALTER FUNCTION public.sel_patientone(integer)
    OWNER TO kartadmin;
