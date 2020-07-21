-- SIN FKS SEGUN ORDEN
CREATE TABLE VAM_MP_PROHIBIDAS(
   cas INTEGER PRIMARY KEY,
   nombre VARCHAR(80) NOT NULL
);

CREATE TABLE VAM_ESENCIAS_PERF(
   tsca_cas NUMERIC(10) PRIMARY KEY,
   nombre VARCHAR(20) NOT NULL UNIQUE,
   tipo CHAR(1) NOT NULL,
   descripcion VARCHAR(400) NOT NULL,
   CONSTRAINT check_tipo CHECK(tipo in ('n','s'))
);

DROP SEQUENCE IF EXISTS sec_VAM_PERFUMES;
CREATE SEQUENCE sec_VAM_PERFUMES
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;

CREATE TABLE VAM_PERFUMES(
   id SMALLINT DEFAULT nextval('sec_VAM_PERFUMES') PRIMARY KEY,
   nombre VARCHAR(20) NOT NULL,
   genero CHAR(1) NOT NULL,
   rango_edad CHAR(3) NOT NULL,
   descrip_componentes VARCHAR(400) NOT NULL,
   tipo_estructura CHAR(1) NOT NULL,
   descrip_perf VARCHAR(400),
   CONSTRAINT check_genero CHECK(genero in ('m','f','u')),
   CONSTRAINT check_rgo_edad CHECK(rango_edad in ('inf','juv','adu','ate')),
   CONSTRAINT check_tipo_est CHECK(tipo_estructura in ('m','f'))
);

DROP SEQUENCE IF EXISTS sec_VAM_FLIA_OLFAT;
CREATE SEQUENCE sec_VAM_FLIA_OLFAT
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;

CREATE TABLE VAM_FLIA_OLFAT(
    id SMALLINT DEFAULT nextval('sec_VAM_FLIA_OLFAT') PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL
);

DROP SEQUENCE IF EXISTS sec_VAM_VAR_CRITERIOS;
CREATE SEQUENCE sec_VAM_VAR_CRITERIOS
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;

CREATE TABLE VAM_VAR_CRITERIOS(
    id SMALLINT DEFAULT nextval('sec_VAM_VAR_CRITERIOS') PRIMARY KEY,
    nombre_crit VARCHAR(40) NOT NULL,
    descripcion VARCHAR(400) NOT NULL
);

DROP SEQUENCE IF EXISTS sec_VAM_OTROS_ING_COMP;
CREATE SEQUENCE sec_VAM_OTROS_ING_COMP
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;

CREATE TABLE VAM_OTROS_ING_COMP(
    id SMALLINT DEFAULT nextval('sec_VAM_OTROS_ING_COMP') PRIMARY KEY,
    nombre VARCHAR(40) NOT NULL
);

DROP SEQUENCE IF EXISTS sec_VAM_PALABRA_CLAVE;
CREATE SEQUENCE sec_VAM_PALABRA_CLAVE
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;

CREATE TABLE VAM_PALABRA_CLAVE(
    id SMALLINT DEFAULT nextval('sec_VAM_PALABRA_CLAVE') PRIMARY KEY,
    palabra VARCHAR(40) NOT NULL
);

DROP SEQUENCE IF EXISTS sec_VAM_ASOC_NACIONALES;
CREATE SEQUENCE sec_VAM_ASOC_NACIONALES
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 300;

CREATE TABLE VAM_ASOC_NACIONALES(
   id SMALLINT DEFAULT nextval('sec_VAM_ASOC_NACIONALES') PRIMARY KEY,
   nombre VARCHAR(20) NOT NULL UNIQUE,
   region CHAR(2) NOT NULL,
   descripcion VARCHAR(400),
   CONSTRAINT check_asoc CHECK( region in ('ap','eu','la','na'))
);

-- CON FK SEGUN ORDEN

