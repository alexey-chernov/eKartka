-- FUNCTION: public.sel_patientone_foredit(integer)

-- DROP FUNCTION IF EXISTS public.sel_patientone_foredit(integer);

CREATE OR REPLACE FUNCTION public.sel_patientone_foredit(
	idp integer)
    RETURNS TABLE(id_patient integer, patientname character varying, patientsurname character varying, patient_address character varying, patient_email character varying, patient_telnumber character varying, parentname character varying, parentsurname character varying, patient_dateofbirth date) 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1

AS $BODY$
	SELECT 
		"Id" AS id_patient, 		
		name AS patientname,
		surname AS patientsurname,
		address AS patient_address, 
		emailaddress AS patient_email, 
		telnumber AS patient_telnumber, 
		parent_name AS parentname,
		parent_surname AS parentsurname,
		dateofbirth AS patient_dateofbirth
	FROM 
		public."Patients"
	WHERE "Id" = $1;  
$BODY$;

ALTER FUNCTION public.sel_patientone_foredit(integer)
    OWNER TO kartadmin;
