-- SIN FKS SEGUN ORDEN
CREATE TABLE VAM_MP_PROHIBIDAS(
   cas NUMERIC(12) PRIMARY KEY,
   nombre VARCHAR(50) NOT NULL
);

CREATE TABLE VAM_ESENCIAS_PERF(
   tsca_cas NUMERIC(12) PRIMARY KEY,
   nombre VARCHAR(20) NOT NULL UNIQUE,
   tipo CHAR(1) NOT NULL,
   descripcion VARCHAR(400) NOT NULL,
   CONSTRAINT check_tipo CHECK(tipo in ('n','s'))
);

CREATE TABLE VAM_PERFUMES(
   id SERIAL PRIMARY KEY,
   nombre VARCHAR(20) NOT NULL,
   genero CHAR(1) NOT NULL,
   rango_edad CHAR(3) NOT NULL,
   descrip_componentes VARCHAR(400) NOT NULL,
   tipo_estructura CHAR(1) NOT NULL,
   descrip_perf VARCHAR(400),
   CONSTRAINT check_genero CHECK(genero in ('m','f','u')),
   CONSTRAINT check_rgo_edad CHECK(rango_edad in ('inf','juv','adu','ate')),
   CONSTRAINT check_tipo_est CHECK(tipo_estructura in ('m','f')),
);

CREATE TABLE VAM_FLIA_OLFAT(
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL
);

CREATE TABLE VAM_VAR_CRITERIOS(
    id SERIAL PRIMARY KEY,
    nombre_crit VARCHAR(40) NOT NULL,
    descripcion VARCHAR(400) NOT NULL
);

CREATE TABLE VAM_OTROS_ING_COMP(
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(40) NOT NULL
);

CREATE TABLE VAM_PALABRA_CLAVE(
    id SERIAL PRIMARY KEY,
    palabra VARCHAR(40) NOT NULL
);

CREATE TABLE VAM_ASOC_NACIONALES(
   id SERIAL PRIMARY KEY,
   nombre VARCHAR(20) NOT NULL UNIQUE,
   region CHAR(2) NOT NULL,
   descripcion VARCHAR(400),
   CONSTRAINT check_asoc CHECK( region in ('ap','eu','la','na'))
);

-- CON FK SEGUN ORDEN