CREATE TABLE VAM_MONOLITICO(
    id_esencia_perf NUMERIC(10) NOT NULL,
    id_perf SMALLINT NOT NULL,
    CONSTRAINT fk_esencia FOREIGN KEY (id_esencia_perf) REFERENCES VAM_ESENCIAS_PERF(tsca_cas) ON DELETE CASCADE,
    CONSTRAINT fk_perf FOREIGN KEY (id_perf) REFERENCES VAM_PERFUMES(id) ON DELETE CASCADE,
    CONSTRAINT pk_monolitico PRIMARY KEY (id_esencia_perf, id_perf)
);

DROP SEQUENCE IF EXISTS sec_VAM_NOTAS_PERFUMES;
CREATE SEQUENCE sec_VAM_NOTAS_PERFUMES
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;

CREATE TABLE VAM_NOTAS_PERFUMES(
   id SMALLINT DEFAULT nextval('sec_VAM_NOTAS_PERFUMES'),
   id_perf SMALLINT,
   id_esencia_perf NUMERIC(10),
   tipo_nota CHAR(1),
   CONSTRAINT check_tipo CHECK(tipo_nota in ('s','c','f')),
   CONSTRAINT fk_perf FOREIGN KEY(id_perf) REFERENCES VAM_PERFUMES(id) ON DELETE CASCADE,
   CONSTRAINT fk_esencia FOREIGN KEY(id_esencia_perf) REFERENCES VAM_ESENCIAS_PERF(tsca_cas) ON DELETE CASCADE,
   CONSTRAINT pk_notas_perf PRIMARY KEY(id,id_perf,id_esencia_perf)
);

CREATE TABLE VAM_FO_PRINCIPAL(
    id_flia_olf SMALLINT,
    id_perf SMALLINT,
    CONSTRAINT fk_flia_olf FOREIGN KEY(id_flia_olf) REFERENCES VAM_FLIA_OLFAT(id) ON DELETE CASCADE,
    CONSTRAINT fk_perf FOREIGN KEY(id_perf) REFERENCES VAM_PERFUMES(id) ON DELETE CASCADE,
    CONSTRAINT pk_fliof_prin PRIMARY KEY(id_flia_olf, id_perf)
);

DROP SEQUENCE IF EXISTS sec_VAM_PERF_INTENSIDADES;
CREATE SEQUENCE sec_VAM_PERF_INTENSIDADES
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;

CREATE TABLE VAM_PERF_INTENSIDADES(
    id SMALLINT DEFAULT nextval('sec_VAM_PERF_INTENSIDADES'),
    id_perfume SMALLINT,
    tipo CHAR(3) NOT NULL,
    porc_concentracion NUMERIC(3),
    descripcion VARCHAR(400),
    CONSTRAINT check_tipo_perf CHECK(tipo IN ('p','edp','edt','edc','eds')),
    CONSTRAINT fk_perf FOREIGN KEY (id_perfume) REFERENCES VAM_PERFUMES(id) ON DELETE CASCADE,
    CONSTRAINT pk_perf_intensidades PRIMARY KEY (id,id_perfume)
);

DROP SEQUENCE IF EXISTS sec_VAM_PRESENTACIONES;
CREATE SEQUENCE sec_VAM_PRESENTACIONES
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;

CREATE TABLE VAM_PRESENTACIONES(
    id SMALLINT DEFAULT nextval('sec_VAM_PRESENTACIONES'),
    id_perf_intensidad SMALLINT,
    id_perf SMALLINT,
    volumen NUMERIC (3) NOT NULL,
    CONSTRAINT fk_perf_pre FOREIGN KEY (id_perf_intensidad,id_perf) REFERENCES VAM_PERF_INTENSIDADES(id, id_perfume) ON DELETE CASCADE,
    CONSTRAINT pk_perf_pre PRIMARY KEY (id, id_perf_intensidad, id_perf)
);

