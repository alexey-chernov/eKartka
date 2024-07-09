-- Table: public.Doctors

-- DROP TABLE IF EXISTS public."Doctors";

CREATE TABLE IF NOT EXISTS public."Doctors"
(
    "Id" bigint NOT NULL DEFAULT nextval('"Doctors_id_seq"'::regclass),
    namedoctor character(50) COLLATE pg_catalog."default" NOT NULL,
    surnamedoctor character(50) COLLATE pg_catalog."default" NOT NULL,
    address character(100) COLLATE pg_catalog."default",
    emailaddress character(50) COLLATE pg_catalog."default",
    doctorsposition character(50) COLLATE pg_catalog."default" NOT NULL,
    telnumber character(10) COLLATE pg_catalog."default",
    fotodoctor character(100) COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Doctors"
    OWNER to kartadmin;

COMMENT ON TABLE public."Doctors"
    IS 'Doctors Table';

-- =============================================================================

-- Table: public.Examination

-- DROP TABLE IF EXISTS public."Examination";

CREATE TABLE IF NOT EXISTS public."Examination"
(
    idp bigint NOT NULL,
    dateexam date NOT NULL DEFAULT now(),
    diagnosis character(50) COLLATE pg_catalog."default",
    medicaments text COLLATE pg_catalog."default",
    medicalopinion text COLLATE pg_catalog."default",
    idd bigint NOT NULL
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Examination"
    OWNER to kartadmin;

-- =============================================================================

-- Table: public.Patients

-- DROP TABLE IF EXISTS public."Patients";

CREATE TABLE IF NOT EXISTS public."Patients"
(
    "Id" bigint NOT NULL DEFAULT nextval('"Patients_id_seq"'::regclass),
    name character(50) COLLATE pg_catalog."default" NOT NULL,
    surname character(50) COLLATE pg_catalog."default" NOT NULL,
    address character(100) COLLATE pg_catalog."default",
    emailaddress character(50) COLLATE pg_catalog."default",
    telnumber character(10) COLLATE pg_catalog."default",
    parent_name character(50) COLLATE pg_catalog."default" NOT NULL,
    parent_surname character(50) COLLATE pg_catalog."default" NOT NULL,
    dateofbirth date NOT NULL,
    deleted_kart boolean NOT NULL DEFAULT false
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Patients"
    OWNER to kartadmin;

COMMENT ON TABLE public."Patients"
    IS 'Patients Table';

-- =============================================================================

-- Table: public.Reception

-- DROP TABLE IF EXISTS public."Reception";

CREATE TABLE IF NOT EXISTS public."Reception"
(
    "Id" bigint NOT NULL DEFAULT nextval('"Reception_id_seq"'::regclass),
    date date NOT NULL,
    "time" time without time zone,
    idd integer,
    idp integer,
    state_reception smallint NOT NULL DEFAULT 0
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Reception"
    OWNER to kartadmin;

-- =============================================================================

-- Table: public.Tests

-- DROP TABLE IF EXISTS public."Tests";

CREATE TABLE IF NOT EXISTS public."Tests"
(
    idp bigint NOT NULL,
    datetests date NOT NULL DEFAULT now(),
    namelaboratory character(50) COLLATE pg_catalog."default",
    resultanalysis text COLLATE pg_catalog."default",
    nameanalysis character(50) COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Tests"
    OWNER to kartadmin;

-- =============================================================================

-- Table: public.State_Reception_Legend

-- DROP TABLE IF EXISTS public."State_Reception_Legend";

CREATE TABLE IF NOT EXISTS public."State_Reception_Legend"
(
    "Id" integer NOT NULL DEFAULT nextval('"State_Reception_Legend_Id_seq"'::regclass),
    legend character(20) COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."State_Reception_Legend"
    OWNER to kartadmin;

-- =============================================================================