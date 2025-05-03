CREATE TABLE public.eodonto (
    code integer NOT NULL,
    email character varying(30),
    name character varying(20) NOT NULL,
    apaterno character varying(20) NOT NULL,
    amaterno character varying(20) NOT NULL,
    CONSTRAINT eodonto_pkey PRIMARY KEY (code),
    CONSTRAINT eodonto_email_key UNIQUE (email)
);

CREATE TABLE public.paciente (
    docid integer NOT NULL,
    email character varying(30),
    name character varying(20) NOT NULL,
    apaterno character varying(20) NOT NULL,
    amaterno character varying(20) NOT NULL,
    CONSTRAINT paciente_pkey PRIMARY KEY (docid),
    CONSTRAINT paciente_email_key UNIQUE (email)
);

CREATE TABLE public.listc (
    day smallint NOT NULL,
    month smallint NOT NULL,
    year smallint NOT NULL,
    id integer NOT NULL PRIMARY KEY
);

CREATE TABLE public.cita (
    ncita integer NOT NULL DEFAULT public.cita_ncita_seq.NEXTVAL,
    motivo character varying(128) NOT NULL,
    day smallint NOT NULL,
    month smallint NOT NULL,
    year smallint NOT NULL,
    turno character(1) NOT NULL CHECK (turno IN ('1', '2', '3')),
    docid integer NOT NULL,
    code integer NOT NULL,
    idlist integer NOT NULL,
    CONSTRAINT cita_pkey PRIMARY KEY (ncita),
    CONSTRAINT cita_docid_fkey FOREIGN KEY (docid) REFERENCES public.paciente(docid),
    CONSTRAINT cita_code_fkey FOREIGN KEY (code) REFERENCES public.eodonto(code),
    CONSTRAINT cita_idlist_fkey FOREIGN KEY (idlist) REFERENCES public.listc(id)
);

CREATE TABLE public.eport (
    idport smallint NOT NULL PRIMARY KEY,
    nombre character varying(20),
    apaterno character varying(20),
    amaterno character varying(20),
    idlista integer NOT NULL,
    CONSTRAINT eport_idlista_fkey FOREIGN KEY (idlista) REFERENCES public.listc(id)
);

CREATE TABLE public.ncones (
    code integer NOT NULL,
    nro integer NOT NULL,
    CONSTRAINT ncones_pkey PRIMARY KEY (code, nro),
    CONSTRAINT ncones_code_fkey FOREIGN KEY (code) REFERENCES public.eodonto(code)
);

CREATE TABLE public.nconpa (
    docid integer NOT NULL,
    nro integer NOT NULL,
    CONSTRAINT nconpa_pkey PRIMARY KEY (docid, nro),
    CONSTRAINT nconpa_docid_fkey FOREIGN KEY (docid) REFERENCES public.paciente(docid)
);


CREATE SEQUENCE public.cita_ncita_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999 CACHE 1;
ALTER SEQUENCE public.cita_ncita_seq OWNED BY public.cita.ncita;

CREATE SEQUENCE public.listc_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.listc_id_seq OWNED BY public.listc.id;


CREATE INDEX index_citas_diario ON public.cita (day, month, year);
CREATE INDEX index_citas_mensual ON public.cita (month, year);
CREATE INDEX index_citas_anual ON public.cita (year);
CREATE INDEX index_edocita ON public.cita (code);
CREATE INDEX index_pacita ON public.cita (docid);

CREATE TRIGGER before_insert_cita

BEFORE INSERT ON public.cita

FOR EACH ROW

EXECUTE FUNCTION public.trigger_validate_cita();