CREATE TABLE VAM_INGRED_FLIA_OLF(
    id_flia_olf SMALLINT,
    id_esencia_perf NUMERIC(10),
    CONSTRAINT fk_flia_olf_ingred FOREIGN KEY (id_flia_olf) REFERENCES VAM_FLIA_OLFAT(id) ON DELETE CASCADE,
    CONSTRAINT fk_esencia_ingred FOREIGN KEY (id_esencia_perf) REFERENCES VAM_ESENCIAS_PERF(tsca_cas) ON DELETE CASCADE,
    CONSTRAINT pf_ingred_flia_olf PRIMARY KEY (id_flia_olf, id_esencia_perf)
);

CREATE TABLE VAM_F_FN(
    id_flia_olf SMALLINT,
    id_palabra_clave SMALLINT,
    CONSTRAINT fk_flia_olf_f_fn FOREIGN KEY (id_flia_olf) REFERENCES VAM_FLIA_OLFAT(id) ON DELETE CASCADE,
    CONSTRAINT fk_palabra_clave FOREIGN KEY (id_palabra_clave) REFERENCES VAM_PALABRA_CLAVE(id) ON DELETE CASCADE,
    CONSTRAINT pk_f_fn PRIMARY KEY (id_flia_olf, id_palabra_clave)
);

DROP SEQUENCE IF EXISTS sec_VAM_PRODUCTORES;
CREATE SEQUENCE sec_VAM_PRODUCTORES
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;

CREATE TABLE VAM_PRODUCTORES(
   id SMALLINT DEFAULT nextval('sec_VAM_PRODUCTORES') PRIMARY KEY,
   nombre VARCHAR(50) NOT NULL UNIQUE,
   email VARCHAR(50) NOT NULL UNIQUE,
   telefono NUMERIC(12) NOT NULL UNIQUE,
   pag_web VARCHAR(100) NOT NULL UNIQUE,
   id_asoc_nac SMALLINT,
   CONSTRAINT fk_id_asociacion FOREIGN KEY(id_asoc_nac) REFERENCES VAM_ASOC_NACIONALES(id) ON DELETE SET NULL
);

CREATE TABLE VAM_ESCALAS(
    fecha_inicio DATE,
    id_prod SMALLINT,
    valor_min NUMERIC(3) NOT NULL,
    valor_max NUMERIC(3) NOT NULL,
    fecha_fin DATE,
    CONSTRAINT fk_id_prov_escalas FOREIGN KEY (id_prod) REFERENCES VAM_PRODUCTORES(id) ON DELETE CASCADE,
    CONSTRAINT pk_escalas PRIMARY KEY (fecha_inicio, id_prod)
);

DROP SEQUENCE IF EXISTS sec_VAM_PAISES;
CREATE SEQUENCE sec_VAM_PAISES
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 300;

CREATE TABLE VAM_PAISES(
   id SMALLINT DEFAULT nextval('sec_VAM_PAISES') PRIMARY KEY,
   nombre VARCHAR(56) NOT NULL UNIQUE,
   continente CHAR(2) NOT NULL,
   id_asoc_nac SMALLINT,
   CONSTRAINT check_cont CHECK(continente in ('am', 'e', 'af', 'as', 'o')),
   CONSTRAINT fk_asoc_paises FOREIGN KEY(id_asoc_nac) REFERENCES VAM_ASOC_NACIONALES(id) ON DELETE SET NULL
);

DROP SEQUENCE IF EXISTS sec_VAM_PROVEEDORES;
CREATE SEQUENCE sec_VAM_PROVEEDORES
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;

