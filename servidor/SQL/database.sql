CREATE DATABASE sistema_vam;

--Cambiarse a la BS: \c database_name
--Listar BD: \l o \list
--Listar tablas de una BD: \dt

CREATE TABLE VAM_MP_PROHIBIDAS(
   cas NUMERIC(12) PRIMARY KEY,
   nombre VARCHAR(50) NOT NULL
);

CREATE TABLE VAM_ESENCIAS_PERF(
   tsca_cas NUMERIC(12) PRIMARY KEY,
   nombre VARCHAR(20) NOT NULL UNIQUE,
   tipo CHAR(1) NOT NULL,
   descripcion VARCHAR(400),
   CONSTRAINT check_tipo CHECK(tipo in ('n','s'))
);

CREATE TABLE VAM_PERFUMES(
   id SERIAL PRIMARY KEY,
   nombre VARCHAR(20) NOT NULL UNIQUE,
   genero CHAR(1) NOT NULL,
   rango_edad CHAR(3) NOT NULL,
   descrip_componentes VARCHAR(400) NOT NULL,
   tipo_estructura CHAR(1) NOT NULL,
   descrip_perf VARCHAR(400),
   CONSTRAINT check_genero CHECK(genero in ('m','f','u')),
   CONSTRAINT check_rgo_edad CHECK(rango_edad in ('inf','juv','adu')),
   CONSTRAINT check_tipo_est CHECK(tipo_estructura in ('m','f')),
);

CREATE TABLE NOTAS_PERFUMES(
   id SERIAL,
   id_perf INT,
   id_esencia_perf INT,
   tipo_nota CHAR(1) NOT NULL,
   CONSTRAINT check_tipo CHECK(tipo_nota in ('s','c','f')),
   CONSTRAINT fk_perf FOREIGN KEY(id_perf) REFERENCES VAM_PERFUMES(id) ON DELETE CASCADE,
   CONSTRAINT fk_esencia FOREIGN KEY(id_esencia_perf) REFERENCES VAM_ESENCIAS_PERF(id) ON DELETE CASCADE,
   CONSTRAINT pk_notas PRIMARY KEY(id,id_perf,id_esencia_perf)
);

CREATE TABLE VAM_ASOC_NACIONALES(
   id SERIAL PRIMARY KEY,
   nombre VARCHAR(20) NOT NULL UNIQUE,
   region CHAR(2) NOT NULL,
   descripcion VARCHAR(400),
   CONSTRAINT check_asoc CHECK( region in ('ap','eu','la','na'))
);

CREATE TABLE VAM_PAISES(
   id SERIAL PRIMARY KEY,
   nombre VARCHAR(20) NOT NULL UNIQUE,
   continente CHAR(2) NOT NULL,
   id_asoc_nac INT,
   CONSTRAINT check_cont CHECK(continente in ('am', 'e', 'af', 'as', 'o')),
   CONSTRAINT fk_asoc FOREIGN KEY(id_asoc_nac) REFERENCES VAM_ASOC_NACIONALES(id)
);

CREATE TABLE VAM_PRODUCTORES(
   id SERIAL PRIMARY KEY,
   nombre VARCHAR(50) NOT NULL UNIQUE,
   email VARCHAR(50) NOT NULL UNIQUE,
   telefono NUMERIC(10) NOT NULL UNIQUE,
   pag_web VARCHAR(100) NOT NULL UNIQUE,
   id_asoc_nac INT,
   CONSTRAINT id_asociacion FOREIGN KEY(id_asoc_nac) REFERENCES VAM_ASOC_NACIONALES(id) ON DELETE SET NULL
);

CREATE TABLE VAM_PROVEEDORES(
   id SERIAL PRIMARY KEY,
   nombre VARCHAR(50) NOT NULL UNIQUE,
   email VARCHAR(50) NOT NULL UNIQUE,
   telefono NUMERIC(10) NOT NULL UNIQUE,
   pag_web VARCHAR(100) NOT NULL UNIQUE,
   id_pais INT,
   id_asoc_nac INT,
   CONSTRAINT id_pais FOREIGN KEY(id_pais) REFERENCES VAM_PAISES(id),
   CONSTRAINT id_asociacion FOREIGN KEY(id_asoc_nac) REFERENCES VAM_ASOC_NACIONALES(id) ON DELETE SET NULL
);

CREATE TABLE VAM_FORMA_ENVIOS(
   id SERIAL,
   id_prov INT,
   id_pais INT,
   tipo CHAR(1) NOT NULL CHECK(tipo = 'm' OR tipo = 'a' OR tipo = 'a'),
   cargo NUMERIC(5,2) NOT NULL,
   id_pais INT,
   CONSTRAINT id_prov FOREIGN KEY(id_prov) REFERENCES VAM_PROVEEDORES(id) ON DELETE CASCADE,
   CONSTRAINT id_pais FOREIGN KEY(id_pais) REFERENCES VAM_PAISES(id) ON DELETE CASCADE,
   CONSTRAINT pk_envio_pais_prov PRIMARY KEY(id, id_prov, id_pais)
);

CREATE TABLE VAM_FORMA_PAGOS(
   id SERIAL,
   id_prov INT,
   tipo CHAR(4) NOT NULL CHECK(tipo = 'cont' OR tipo = 'cred'),
   porc_inicial NUMERIC(5,2),
   nro_cuotas NUMERIC(3),
   interes_mensual NUMERIC(5,2),
   nro_dia_entre_pago NUMERIC(3),
   CONSTRAINT id_prov FOREIGN KEY(id_prov) REFERENCES VAM_PROVEEDORES(id) ON DELETE CASCADE,
   CONSTRAINT pk_pago_prov PRIMARY KEY(id, id_prov)
);

