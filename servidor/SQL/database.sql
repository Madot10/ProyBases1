CREATE DATABASE sistema_vam;

--Cambiarse a la BS: \c database_name
--Listar BD: \l o \list
--Listar tablas de una BD: \dt

CREATE TABLE MP_PROHIBIDA(
   cas NUMERIC(12) PRIMARY KEY,
   nombre VARCHAR(50) NOT NULL
);

--Está en "veremos"
CREATE TABLE CONTINENTE(
   id SERIAL PRIMARY KEY,
   nombre VARCHAR(10) NOT NULL UNIQUE
);


CREATE TABLE PAIS(
   id SERIAL PRIMARY KEY,
   nombre VARCHAR(20) NOT NULL UNIQUE,
   continente VARCHAR(2) NOT NULL,
   CONSTRAINT check_cont CHECK(continente in ('am', 'eu', 'af', 'as', 'oc'))
);

--Falta colocarle el FK con la compuesta con Pais
CREATE TABLE PRODUCTOR(
   id SERIAL PRIMARY KEY,
   nombre VARCHAR(50) NOT NULL,
   email VARCHAR(50) NOT NULL UNIQUE,
   telefono NUMERIC(10) NOT NULL UNIQUE,
   pag_web VARCHAR(100) NOT NULL UNIQUE
   --id_pais INT,
   --CONSTRAINT id_pais FOREIGN KEY(id_pais) REFERENCES PAIS(id) ON DELETE SET NULL
);

CREATE TABLE PROVEEDOR(
   id SERIAL PRIMARY KEY,
   nombre VARCHAR(50) NOT NULL,
   email VARCHAR(50) NOT NULL UNIQUE,
   telefono NUMERIC(10) NOT NULL UNIQUE,
   pag_web VARCHAR(100) NOT NULL UNIQUE,
   id_pais INT,
   CONSTRAINT id_pais FOREIGN KEY(id_pais) REFERENCES PAIS(id) ON DELETE SET NULL
);

--Falta colocarle el PK compuesta con PROVEEDOR
CREATE TABLE FORMA_ENVIO(
   id SERIAL,
   id_prov INT,
   tipo VARCHAR(1) NOT NULL CHECK(tipo = 'm' OR tipo = 'a' OR tipo = 'a'),
   cargo NUMERIC(5,2) NOT NULL,
   id_pais INT,
   CONSTRAINT id_pais FOREIGN KEY(id_pais) REFERENCES PAIS(id) ON DELETE SET NULL,
   CONSTRAINT id_prov FOREIGN KEY(id_prov) REFERENCES PROVEEDOR(id),
   CONSTRAINT id_forma_pais PRIMARY KEY(id, id_prov)
);


-- Cambiarlo de acuerdo a la corrección del mates
CREATE TABLE FORMA_PAGO(
   id SERIAL PRIMARY KEY,
   tipo VARCHAR(4) NOT NULL CHECK(tipo = 'cont' OR tipo = 'cred'),
   porc_inicial NUMERIC(5,2),
   nro_cuotas NUMERIC(3),
   interes_mensual NUMERIC(5,2),
   nro_dia_entre_pago NUMERIC(3),
   id_prov INT,
   CONSTRAINT id_prov FOREIGN KEY(id_prov) REFERENCES PROVEEDOR(id) ON DELETE SET NULL
);

--Revisar si lleva el atributo tipo (después de la reunión con la profe)
CREATE TABLE INGREDIENTE_ESENCIAS(
   cas NUMERIC(12),
   id_proveedor INT,
   nombre VARCHAR(50) NOT NULL,
   descripcion VARCHAR(400) NOT NULL,
   taxonomia VARCHAR(50) NOT NULL,
   punto_ebul NUMERIC(4),
   punto_inflam NUMERIC(4),
   proc_extrac VARCHAR(400),
   descrip_proceso VARCHAR(400),
   CONSTRAINT id_prov FOREIGN KEY(id_proveedor) REFERENCES PROVEEDOR(id) ON DELETE SET NULL,
   CONSTRAINT pk_ingred PRIMARY KEY(cas, id_prov)
);

CREATE TABLE CONTRATO(
   id NUMERIC(12),
   id_proveedor INT,
   id_productor INT,
   fecha_emision DATE NOT NULL,
   clausula VARCHAR(1000),
   exclusividad BOOLEAN NOT NULL,
   motivo_cancel VARCHAR(400),
   fecha_cancelacion DATE,
   quien_cancela VARCHAR(50),
   CONSTRAINT pk_contrato PRIMARY KEY(id,id_proveedor,id_productor)
);

ALTER TABLE CONTRATO ALTER COLUMN exclusividad
SET DEFAULT FALSE;

CREATE TABLE RENOVACION(
   id SERIAL,
   id_contrato INT,
   id_proveedor INT,
   id_productor INT,
   fecha DATE,
   CONSTRAINT fk_renov FOREIGN KEY(id_contrato, id_proveedor, id_productor) REFERENCES CONTRATO(id, id_proveedor, id_productor) ON DELETE SET NULL,
   CONSTRAINT pk_renov PRIMARY KEY(id, id_contrato, id_proveedor, id_productor)
);

CREATE TABLE PEDIDO(
   id SERIAL PRIMARY KEY,
   f_emision DATE NOT NULL,
   estado VARCHAR(2) NOT NULL,
   f_confirmacion DATE NOT NULL,
   motivo_cancel VARCHAR(400),
   nro_factura NUMERIC(3),
   total_usd NUMERIC(9,2)
);

CREATE TABLE PAGO(
   id SERIAL PRIMARY KEY,
   fecha DATE NOT NULL,
   monto NUMERIC(9,2) NOT NULL
);


--Datos de prueba 

INSERT INTO PAIS VALUES(1, 'Francia', 'eu');

INSERT INTO PROVEEDOR VALUES(1, 'Juanito', 'hola@gmail.com', 2123987654, 'www.juanito.com', 1);

--Borrar tablas
DROP TABLE PROVEEDOR;
DROP TABLE PRODUCTOR;
DROP TABLE CONTINENTE;
DROP TABLE FORMA_ENVIO;
DROP TABLE FORMA_PAGO;
DROP TABLE PAIS;
DROP TABLE CONTRATO;