CREATE TABLE VAM_PROVEEDORES(
   id SMALLINT DEFAULT nextval('sec_VAM_PROVEEDORES') PRIMARY KEY,
   nombre VARCHAR(60) NOT NULL UNIQUE,
   email VARCHAR(50) NOT NULL UNIQUE,
   telefono NUMERIC(12) NOT NULL UNIQUE,
   pag_web VARCHAR(100) NOT NULL UNIQUE,
   id_pais SMALLINT NOT NULL,
   id_asoc_nac SMALLINT,
   CONSTRAINT fk_prov_pais FOREIGN KEY(id_pais) REFERENCES VAM_PAISES(id) ON DELETE SET NULL,
   CONSTRAINT fk_asociacion_prov FOREIGN KEY(id_asoc_nac) REFERENCES VAM_ASOC_NACIONALES(id) ON DELETE SET NULL
);

DROP SEQUENCE IF EXISTS sec_VAM_PEFUMISTAS;
CREATE SEQUENCE sec_VAM_PEFUMISTAS
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;

CREATE TABLE VAM_PEFUMISTAS(
    id SMALLINT DEFAULT nextval('sec_VAM_PEFUMISTAS') PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    id_pais SMALLINT NOT NULL,
    CONSTRAINT fk_perfumista_pais FOREIGN KEY (id_pais) REFERENCES VAM_PAISES(id) ON DELETE SET NULL
);

CREATE TABLE VAM_P_P(
    id_perfumista SMALLINT,
    id_perfume SMALLINT,
    CONSTRAINT fk_perfumista_p_p FOREIGN KEY (id_perfumista) REFERENCES VAM_PEFUMISTAS(id),
    CONSTRAINT fk_perfume_p_p FOREIGN KEY (id_perfume) REFERENCES VAM_PERFUMES(id),
    CONSTRAINT pk_p_p PRIMARY KEY (id_perfumista, id_perfume)
);

CREATE TABLE VAM_PA_PR(
    id_productor SMALLINT,
    id_pais SMALLINT,
    CONSTRAINT fk_prod FOREIGN KEY (id_productor) REFERENCES VAM_PRODUCTORES(id) ON DELETE CASCADE,
    CONSTRAINT fk_pais FOREIGN KEY (id_pais) REFERENCES VAM_PAISES(id) ON DELETE CASCADE,
    CONSTRAINT pk_prod_pa PRIMARY KEY (id_productor, id_pais)
);

CREATE TABLE VAM_PR_FE(
    id_productor SMALLINT,
    id_perfume SMALLINT,
    CONSTRAINT fk_prod FOREIGN KEY (id_productor) REFERENCES VAM_PRODUCTORES(id) ON DELETE CASCADE,
    CONSTRAINT fk_perfume FOREIGN KEY (id_perfume) REFERENCES VAM_PERFUMES(id) ON DELETE CASCADE,
    CONSTRAINT pk_pr_pe PRIMARY KEY (id_productor, id_perfume)
);

CREATE TABLE VAM_RESULT_EVAL(
    fecha DATE,
    id_prod SMALLINT,
    id_prov SMALLINT,
    resultado NUMERIC(3) NOT NULL,
    tipo_eval CHAR(1) NOT NULL,
    CONSTRAINT check_tipo_eval CHECK (tipo_eval in ('i','r')),
    CONSTRAINT fk_prod_eval FOREIGN KEY (id_prod) REFERENCES VAM_PRODUCTORES(id) ON DELETE CASCADE,
    CONSTRAINT fk_prov_eval FOREIGN KEY (id_prov) REFERENCES VAM_PROVEEDORES(id) ON DELETE CASCADE,
    CONSTRAINT pk_result_eval PRIMARY KEY (fecha, id_prod, id_prov)
);

DROP SEQUENCE IF EXISTS sec_VAM_FORMA_ENVIOS;
CREATE SEQUENCE sec_VAM_FORMA_ENVIOS
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;

