-- FUNCTION: public.sel_patientexamination(integer)

-- DROP FUNCTION IF EXISTS public.sel_patientexamination(integer);

CREATE OR REPLACE FUNCTION public.sel_patientexamination(
	idp integer)
    RETURNS TABLE(dateexam date, diagnosis character varying, medicaments text, medicalopinion text, doctorfullname character varying) 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 100

AS $BODY$
	SELECT 
		"Examination".dateexam, 
		"Examination".diagnosis,
		"Examination".medicaments,
		"Examination".medicalopinion,
		"Doctors".namedoctor || ' ' || "Doctors".surnamedoctor AS doctorfullname
	FROM 
		public."Examination"
		LEFT JOIN
		public."Doctors"
		ON
		"Examination".idd = "Doctors"."Id"
	WHERE
		idp = $1
	ORDER BY
		dateexam DESC;
$BODY$;

ALTER FUNCTION public.sel_patientexamination(integer)
    OWNER TO kartadmin;
