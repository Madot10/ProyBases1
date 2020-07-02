CREATE DATABASE sistema_vam;

--Cambiarse a la BS: \c database_name
--Listar BD: \l o \list
--Listar tablas de una BD: \dt

CREATE TABLE VAM_MP_PROHIBIDAS(
   cas NUMERIC(12) PRIMARY KEY,
   nombre VARCHAR(50) NOT NULL
);

CREATE TABLE VAM_PAISES(
   id SERIAL PRIMARY KEY,
   nombre VARCHAR(20) NOT NULL UNIQUE,
   continente VARCHAR(2) NOT NULL,
   CONSTRAINT check_cont CHECK(continente in ('am', 'eu', 'af', 'as', 'oc'))
);

CREATE TABLE VAM_ASOC_NACIONALES(
   id SERIAL PRIMARY KEY,
   nombre VARCHAR(20) NOT NULL UNIQUE,
   region VARCHAR(2) NOT NULL,
   descripcion VARCHAR(400)
);

--Falta relación N:M con paises
CREATE TABLE VAM_PRODUCTORES(
   id SERIAL PRIMARY KEY,
   nombre VARCHAR(50) NOT NULL,
   email VARCHAR(50) NOT NULL UNIQUE,
   telefono NUMERIC(10) NOT NULL UNIQUE,
   pag_web VARCHAR(100) NOT NULL UNIQUE,
   id_asoc_nac INT,
   CONSTRAINT id_asociacion FOREIGN KEY(id_asoc_nac) REFERENCES VAM_ASOC_NACIONALES(id) ON DELETE SET NULL
);

CREATE TABLE VAM_PROVEEDORES(
   id SERIAL PRIMARY KEY,
   nombre VARCHAR(50) NOT NULL,
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
   tipo VARCHAR(1) NOT NULL CHECK(tipo = 'm' OR tipo = 'a' OR tipo = 'a'),
   cargo NUMERIC(5,2) NOT NULL,
   id_pais INT,
   CONSTRAINT id_prov FOREIGN KEY(id_prov) REFERENCES VAM_PROVEEDORES(id) ON DELETE CASCADE,
   CONSTRAINT id_pais FOREIGN KEY(id_pais) REFERENCES VAM_PAISES(id) ON DELETE CASCADE,
   CONSTRAINT pk_envio_pais_prov PRIMARY KEY(id, id_prov, id_pais)
);

CREATE TABLE VAM_FORMA_PAGOS(
   id SERIAL PRIMARY KEY,
   id_prov INT,
   tipo VARCHAR(4) NOT NULL CHECK(tipo = 'cont' OR tipo = 'cred'),
   porc_inicial NUMERIC(5,2),
   nro_cuotas NUMERIC(3),
   interes_mensual NUMERIC(5,2),
   nro_dia_entre_pago NUMERIC(3),
   CONSTRAINT id_prov FOREIGN KEY(id_prov) REFERENCES VAM_PROVEEDORES(id) ON DELETE CASCADE,
   CONSTRAINT pk_pago_prov PRIMARY KEY(id, id_prov)
);

--Revisar si lleva el atributo tipo (después de la reunión con la profe)
CREATE TABLE VAM_INGREDIENTE_ESENCIAS(
   cas NUMERIC(12),
   id_prov INT,
   nombre VARCHAR(50) NOT NULL,
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
   clausula VARCHAR(1000),
   exclusividad BOOLEAN NOT NULL DEFAULT FALSE,
   motivo_cancel VARCHAR(400),
   fecha_cancelacion DATE,
   quien_cancela VARCHAR(50),
   CONSTRAINT id_prov FOREIGN KEY(id_prov) REFERENCES VAM_PROVEEDORES(id) ON DELETE CASCADE,
   CONSTRAINT id_prod FOREIGN KEY(id_prod) REFERENCES VAM_PRODUCTORES(id) ON DELETE CASCADE,
   CONSTRAINT pk_contrato PRIMARY KEY(id,id_prov,id_prod)
);

--Revisar el ON DELETE SET NULL
CREATE TABLE VAM_RENOVACIONES(
   id SERIAL,
   id_contrato INT,
   id_prov INT,
   id_prod INT,
   fecha DATE NOT NULL,
   CONSTRAINT fk_renov FOREIGN KEY(id_contrato, id_prov, id_prod) REFERENCES VAM_CONTRATOS(id, id_prov, id_prod) ON DELETE CASCADE,
   CONSTRAINT pk_renov PRIMARY KEY(id, id_contrato, id_prov, id_prod)
);