CREATE TABLE VAM_FORMA_ENVIOS(
   id SMALLINT DEFAULT nextval('sec_VAM_FORMA_ENVIOS'),
   id_prov SMALLINT,
   id_pais SMALLINT,
   tipo CHAR(1) NOT NULL,
   cargo NUMERIC(3) NOT NULL,
   CONSTRAINT check_tipo_envio CHECK (tipo in('m','a','t')),
   CONSTRAINT id_prov FOREIGN KEY(id_prov) REFERENCES VAM_PROVEEDORES(id) ON DELETE CASCADE,
   CONSTRAINT id_pais FOREIGN KEY(id_pais) REFERENCES VAM_PAISES(id) ON DELETE CASCADE,
   CONSTRAINT pk_envio_pais_prov PRIMARY KEY(id, id_prov, id_pais)
);

DROP SEQUENCE IF EXISTS sec_VAM_FORMA_PAGOS;
CREATE SEQUENCE sec_VAM_FORMA_PAGOS
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;

CREATE TABLE VAM_FORMA_PAGOS(
   id SMALLINT DEFAULT nextval('sec_VAM_FORMA_PAGOS'),
   id_proveedor SMALLINT,
   tipo CHAR(4) NOT NULL,
   porc_inicial NUMERIC(3),
   nro_cuotas NUMERIC(2),
   interes_mensual NUMERIC(3),
   nro_dia_entre_pago NUMERIC(2),
   CONSTRAINT check_tipo_pago CHECK (tipo in ('cont','cred')),
   CONSTRAINT id_proveedor FOREIGN KEY(id_proveedor) REFERENCES VAM_PROVEEDORES(id) ON DELETE CASCADE,
   CONSTRAINT pk_pago_prov PRIMARY KEY(id, id_proveedor)
);

DROP SEQUENCE IF EXISTS sec_VAM_HISTORICO_IFRA;
CREATE SEQUENCE sec_VAM_HISTORICO_IFRA
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;

CREATE TABLE VAM_HISTORICO_IFRA(
    id SMALLINT DEFAULT nextval('sec_VAM_HISTORICO_IFRA'),
    fecha_inicio DATE,
    id_proveedor SMALLINT,
    id_productor SMALLINT,
    fecha_fin DATE,
    CONSTRAINT fk_prov_ifra FOREIGN KEY (id_proveedor) REFERENCES VAM_PROVEEDORES(id) ON DELETE CASCADE,
    CONSTRAINT fk_prod_ifra FOREIGN KEY (id_productor) REFERENCES VAM_PRODUCTORES(id) ON DELETE CASCADE,
    CONSTRAINT pk_hist_ifra PRIMARY KEY (id, fecha_inicio)
);

DROP SEQUENCE IF EXISTS sec_VAM_PEDIDOS;
CREATE SEQUENCE sec_VAM_PEDIDOS
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;

CREATE TABLE VAM_PEDIDOS(
   id SMALLINT DEFAULT nextval('sec_VAM_PEDIDOS') PRIMARY KEY,
   f_emision DATE NOT NULL,
   estado CHAR(4) NOT NULL,
   id_prov SMALLINT NOT NULL,
   id_prod SMALLINT NOT NULL,
   subtotal_usd NUMERIC(9,2) NOT NULL,
   total_usd NUMERIC(9,2) NOT NULL,
   f_confirmacion DATE,
   motivo_cancel VARCHAR(400),
   nro_factura NUMERIC(7),
   CONSTRAINT check_estado CHECK(estado in ('a','p','anpv','anpd')),
   CONSTRAINT fk_id_prov FOREIGN KEY(id_prov) REFERENCES VAM_PROVEEDORES(id) ON DELETE SET NULL,
   CONSTRAINT fk_id_prod FOREIGN KEY(id_prod) REFERENCES VAM_PRODUCTORES(id) ON DELETE SET NULL
);

DROP SEQUENCE IF EXISTS sec_VAM_PAGOS;
CREATE SEQUENCE sec_VAM_PAGOS
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;