CREATE TABLE VAM_INGREDIENTE_ESENCIAS(
   cas NUMERIC(12),
   id_prov INT,
   nombre VARCHAR(50) NOT NULL,
   tipo CHAR(1) NOT NULL CHECK(tipo = 'n' OR tipo = 'q'),
   descripcion VARCHAR(400) NOT NULL,
   taxonomia VARCHAR(50) NOT NULL,
   punto_ebul NUMERIC(4),
   punto_inflam NUMERIC(4),
   proc_extrac VARCHAR(400),
   descrip_proceso VARCHAR(400),
   CONSTRAINT id_prov FOREIGN KEY(id_prov) REFERENCES VAM_PROVEEDORES(id) ON DELETE CASCADE,
   CONSTRAINT pk_ingred PRIMARY KEY(cas, id_prov)
);

CREATE TABLE VAM_CONTRATOS(
   id SERIAL,
   id_prov INT,
   id_prod INT,
   fecha_emision DATE NOT NULL,
   exclusividad BOOLEAN NOT NULL DEFAULT FALSE,
   clausula VARCHAR(1000),
   fecha_cancelacion DATE,
   motivo_cancel VARCHAR(400),
   quien_cancela VARCHAR(50),
   CONSTRAINT id_prov FOREIGN KEY(id_prov) REFERENCES VAM_PROVEEDORES(id) ON DELETE CASCADE,
   CONSTRAINT id_prod FOREIGN KEY(id_prod) REFERENCES VAM_PRODUCTORES(id) ON DELETE CASCADE,
   CONSTRAINT pk_contrato PRIMARY KEY(id,id_prov,id_prod)
);

CREATE TABLE VAM_RENOVACIONES(
   id SERIAL,
   id_contrato INT,
   id_cont_prov INT,
   id_cont_prod INT,
   fecha DATE NOT NULL,
   CONSTRAINT fk_renov FOREIGN KEY(id_contrato, id_prov, id_prod) REFERENCES VAM_CONTRATOS(id, id_prov, id_prod) ON DELETE CASCADE,
   CONSTRAINT pk_renov PRIMARY KEY(id, id_contrato, id_cont_prov, id_cont_prod)
);

CREATE TABLE VAM_PEDIDOS(
   id SERIAL PRIMARY KEY,
   f_emision DATE NOT NULL,
   estado CHAR(4) NOT NULL,
   f_confirmacion DATE NOT NULL,
   id_prov INT,
   id_prod INT,
   motivo_cancel VARCHAR(400),
   nro_factura NUMERIC(3) UNIQUE,
   total_usd NUMERIC(9,2),
   CONSTRAINT check_estado CHECK(estado in ('a','p','anpv','anpd')),
   CONSTRAINT id_prov FOREIGN KEY(id_prov) REFERENCES VAM_PROVEEDORES(id),
   CONSTRAINT id_prod FOREIGN KEY(id_prod) REFERENCES VAM_PRODUCTORES(id),
);

CREATE TABLE PAGOS(
   id SERIAL,
   id_pedido INT,
   fecha DATE NOT NULL,
   monto NUMERIC(9,2) NOT NULL,
   CONSTRAINT id_pedido FOREIGN KEY(id_pedido) REFERENCES VAM_PEDIDOS(id) ON DELETE CASCADE,
   CONSTRAINT pk_pedido PRIMARY KEY(id,id_ped)
);


--POR REVISAR
CREATE TABLE VAM_MP_C(
   id_contrato INT,
   id_cont_prov INT,
   id_cont_prod INT,
   cas NUMERIC(12),
   id_prov_ing INT,
   CONSTRAINT fk_contrato FOREIGN KEY(id_contrato, id_cont_prov, id_cont_prod) REFERENCES VAM_CONTRATOS(id, id_prov, id_prod) ON DELETE CASCADE,
   CONSTRAINT fk_ingred FOREIGN KEY(cas, id_prov_ing) REFERENCES VAM_INGREDIENTE_ESENCIAS(cas, id_prov) ON DELETE CASCADE,
   CONSTRAINT pk_mp_c PRIMARY KEY(id_contrato, id_cont_prov, id_cont_prod, cas, id_prov_ing)
);

--POR REVISAR
CREATE TABLE VAM_FE_FP_C(
   id SERIAL,
   id_contrato INT,
   id_form_pago INT,
   id_prov_fp INT,
   id_form_envio INT,
   id_prov_fe INT,
   id_form_envio_pais INT,
   CONSTRAINT fk_contrato FOREIGN KEY(id_contrato, id_prov_c, id_prod) REFERENCES VAM_CONTRATOS(id, id_prov, id_prod) ON DELETE CASCADE,
   CONSTRAINT pk_fe_fp_c PRIMARY KEY(id_contrato, id_prov_c, id_prod),
   CONSTRAINT fk_fp FOREIGN KEY(id_fp) REFERENCES VAM_FORMA_PAGOS(id),
   CONSTRAINT fk_fe FOREIGN KEY(id_fe, id_prov_fe, id_pais) REFERENCES VAM_FORMA_ENVIOS(id,id_prov,id_pais)
);