--Interseccion entre Contratos e Ingredientes
CREATE TABLE VAM_MP_C(
   id_contrato INT,
   id_prov_c INT,
   id_prod INT,
   cas NUMERIC(12),
   id_prov_i INT,
   CONSTRAINT fk_contrato FOREIGN KEY(id_contrato, id_prov_c, id_prod) REFERENCES VAM_CONTRATOS(id, id_prov, id_prod) ON DELETE CASCADE,
   CONSTRAINT fk_ingred FOREIGN KEY(cas, id_prov_i) REFERENCES VAM_INGREDIENTE_ESENCIAS(cas, id_prov) ON DELETE CASCADE,
   CONSTRAINT pk_mp_c PRIMARY KEY(id_contrato, id_prov_c, id_prod, cas, id_prov_i)
);

CREATE TABLE VAM_FE_FP_C(
   id_contrato INT,
   id_prov_c INT,
   id_prod INT,
   id_fp INT,
   id_fe INT,
   id_prov_fe INT,
   id_pais INT,
   CONSTRAINT fk_contrato FOREIGN KEY(id_contrato, id_prov_c, id_prod) REFERENCES VAM_CONTRATOS(id, id_prov, id_prod) ON DELETE CASCADE,
   CONSTRAINT pk_fe_fp_c PRIMARY KEY(id_contrato, id_prov_c, id_prod),
   CONSTRAINT fk_fp FOREIGN KEY(id_fp) REFERENCES VAM_FORMA_PAGOS(id),
   CONSTRAINT fk_fe FOREIGN KEY(id_fe, id_prov_fe, id_pais) REFERENCES VAM_FORMA_ENVIOS(id,id_prov,id_pais)
);


CREATE TABLE VAM_PEDIDOS(
   id SERIAL PRIMARY KEY,
   f_emision DATE NOT NULL,
   estado VARCHAR(2) NOT NULL,
   f_confirmacion DATE NOT NULL,
   motivo_cancel VARCHAR(400),
   nro_factura NUMERIC(3),
   total_usd NUMERIC(9,2),
   id_prod INT,
   id_prov INT,
   CONSTRAINT id_prod FOREIGN KEY(id_prod) REFERENCES VAM_PRODUCTORES(id),
   CONSTRAINT id_prov FOREIGN KEY(id_prov) REFERENCES VAM_PROVEEDORES(id)
);

CREATE TABLE PAGOS(
   id SERIAL,
   id_ped INT,
   fecha DATE NOT NULL,
   monto NUMERIC(9,2) NOT NULL,
   CONSTRAINT id_pedido FOREIGN KEY(id_ped) REFERENCES VAM_PEDIDOS(id) ON DELETE CASCADE,
   CONSTRAINT pk_pedido PRIMARY KEY(id,id_ped)
);


--Datos de prueba 

INSERT INTO VAM_PAISES(nombre,continente) VALUES('Francia','eu');
INSERT INTO VAM_PAISES(nombre,continente) VALUES('Estados Unidos','am');

INSERT INTO VAM_PROVEEDORES(nombre,email,telefono,pag_web,id_pais) VALUES('PROVEEDOR 1', 'hola1@gmail.com', 215327654, 'www.juanito.com', 1);
INSERT INTO VAM_PROVEEDORES(nombre,email,telefono,pag_web,id_pais) VALUES('PROVEEDOR 2', 'hola2@gmail.com', 2123982454, 'www.juanito1.com', 2);

INSERT INTO VAM_PRODUCTORES(nombre,email,telefono,pag_web) VALUES('PRODUCTOR 1', 'hola@gmail.com', 2123555654, 'www.juanito3.com');
INSERT INTO VAM_PRODUCTORES(nombre,email,telefono,pag_web) VALUES('PRODUCTOR 2', 'hola3@gmail.com', 2123354, 'www.juanito4.com');

INSERT INTO VAM_INGREDIENTE_ESENCIAS(cas,id_prov,nombre,descripcion,taxonomia) VALUES(1234,1,'naranjita','soy naranjita','naranjus medium');

INSERT INTO VAM_INGREDIENTE_ESENCIAS(cas,id_prov,nombre,descripcion,taxonomia) VALUES(132354,1,'manzanita','soy manzanita','manzanis tilum');

INSERT INTO VAM_CONTRATOS(id_prov,id_prod,fecha_emision,exclusividad) VALUES(1,1,'10-10-2020',DEFAULT);

INSERT INTO VAM_CONTRATOS(id_prov,id_prod,fecha_emision,exclusividad) VALUES(4,1,'10-19-2020',DEFAULT);


INSERT INTO VAM_MP_C VALUES(1,1,1,1234,1);
INSERT INTO VAM_MP_C VALUES(3,4,1,132354,1);

--Borrar tablas
DROP TABLE VAM_PROVEEDORES;
DROP TABLE VAM_PRODUCTORES;
DROP TABLE VAM_FORMA_ENVIOS;
DROP TABLE VAM_FORMA_PAGOS;
DROP TABLE VAM_PAISES;
DROP TABLE VAM_CONTRATOS;