CREATE TABLE VAM_PAGOS(
   id SMALLINT DEFAULT nextval('sec_VAM_PAGOS'),
   id_pedido SMALLINT,
   fecha DATE NOT NULL,
   monto NUMERIC(9,2) NOT NULL,
   CONSTRAINT fk_id_pedido FOREIGN KEY(id_pedido) REFERENCES VAM_PEDIDOS(id) ON DELETE CASCADE,
   CONSTRAINT pk_pago PRIMARY KEY(id,id_pedido)
);

CREATE TABLE VAM_INGREDIENTE_ESENCIAS(
   cas NUMERIC(10),
   id_proveedor SMALLINT,
   nombre VARCHAR(50) NOT NULL,
   tipo CHAR(1) NOT NULL,
   descripcion VARCHAR(400) NOT NULL,
   taxonomia VARCHAR(60) NOT NULL,
   punto_ebul NUMERIC(4),
   punto_inflam NUMERIC(4),
   proc_extrac VARCHAR(400),
   descrip_proceso VARCHAR(400),
   CONSTRAINT check_tipo_ing CHECK (tipo in ('n','q')),
   CONSTRAINT check_proc_extrac CHECK (proc_extrac IN ('e','f','m','d')),
   CONSTRAINT id_proveedor FOREIGN KEY(id_proveedor) REFERENCES VAM_PROVEEDORES(id) ON DELETE CASCADE,
   CONSTRAINT pk_ingrediente PRIMARY KEY(cas, id_proveedor)
);

DROP SEQUENCE IF EXISTS sec_VAM_ING_PRESENTACIONES;
CREATE SEQUENCE sec_VAM_ING_PRESENTACIONES
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;

CREATE TABLE VAM_ING_PRESENTACIONES(
    id SMALLINT DEFAULT nextval('sec_VAM_ING_PRESENTACIONES'),
    cas_ingrediente NUMERIC(10),
    id_proveedor SMALLINT,
    volumen NUMERIC(6) NOT NULL,
    precio NUMERIC(9,2) NOT NULL,
    CONSTRAINT fk_ing_presentacion FOREIGN KEY (cas_ingrediente, id_proveedor) REFERENCES VAM_INGREDIENTE_ESENCIAS (cas, id_proveedor) ON DELETE CASCADE,
    CONSTRAINT pk_ing_presentacion PRIMARY KEY (id, cas_ingrediente, id_proveedor)
);

DROP SEQUENCE IF EXISTS sec_VAM_CONTRATOS;
CREATE SEQUENCE sec_VAM_CONTRATOS
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;

CREATE TABLE VAM_CONTRATOS(
   id SMALLINT DEFAULT nextval('sec_VAM_CONTRATOS'),
   id_prov SMALLINT,
   id_prod SMALLINT,
   fecha_emision DATE NOT NULL,
   exclusividad BOOLEAN NOT NULL DEFAULT FALSE,
   clausula VARCHAR(1000),
   fecha_cancelacion DATE,
   motivo_cancel VARCHAR(400),
   quien_cancela VARCHAR(4),
   CONSTRAINT check_quien_cancela CHECK (quien_cancela in ('prov', 'prod')),
   CONSTRAINT fk_prov_cont FOREIGN KEY(id_prov) REFERENCES VAM_PROVEEDORES(id) ON DELETE CASCADE,
   CONSTRAINT fk_prod_cont FOREIGN KEY(id_prod) REFERENCES VAM_PRODUCTORES(id) ON DELETE CASCADE,
   CONSTRAINT pk_contrato PRIMARY KEY(id,id_prov,id_prod)
);

