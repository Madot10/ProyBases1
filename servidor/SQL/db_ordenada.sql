-- SIN FKS SEGUN ORDEN
CREATE TABLE VAM_MP_PROHIBIDAS(
   cas INTEGER PRIMARY KEY,
   nombre VARCHAR(50) NOT NULL
);

CREATE TABLE VAM_ESENCIAS_PERF(
   tsca_cas INTEGER PRIMARY KEY,
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
   CONSTRAINT check_tipo_est CHECK(tipo_estructura in ('m','f'))
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

CREATE TABLE VAM_MONOLITICO(
    id_esencia_perf INTEGER NOT NULL,
    id_perf INTEGER NOT NULL,
    CONSTRAINT fk_esencia FOREIGN KEY (id_esencia_perf) REFERENCES VAM_ESENCIAS_PERF(tsca_cas) ON DELETE CASCADE,
    CONSTRAINT fk_perf FOREIGN KEY (id_perf) REFERENCES VAM_PERFUMES(id) ON DELETE CASCADE,
    CONSTRAINT pk_monolitico PRIMARY KEY (id_esencia_perf, id_perf)
);

CREATE TABLE VAM_NOTAS_PERFUMES(
   id SERIAL,
   id_perf INTEGER,
   id_esencia_perf INTEGER,
   tipo_nota CHAR(1),
   CONSTRAINT check_tipo CHECK(tipo_nota in ('s','c','f')),
   CONSTRAINT fk_perf FOREIGN KEY(id_perf) REFERENCES VAM_PERFUMES(id) ON DELETE CASCADE,
   CONSTRAINT fk_esencia FOREIGN KEY(id_esencia_perf) REFERENCES VAM_ESENCIAS_PERF(tsca_cas) ON DELETE CASCADE,
   CONSTRAINT pk_notas_perf PRIMARY KEY(id,id_perf,id_esencia_perf)
);

CREATE TABLE VAM_FO_PRINCIPAL(
    id_flia_olf INTEGER,
    id_perf INTEGER,
    CONSTRAINT fk_flia_olf FOREIGN KEY(id_flia_olf) REFERENCES VAM_FLIA_OLFAT(id) ON DELETE CASCADE,
    CONSTRAINT fk_perf FOREIGN KEY(id_perf) REFERENCES VAM_PERFUMES(id) ON DELETE CASCADE,
    CONSTRAINT pk_fliof_prin PRIMARY KEY(id_flia_olf, id_perf)
);

CREATE TABLE VAM_PERF_INTENSIDADES(
    id SERIAL,
    id_perfume INTEGER,
    tipo CHAR(3) NOT NULL,
    porc_concentracion INTEGER,
    descripcion VARCHAR(400),
    CONSTRAINT check_tipo_perf CHECK(tipo IN ('p','edp','edt','edc','eds')),
    CONSTRAINT fk_perf FOREIGN KEY (id_perfume) REFERENCES VAM_PERFUMES(id) ON DELETE CASCADE,
    CONSTRAINT pk_perf_intensidades PRIMARY KEY (id,id_perfume)
);

CREATE TABLE VAM_PRESENTACIONES(
    id SERIAL,
    id_perf_intensidad INTEGER,
    id_perf INTEGER,
    volumen NUMERIC (3) NOT NULL,
    CONSTRAINT fk_perf_pre FOREIGN KEY (id_perf_intensidad,id_perf) REFERENCES VAM_PERF_INTENSIDADES(id, id_perfume) ON DELETE CASCADE,
    CONSTRAINT pk_perf_pre PRIMARY KEY (id, id_perf_intensidad, id_perf)
);

CREATE TABLE VAM_INGRED_FLIA_OLF(
    id_flia_olf INTEGER,
    id_esencia_perf INTEGER,
    CONSTRAINT fk_flia_olf_ingred FOREIGN KEY (id_flia_olf) REFERENCES VAM_FLIA_OLFAT(id) ON DELETE CASCADE,
    CONSTRAINT fk_esencia_ingred FOREIGN KEY (id_esencia_perf) REFERENCES VAM_ESENCIAS_PERF(tsca_cas) ON DELETE CASCADE,
    CONSTRAINT pf_ingred_flia_olf PRIMARY KEY (id_flia_olf, id_esencia_perf)
);

CREATE TABLE VAM_F_FN(
    id_flia_olf INTEGER,
    id_palabra_clave INTEGER,
    CONSTRAINT fk_flia_olf_f_fn FOREIGN KEY (id_flia_olf) REFERENCES VAM_FLIA_OLFAT(id) ON DELETE CASCADE,
    CONSTRAINT fk_palabra_clave FOREIGN KEY (id_palabra_clave) REFERENCES VAM_PALABRA_CLAVE(id) ON DELETE CASCADE,
    CONSTRAINT pk_f_fn PRIMARY KEY (id_flia_olf, id_palabra_clave)
);

CREATE TABLE VAM_PRODUCTORES(
   id SERIAL PRIMARY KEY,
   nombre VARCHAR(50) NOT NULL UNIQUE,
   email VARCHAR(50) NOT NULL UNIQUE,
   telefono NUMERIC(12) NOT NULL UNIQUE,
   pag_web VARCHAR(100) NOT NULL UNIQUE,
   id_asoc_nac INTEGER,
   CONSTRAINT fk_id_asociacion FOREIGN KEY(id_asoc_nac) REFERENCES VAM_ASOC_NACIONALES(id) ON DELETE SET NULL
);

CREATE TABLE VAM_ESCALAS(
    fecha_inicio DATE,
    id_prod INTEGER,
    valor_min NUMERIC(3) NOT NULL,
    valor_max NUMERIC(3) NOT NULL,
    fecha_fin DATE,
    CONSTRAINT fk_id_prov_escalas FOREIGN KEY (id_prod) REFERENCES VAM_PRODUCTORES(id) ON DELETE CASCADE,
    CONSTRAINT pk_escalas PRIMARY KEY (fecha_inicio, id_prod)
);

CREATE TABLE VAM_PAISES(
   id SERIAL PRIMARY KEY,
   nombre VARCHAR(56) NOT NULL UNIQUE,
   continente CHAR(2) NOT NULL,
   id_asoc_nac INTEGER,
   CONSTRAINT check_cont CHECK(continente in ('am', 'e', 'af', 'as', 'o')),
   CONSTRAINT fk_asoc_paises FOREIGN KEY(id_asoc_nac) REFERENCES VAM_ASOC_NACIONALES(id) ON DELETE SET NULL
);

CREATE TABLE VAM_PROVEEDORES(
   id SERIAL PRIMARY KEY,
   nombre VARCHAR(60) NOT NULL UNIQUE,
   email VARCHAR(50) NOT NULL UNIQUE,
   telefono NUMERIC(12) NOT NULL UNIQUE,
   pag_web VARCHAR(100) NOT NULL UNIQUE,
   id_pais INTEGER NOT NULL,
   id_asoc_nac INTEGER,
   CONSTRAINT fk_prov_pais FOREIGN KEY(id_pais) REFERENCES VAM_PAISES(id) ON DELETE SET NULL,
   CONSTRAINT fk_asociacion_prov FOREIGN KEY(id_asoc_nac) REFERENCES VAM_ASOC_NACIONALES(id) ON DELETE SET NULL
);

CREATE TABLE VAM_PEFUMISTAS(
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    id_pais INTEGER NOT NULL,
    CONSTRAINT fk_perfumista_pais FOREIGN KEY (id_pais) REFERENCES VAM_PAISES(id) ON DELETE SET NULL
);

CREATE TABLE VAM_P_P(
    id_perfumista INTEGER,
    id_perfume INTEGER,
    CONSTRAINT fk_perfumista_p_p FOREIGN KEY (id_perfumista) REFERENCES VAM_PEFUMISTAS(id),
    CONSTRAINT fk_perfume_p_p FOREIGN KEY (id_perfume) REFERENCES VAM_PERFUMES(id),
    CONSTRAINT pk_p_p PRIMARY KEY (id_perfumista, id_perfume)
);

CREATE TABLE VAM_PA_PR(
    id_productor INTEGER,
    id_pais INTEGER,
    CONSTRAINT fk_prod FOREIGN KEY (id_productor) REFERENCES VAM_PRODUCTORES(id) ON DELETE CASCADE,
    CONSTRAINT fk_pais FOREIGN KEY (id_pais) REFERENCES VAM_PAISES(id) ON DELETE CASCADE,
    CONSTRAINT pk_prod_pa PRIMARY KEY (id_productor, id_pais)
);

CREATE TABLE VAM_PR_FE(
    id_productor INTEGER,
    id_perfume INTEGER,
    CONSTRAINT fk_prod FOREIGN KEY (id_productor) REFERENCES VAM_PRODUCTORES(id) ON DELETE CASCADE,
    CONSTRAINT fk_perfume FOREIGN KEY (id_perfume) REFERENCES VAM_PERFUMES(id) ON DELETE CASCADE,
    CONSTRAINT pk_pr_pe PRIMARY KEY (id_productor, id_perfume)
);

CREATE TABLE VAM_RESULT_EVAL(
    fecha DATE,
    id_prod INTEGER,
    id_prov INTEGER,
    resultado NUMERIC(2) NOT NULL,
    tipo_eval CHAR(1) NOT NULL, 
    CONSTRAINT check_tipo_eval CHECK (tipo_eval in ('i','r')),
    CONSTRAINT fk_prod_eval FOREIGN KEY (id_prod) REFERENCES VAM_PRODUCTORES(id) ON DELETE CASCADE,
    CONSTRAINT fk_prov_eval FOREIGN KEY (id_prov) REFERENCES VAM_PROVEEDORES(id) ON DELETE CASCADE,
    CONSTRAINT pk_result_eval PRIMARY KEY (fecha, id_prod, id_prov)
);

CREATE TABLE VAM_FORMA_ENVIOS(
   id SERIAL,
   id_prov INTEGER,
   id_pais INTEGER,
   tipo CHAR(1) NOT NULL,
   cargo NUMERIC(3) NOT NULL,
   CONSTRAINT check_tipo_envio CHECK (tipo in('m','a','t')),
   CONSTRAINT id_prov FOREIGN KEY(id_prov) REFERENCES VAM_PROVEEDORES(id) ON DELETE CASCADE,
   CONSTRAINT id_pais FOREIGN KEY(id_pais) REFERENCES VAM_PAISES(id) ON DELETE CASCADE,
   CONSTRAINT pk_envio_pais_prov PRIMARY KEY(id, id_prov, id_pais)
);

CREATE TABLE VAM_FORMA_PAGOS(
   id SERIAL,
   id_proveedor INTEGER,
   tipo CHAR(4) NOT NULL,
   porc_inicial NUMERIC(3),
   nro_cuotas NUMERIC(2),
   interes_mensual NUMERIC(3),
   nro_dia_entre_pago NUMERIC(2),
   CONSTRAINT check_tipo_pago CHECK (tipo in ('cont','cred')),
   CONSTRAINT id_proveedor FOREIGN KEY(id_proveedor) REFERENCES VAM_PROVEEDORES(id) ON DELETE CASCADE,
   CONSTRAINT pk_pago_prov PRIMARY KEY(id, id_proveedor)
);

CREATE TABLE VAM_HISTORICO_IFRA(
    id SERIAL,
    fecha_inicio DATE,
    id_proveedor INTEGER,
    id_productor INTEGER,
    fecha_fin DATE,
    CONSTRAINT fk_prov_ifra FOREIGN KEY (id_proveedor) REFERENCES VAM_PROVEEDORES(id) ON DELETE CASCADE,
    CONSTRAINT fk_prod_ifra FOREIGN KEY (id_productor) REFERENCES VAM_PRODUCTORES(id) ON DELETE CASCADE,
    CONSTRAINT pk_hist_ifra PRIMARY KEY (id, fecha_inicio)
);

CREATE TABLE VAM_PEDIDOS(
   id SERIAL PRIMARY KEY,
   f_emision DATE NOT NULL,
   estado CHAR(4) NOT NULL,
   f_confirmacion DATE NOT NULL,
   id_prov INTEGER NOT NULL,
   id_prod INTEGER NOT NULL,
   motivo_cancel VARCHAR(400),
   nro_factura NUMERIC(7),
   total_usd NUMERIC(9,2),
   CONSTRAINT check_estado CHECK(estado in ('a','p','anpv','anpd')),
   CONSTRAINT fk_id_prov FOREIGN KEY(id_prov) REFERENCES VAM_PROVEEDORES(id) ON DELETE SET NULL,
   CONSTRAINT fk_id_prod FOREIGN KEY(id_prod) REFERENCES VAM_PRODUCTORES(id) ON DELETE SET NULL
);

CREATE TABLE VAM_PAGOS(
   id SERIAL,
   id_pedido INTEGER,
   fecha DATE NOT NULL,
   monto NUMERIC(9,2) NOT NULL,
   CONSTRAINT fk_id_pedido FOREIGN KEY(id_pedido) REFERENCES VAM_PEDIDOS(id) ON DELETE CASCADE,
   CONSTRAINT pk_pago PRIMARY KEY(id,id_pedido)
);

CREATE TABLE VAM_INGREDIENTE_ESENCIAS(
   cas INTEGER,
   id_proveedor INTEGER,
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

CREATE TABLE VAM_ING_PRESENTACIONES(
    id SERIAL,
    cas_ingrediente INTEGER, --hasta 8
    id_proveedor INTEGER, --1
    volumen NUMERIC(6) NOT NULL,
    precio NUMERIC(9,2) NOT NULL,
    CONSTRAINT fk_ing_presentacion FOREIGN KEY (cas_ingrediente, id_proveedor) REFERENCES VAM_INGREDIENTE_ESENCIAS (cas, id_proveedor) ON DELETE CASCADE,
    CONSTRAINT pk_ing_presentacion PRIMARY KEY (id, cas_ingrediente, id_proveedor)
);

CREATE TABLE VAM_CONTRATOS(
   id SERIAL,
   id_prov INTEGER,
   id_prod INTEGER,
   fecha_emision DATE NOT NULL,
   exclusividad BOOLEAN NOT NULL DEFAULT FALSE,
   clausula VARCHAR(1000),
   fecha_cancelacion DATE,
   motivo_cancel VARCHAR(400),
   quien_cancela VARCHAR(10),
   CONSTRAINT fk_prov_cont FOREIGN KEY(id_prov) REFERENCES VAM_PROVEEDORES(id) ON DELETE CASCADE,
   CONSTRAINT fk_prod_cont FOREIGN KEY(id_prod) REFERENCES VAM_PRODUCTORES(id) ON DELETE CASCADE,
   CONSTRAINT pk_contrato PRIMARY KEY(id,id_prov,id_prod)
);

CREATE TABLE VAM_MP_C(
   id_contrato INTEGER,
   id_cont_prov INTEGER,
   id_cont_prod INTEGER,
   cas INTEGER,
   id_prov_ing INTEGER,
   CONSTRAINT fk_contrato_mp FOREIGN KEY(id_contrato, id_cont_prov, id_cont_prod) REFERENCES VAM_CONTRATOS(id, id_prov, id_prod) ON DELETE CASCADE,
   CONSTRAINT fk_ingred_cont FOREIGN KEY(cas, id_prov_ing) REFERENCES VAM_INGREDIENTE_ESENCIAS(cas, id_proveedor) ON DELETE CASCADE,
   CONSTRAINT pk_mp_c PRIMARY KEY(id_contrato, id_cont_prov, id_cont_prod, cas, id_prov_ing)
);

CREATE TABLE VAM_FE_FP_C(
    id SERIAL,
    id_contrato INTEGER,
    id_prov_cont INTEGER,
    id_prod_cont INTEGER,
    id_form_pago INTEGER,
    id_prov_fp INTEGER,
    id_form_envio INTEGER,
    id_prov_fe INTEGER,
    id_form_envio_pais INTEGER,
    CONSTRAINT fk_contrato FOREIGN KEY (id_contrato, id_prov_cont, id_prod_cont) REFERENCES VAM_CONTRATOS(id, id_prov, id_prod) /*ON DELETE CASCADE*/,
    CONSTRAINT fk_fp_cont FOREIGN KEY (id_form_pago, id_prov_fp) REFERENCES VAM_FORMA_PAGOS(id, id_proveedor) /*ON DELETE CASCADE*/,
    CONSTRAINT fk_fe_cont FOREIGN KEY (id_form_envio, id_prov_fe, id_form_envio_pais) REFERENCES VAM_FORMA_ENVIOS(id, id_prov, id_pais) /*ON DELETE CASCADE*/,
    CONSTRAINT pk_fe_fp_cont PRIMARY KEY (id, id_contrato, id_prov_cont, id_prod_cont)
);

CREATE TABLE VAM_COND_PEDIDO(
    id_pedido INTEGER,
    id_cond INTEGER,
    id_contrato INTEGER,
    id_cont_prov INTEGER,
    id_cont_prod INTEGER,
    CONSTRAINT fk_pedido_con FOREIGN KEY (id_pedido) REFERENCES VAM_PEDIDOS(id) ON DELETE CASCADE,
    CONSTRAINT fk_cond_contr FOREIGN KEY (id_cond, id_contrato, id_cont_prov, id_cont_prod) REFERENCES VAM_FE_FP_C(id, id_contrato, id_prov_cont, id_prod_cont) ON DELETE CASCADE,
    CONSTRAINT pk_cond_pedido PRIMARY KEY (id_pedido, id_cond, id_contrato, id_cont_prov, id_cont_prod)
);

CREATE TABLE VAM_RENOVACIONES(
   id SERIAL,
   id_contrato INTEGER,
   id_cont_prov INTEGER,
   id_cont_prod INTEGER,
   fecha DATE NOT NULL,
   CONSTRAINT fk_renov_cont FOREIGN KEY(id_contrato, id_cont_prov, id_cont_prod) REFERENCES VAM_CONTRATOS(id, id_prov, id_prod) ON DELETE CASCADE,
   CONSTRAINT pk_renov PRIMARY KEY(id, id_contrato, id_cont_prov, id_cont_prod)
);

CREATE TABLE VAM_EVAL_CRITERIOS(
    fecha_inicio DATE,
    id_prod INTEGER,
    id_var_crit INTEGER,
    peso NUMERIC(2) NOT NULL,
    tipo_formula CHAR(1) NOT NULL,
    fecha_fin DATE,
    CONSTRAINT check_tipo CHECK(tipo_formula in ('i','r')),
    CONSTRAINT fk_prod_criterios FOREIGN KEY (id_prod) REFERENCES VAM_PRODUCTORES(id) ON DELETE CASCADE,
    CONSTRAINT fk_var_criterio FOREIGN KEY (id_var_crit) REFERENCES VAM_VAR_CRITERIOS(id) ON DELETE CASCADE,
    CONSTRAINT pk_eval_criterio PRIMARY KEY (fecha_inicio, id_prod, id_var_crit)
);

CREATE TABLE VAM_ING_ORIGEN(
    id_ing_esenc INTEGER,
    id_ing_esenc_prov INTEGER,
    id_pais INTEGER,
    CONSTRAINT fk_origen_ing FOREIGN KEY (id_ing_esenc, id_ing_esenc_prov) REFERENCES VAM_INGREDIENTE_ESENCIAS(cas, id_proveedor) ON DELETE CASCADE,
    CONSTRAINT fk_pais_origen FOREIGN KEY (id_pais) REFERENCES VAM_PAISES(id) ON DELETE CASCADE,
    CONSTRAINT pk_ing_origen PRIMARY KEY (id_ing_esenc, id_ing_esenc_prov, id_pais)
);

CREATE TABLE VAM_ING_OTROS(
    id_ing INTEGER,
    id_prov INTEGER,
    id_otro INTEGER,
    CONSTRAINT fk_ing_prov FOREIGN KEY (id_ing, id_prov) REFERENCES VAM_INGREDIENTE_ESENCIAS(cas, id_proveedor) ON DELETE CASCADE,
    CONSTRAINT fk_otro_ing FOREIGN KEY (id_otro) REFERENCES VAM_OTROS_ING_COMP(id) ON DELETE CASCADE,
    CONSTRAINT pk_ing_otro PRIMARY KEY (id_ing, id_prov, id_otro)
);

CREATE TABLE VAM_DET_PEDIDO(
    id SERIAL,
    id_pedido INTEGER,
    cantidad NUMERIC(6) NOT NULL,
    id_ing_presentacion INTEGER,
    cas_ingrediente INTEGER,
    id_prov_ing INTEGER,
    CONSTRAINT fk_det_pedido FOREIGN KEY (id_pedido) REFERENCES VAM_PEDIDOS(id) ON DELETE CASCADE,
    CONSTRAINT fk_det_ing FOREIGN KEY (id_ing_presentacion, cas_ingrediente, id_prov_ing) REFERENCES VAM_ING_PRESENTACIONES(id, cas_ingrediente, id_proveedor),
    CONSTRAINT pk_det_pedido PRIMARY KEY (id, id_pedido)
);

CREATE TABLE VAM_FLIA_IE(
    id_flia_olfat INTEGER,
    id_ing_esencia INTEGER,
    id_ing_prov INTEGER,
    CONSTRAINT fk_flia_olf_ing FOREIGN KEY (id_flia_olfat) REFERENCES VAM_FLIA_OLFAT(id) ON DELETE CASCADE,
    CONSTRAINT fk_ing_ese FOREIGN KEY (id_ing_esencia, id_ing_prov) REFERENCES VAM_INGREDIENTE_ESENCIAS(cas, id_proveedor) ON DELETE CASCADE,
    CONSTRAINT pk_flia_ie PRIMARY KEY (id_flia_olfat, id_ing_esencia, id_ing_prov)
);