CREATE TABLE VAM_MP_C(
   id_contrato SMALLINT,
   id_cont_prov SMALLINT,
   id_cont_prod SMALLINT,
   cas NUMERIC(10),
   id_prov_ing SMALLINT,
   CONSTRAINT fk_contrato_mp FOREIGN KEY(id_contrato, id_cont_prov, id_cont_prod) REFERENCES VAM_CONTRATOS(id, id_prov, id_prod) ON DELETE CASCADE,
   CONSTRAINT fk_ingred_cont FOREIGN KEY(cas, id_prov_ing) REFERENCES VAM_INGREDIENTE_ESENCIAS(cas, id_proveedor) ON DELETE CASCADE,
   CONSTRAINT pk_mp_c PRIMARY KEY(id_contrato, id_cont_prov, id_cont_prod, cas, id_prov_ing)
);

DROP SEQUENCE IF EXISTS sec_VAM_FE_FP_C;
CREATE SEQUENCE sec_VAM_FE_FP_C
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;

CREATE TABLE VAM_FE_FP_C(
    id SMALLINT DEFAULT nextval('sec_VAM_FE_FP_C'),
    id_contrato SMALLINT,
    id_prov_cont SMALLINT,
    id_prod_cont SMALLINT,
    id_form_pago SMALLINT,
    id_prov_fp SMALLINT,
    id_form_envio SMALLINT,
    id_prov_fe SMALLINT,
    id_form_envio_pais SMALLINT,
    CONSTRAINT fk_contrato FOREIGN KEY (id_contrato, id_prov_cont, id_prod_cont) REFERENCES VAM_CONTRATOS(id, id_prov, id_prod) /*ON DELETE CASCADE*/,
    CONSTRAINT fk_fp_cont FOREIGN KEY (id_form_pago, id_prov_fp) REFERENCES VAM_FORMA_PAGOS(id, id_proveedor) /*ON DELETE CASCADE*/,
    CONSTRAINT fk_fe_cont FOREIGN KEY (id_form_envio, id_prov_fe, id_form_envio_pais) REFERENCES VAM_FORMA_ENVIOS(id, id_prov, id_pais) /*ON DELETE CASCADE*/,
    CONSTRAINT pk_fe_fp_cont PRIMARY KEY (id, id_contrato, id_prov_cont, id_prod_cont)
);

CREATE TABLE VAM_COND_PEDIDO(
    id_pedido SMALLINT,
    id_cond SMALLINT,
    id_contrato SMALLINT,
    id_cont_prov SMALLINT,
    id_cont_prod SMALLINT,
    CONSTRAINT fk_pedido_con FOREIGN KEY (id_pedido) REFERENCES VAM_PEDIDOS(id) ON DELETE CASCADE,
    CONSTRAINT fk_cond_contr FOREIGN KEY (id_cond, id_contrato, id_cont_prov, id_cont_prod) REFERENCES VAM_FE_FP_C(id, id_contrato, id_prov_cont, id_prod_cont) ON DELETE CASCADE,
    CONSTRAINT pk_cond_pedido PRIMARY KEY (id_pedido, id_cond, id_contrato, id_cont_prov, id_cont_prod)
);

DROP SEQUENCE IF EXISTS sec_VAM_RENOVACIONES;
CREATE SEQUENCE sec_VAM_RENOVACIONES
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;

CREATE TABLE VAM_RENOVACIONES(
   id SMALLINT DEFAULT nextval('sec_VAM_RENOVACIONES'),
   id_contrato SMALLINT,
   id_cont_prov SMALLINT,
   id_cont_prod SMALLINT,
   fecha DATE NOT NULL,
   CONSTRAINT fk_renov_cont FOREIGN KEY(id_contrato, id_cont_prov, id_cont_prod) REFERENCES VAM_CONTRATOS(id, id_prov, id_prod) ON DELETE CASCADE,
   CONSTRAINT pk_renov PRIMARY KEY(id, id_contrato, id_cont_prov, id_cont_prod)
);

CREATE TABLE VAM_EVAL_CRITERIOS(
    fecha_inicio DATE,
    id_prod SMALLINT,
    id_var_crit SMALLINT,
    peso NUMERIC(3) NOT NULL,
    tipo_formula CHAR(1) NOT NULL,
    fecha_fin DATE,
    CONSTRAINT check_tipo CHECK(tipo_formula in ('i','r')),
    CONSTRAINT fk_prod_criterios FOREIGN KEY (id_prod) REFERENCES VAM_PRODUCTORES(id) ON DELETE CASCADE,
    CONSTRAINT fk_var_criterio FOREIGN KEY (id_var_crit) REFERENCES VAM_VAR_CRITERIOS(id) ON DELETE CASCADE,
    CONSTRAINT pk_eval_criterio PRIMARY KEY (fecha_inicio, id_prod, id_var_crit)
);

CREATE TABLE VAM_ING_ORIGEN(
    id_ing_esenc NUMERIC(10),
    id_ing_esenc_prov SMALLINT,
    id_pais SMALLINT,
    CONSTRAINT fk_origen_ing FOREIGN KEY (id_ing_esenc, id_ing_esenc_prov) REFERENCES VAM_INGREDIENTE_ESENCIAS(cas, id_proveedor) ON DELETE CASCADE,
    CONSTRAINT fk_pais_origen FOREIGN KEY (id_pais) REFERENCES VAM_PAISES(id) ON DELETE CASCADE,
    CONSTRAINT pk_ing_origen PRIMARY KEY (id_ing_esenc, id_ing_esenc_prov, id_pais)
);

CREATE TABLE VAM_ING_OTROS(
    id_ing NUMERIC(10),
    id_prov SMALLINT,
    id_otro SMALLINT,
    CONSTRAINT fk_ing_prov FOREIGN KEY (id_ing, id_prov) REFERENCES VAM_INGREDIENTE_ESENCIAS(cas, id_proveedor) ON DELETE CASCADE,
    CONSTRAINT fk_otro_ing FOREIGN KEY (id_otro) REFERENCES VAM_OTROS_ING_COMP(id) ON DELETE CASCADE,
    CONSTRAINT pk_ing_otro PRIMARY KEY (id_ing, id_prov, id_otro)
);

DROP SEQUENCE IF EXISTS sec_VAM_DET_PEDIDO;
CREATE SEQUENCE sec_VAM_DET_PEDIDO
    AS SMALLINT
    MINVALUE 1
    MAXVALUE 32767;

CREATE TABLE VAM_DET_PEDIDO(
    id SMALLINT DEFAULT nextval('sec_VAM_DET_PEDIDO'),
    id_pedido SMALLINT,
    cantidad NUMERIC(6) NOT NULL,
    id_ing_presentacion SMALLINT,
    cas_ingrediente NUMERIC(10),
    id_prov_ing SMALLINT,
    CONSTRAINT fk_det_pedido FOREIGN KEY (id_pedido) REFERENCES VAM_PEDIDOS(id) ON DELETE CASCADE,
    CONSTRAINT fk_det_ing FOREIGN KEY (id_ing_presentacion, cas_ingrediente, id_prov_ing) REFERENCES VAM_ING_PRESENTACIONES(id, cas_ingrediente, id_proveedor),
    CONSTRAINT pk_det_pedido PRIMARY KEY (id, id_pedido)
);

CREATE TABLE VAM_FLIA_IE(
    id_flia_olfat SMALLINT,
    id_ing_esencia NUMERIC(10),
    id_ing_prov SMALLINT,
    CONSTRAINT fk_flia_olf_ing FOREIGN KEY (id_flia_olfat) REFERENCES VAM_FLIA_OLFAT(id) ON DELETE CASCADE,
    CONSTRAINT fk_ing_ese FOREIGN KEY (id_ing_esencia, id_ing_prov) REFERENCES VAM_INGREDIENTE_ESENCIAS(cas, id_proveedor) ON DELETE CASCADE,
    CONSTRAINT pk_flia_ie PRIMARY KEY (id_flia_olfat, id_ing_esencia, id_ing_prov)
);